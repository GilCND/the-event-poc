//
//  Mocks.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import Foundation
import EventAPI

class MockNetworkService: NetworkService {
    var data: Data?
    var statusCode: Int?
    var error: Error?
    var request: URLRequest?
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> NetworkServiceDataTask {
        self.request = request
        return MockNetworkServiceDataTask {
            let response = HTTPURLResponse(url: request.url!, statusCode: self.statusCode ?? 200, httpVersion: nil, headerFields: nil)
            
            completionHandler(self.data, response, self.error)
        }
    }
}

struct MockNetworkServiceDataTask: NetworkServiceDataTask {
    let resumeCompletionHandler: () -> Void
    
    init (resumeCompletionHandler: @escaping () -> Void) {
        self.resumeCompletionHandler = resumeCompletionHandler
    }
    func resume() {
        return resumeCompletionHandler()
    }
}
