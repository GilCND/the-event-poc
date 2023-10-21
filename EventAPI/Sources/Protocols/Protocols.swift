//
//  Protocols.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import Foundation

public protocol NetworkService {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> NetworkServiceDataTask
}

public protocol NetworkServiceDataTask {
    func resume()
}

public protocol EventService {
    func fetchEntity<T: Decodable>(using queryType: QueryType, eventParams: EventParams, completion: @escaping (Result<T, Error>) -> Void)
    func imageURLBuilder(name: String, eventParams: EventParams) -> URL?
}
