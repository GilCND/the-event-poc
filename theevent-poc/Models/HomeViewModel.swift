//
//  HomeViewModel.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-20.
//

import Foundation
import SwiftUI
import EventAPI
import os

class HomeViewModel: ObservableObject {
    private var eventService: EventService
    @Published var artists: [EventResponse] = []
    @Published var venues: [EventResponse] = []
    
    init(eventService: EventService = EventServiceAPI()) {
        self.eventService = eventService
        updateEvents()
    }
    
    func updateEvents() {
        fetchEntity(eventParams: .artists(id: nil)) { [weak self] artist in
            DispatchQueue.main.async {
                self?.artists = artist
            }
        }
        fetchEntity(eventParams: .venue(id: nil)) { [weak self] venue in
            DispatchQueue.main.async {
                self?.venues = venue
            }
        }
    }
    
    func fetchEntity(eventParams: EventParams, completion: @escaping ([EventResponse]) -> Void) {
        eventService.fetchEntity(using: .all, eventParams: eventParams) { (result: Result<[EventResponse], Error>) in
            switch result {
            case .success(let artists):
                DispatchQueue.main.async {
                    completion(artists)
                }
            case .failure(let error):
                Logger.viewCycle.error("Error: \(error)")
                print("\(error)")
                completion([])
            }
        }
    }
    
    func searchEntity(eventParams: EventParams, completion: @escaping (EventResponse) -> Void) {
        eventService.fetchEntity(using: .fromTo, eventParams: eventParams) {(result: Result<EventResponse, Error>) in
            switch result {
            case .success(let artists):
                DispatchQueue.main.async {
                    completion(artists)
                }
            case .failure(let error):
                Logger.viewCycle.error("Error: \(error)")
                print("\(error)")
            }
        }
    }
}
