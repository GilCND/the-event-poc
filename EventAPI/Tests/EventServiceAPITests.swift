//
//  EventServiceAPITests.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import XCTest
@testable import EventAPI

class EventServiceAPITests: XCTestCase {
    var mockURLSession: MockNetworkService!
    var sut: EventServiceAPI!
    
    override func setUp() {
        mockURLSession = MockNetworkService()
        sut = EventServiceAPI(urlSession: mockURLSession)
    }
    
    func testFetchEntitySuccess() throws {
        let fileURL = Bundle.module.url(forResource: "event", withExtension: "json")!
        let data = try Data(contentsOf: fileURL)
        mockURLSession.data = data
        mockURLSession.statusCode = 200
        
        let expectation = XCTestExpectation()
        
        sut.fetchEntity(using: .all, eventParams: .artists(id: nil)) { (result: Result<[EventResponse], Error>) in
            
            let components = URLComponents(url: self.mockURLSession.request!.url!, resolvingAgainstBaseURL: true)
            XCTAssertEqual(components?.host, "ec2-44-211-66-223.compute-1.amazonaws.com")
            XCTAssertEqual(components?.path, "/artists/")
            
            switch result {
            case .success(let event):
                XCTAssertFalse(event.isEmpty)
            case .failure:
                XCTFail("Fetching recentPodcasts should not result in failure")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
