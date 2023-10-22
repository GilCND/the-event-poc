//
//  DetailsViewModel.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-21.
//

import Foundation
import SwiftUI
import EventAPI
import os

class DetailsViewModel: ObservableObject {
    private var eventService: EventService
    @Published var performances: [EventResponse] = []

    
    init(eventService: EventService = EventServiceAPI()) {
        self.eventService = eventService
    }
    
    func fetchPerformances(name: String, id: Int) {
        eventService.fetchEntity(using: .fromTo, eventParams: .performances(id: id)) { [weak self] (result: Result<[EventResponse], Error>) in
            switch result {
            case .success(let performances):
                DispatchQueue.main.async {
                    self?.performances = performances
                }
            case .failure(let error):
                Logger.viewCycle.error("Error: \(error)")
                self?.performances = []
            }
        }
    }
    
    func buildImageURL(name: String, eventParams: EventParams) -> String {
        return eventService.imageURLBuilder(name: name, eventParams: eventParams)?.absoluteString ?? ""
    }
}
