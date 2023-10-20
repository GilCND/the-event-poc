//
//  URLSession+NetworkService.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import Foundation

extension URLSession: NetworkService {
    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkServiceDataTask {
        let task: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
}

extension URLSessionDataTask: NetworkServiceDataTask { }
