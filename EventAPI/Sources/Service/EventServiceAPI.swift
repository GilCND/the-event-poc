//
//  SongServiceAPI.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import Foundation
import os

public enum NetworkError: Error, CustomStringConvertible {
    case badURL, emptyData, badDecoding, credentialError
    case networkError(Error)
    case notHTTPURLResponse(URLResponse?)
    case httpError(Int)
    public var description: String {
        switch self {
        case .badURL:
            return "Bad URL"
        case .emptyData:
            return "Empty Data"
        case .badDecoding:
            return "Bad Decoding"
        case .credentialError:
            return "Credentials were rejected"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .notHTTPURLResponse(let urlResponse):
            return "Not HTTPURLResponse: \(String(describing: urlResponse))"
        case .httpError(let statusCode):
            return "Status code: \(statusCode)"
        }
    }
}

public enum QueryType {
    case since
    case fromTo
    case all
}

public enum EventParams {
    case artists(id: Int?)
    case venue(id: Int?)
    case performances(id: Int?)
 }

public struct EventServiceAPI: EventService {
    private let urlSession: NetworkService
    private let logger = Logger()
    
    public init (urlSession: NetworkService = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private func serviceAPI(relativePath: String, queryItems: [URLQueryItem] = [], completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "ec2-44-211-66-223.compute-1.amazonaws.com"
        components.path += relativePath
        //components.queryItems = [URLQueryItem(name: "pretty", value: nil)]
        components.queryItems?.append(contentsOf: queryItems)
        
        if let url = components.url {
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("TheEvent/0.1", forHTTPHeaderField: "User-Agent")
            request.httpMethod = "GET"
            
            print(url)
            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.notHTTPURLResponse(response ?? nil)))
                    return
                }
                
                if (200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(.emptyData))
                    }
                } else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                }
            }
            task.resume()
        }
    }
    
    private func fetchData<T: Decodable>(relativePath: String, queryItems: [URLQueryItem] = [], decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<T, NetworkError>) -> Void) {
        serviceAPI(relativePath: relativePath, queryItems: queryItems) { result in
            
            switch result {
            case .success(let data):
                print(String(data: data, encoding: .utf8) ?? "No Data String")
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
//                } catch {
//                    completion(.failure(.badDecoding))
//                }
                } catch {
                    print("Error decoding JSON: \(error)")
                    if let decodingError = error as? DecodingError {
                        print("DecodingError: \(decodingError)")
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: Fetch Song Event
    public func fetchSongEvent(using queryType: QueryType, eventParams: EventParams, completion: @escaping (Result<[EventResponse], Error>) -> Void) {
        var relativePath = ""
        var queryItems: [URLQueryItem] = []
        let currentDate = Date()
        let twoWeeksAhead = Calendar.current.date(byAdding: .day, value: +13, to: currentDate)
        
        switch eventParams {
        //TODO: Implement ID
        case .artists(let id):
            relativePath = "/artists"
        case .venue(let id) :
            relativePath = "/venue"
        case .performances(let id) :
            relativePath =  "/performances"
        }
       
        switch queryType {
        case .since :
                queryItems = [URLQueryItem(name: "from", value: "\(currentDate)")]
        case .fromTo:
            if let twoWeeksAhead {
                let timeStamp = Int(twoWeeksAhead.timeIntervalSince1970)
                queryItems = [URLQueryItem(name: "from", value: "\(currentDate)"),               URLQueryItem(name: "to", value: "\(timeStamp)")]
            }
        case .all:
            queryItems = []
        }
        
        fetchData(relativePath: relativePath, queryItems: queryItems) { (result: Result<[EventResponse], NetworkError>) in
            switch result {
            case .success(let decodedData):
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            case .failure(let error):
                self.logger.error("Error retrieving data from the API: \(error)")
                completion(.failure(error))
            }
        }
    }
}
