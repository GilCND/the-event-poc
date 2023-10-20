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
    func fetchSongEvent(using queryType: QueryType, eventParams: EventParams, completion: @escaping (Result<[EventResponse], Error>) -> Void)
}
