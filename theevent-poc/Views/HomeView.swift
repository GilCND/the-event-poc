//
//  HomeView.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-20.
//

import SwiftUI
import EventAPI
import os

struct HomeView: View {
    @State private var selectedEntity: EventResponse? = nil
    @State private var isPresented: Bool = false
    @State private var wasArtistSelected: Bool = false
    @State private var showDetailsView: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Artists").font(.headline)) {
                    ForEach(sortedArtistsResponse) { artist in
                        Button(action: {
                            wasArtistSelected = true
                            isPresented.toggle()
                            selectedEntity = artist
                        }) {
                            Text(artist.name ?? "empty")
                        }
                    }
                }
                
                Section(header: Text("Venues").font(.headline)) {
                    ForEach(sortedVenuessResponse) { venue in
                        Button(action: {
                            wasArtistSelected = false
                            isPresented.toggle()
                            selectedEntity = venue
                        }) {
                            Text(venue.name ?? "empty")
                        }
                    }
                }
            }
            .navigationBarTitle("Events", displayMode: .automatic)
            .onChange(of: selectedEntity, { _, _ in
                showDetailsView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showDetailsView = true
                }
            })
        }
        .sheet(isPresented: $isPresented) {
            if let selected = selectedEntity {
                if let entity = selectedEntity(from: homeViewModel.artists, selectedEntity: selected),
                   let venue = selectedEntity(from: homeViewModel.venues, selectedEntity: selected) {
                    DetailsView(
                        entity: entity,
                        venue: venue,
                        entitySelected: wasArtistSelected ? .artist : .venue
                    )
                }
            }
        }
        .onAppear {
            homeViewModel.updateEvents()
        }
    }
    
    private func artistsList() -> some View {
        return List(homeViewModel.artists) { artist in
            VStack {
                if let genre = artist.genre {
                    Text(genre)
                }
            }
        }
    }
    
    private func selectedEntity(from generalEntity: [EventResponse], selectedEntity: EventResponse) -> EventResponse? {
        let id = selectedEntity.id
        
        for entity in generalEntity {
            if entity.id == id {
                return entity
            }
        }
        return selectedEntity
    }
    
    
    private func venueList() -> some View {
        return List(homeViewModel.venues) { venue in
            VStack {
                if let venueID = venue.venueID {
                    Text("\(venueID)")
                }
            }
        }
    }
    
    var sortedArtistsResponse: [EventResponse] {
        homeViewModel.artists.sorted { (event1, event2) -> Bool in
            guard let name1 = event1.name, let name2 = event2.name else {
                return false
            }
            return name1 < name2
        }
    }
    
    var sortedVenuessResponse: [EventResponse] {
        homeViewModel.venues.sorted { (event1, event2) -> Bool in
            guard let sortID1 = event1.sortID, let sortID2 = event2.sortID else {
                return false
            }
            return sortID1 < sortID2
        }
    }
}

#Preview {
    HomeView()
}
