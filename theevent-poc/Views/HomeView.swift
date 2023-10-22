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
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Artists").font(.headline)) {
                    ForEach(sortedArtistsResponse) { artist in
                        Button(action: {
                            selectedEntity = artist
                        }) {
                            Text(artist.name ?? "empty")
                        }
                    }
                }
                
                Section(header: Text("Venues").font(.headline)) {
                    ForEach(sortedVenuessResponse) { venue in
                        Button(action: {
                            selectedEntity = venue
                        }) {
                            Text(venue.name ?? "empty")
                        }
                    }
                }
            }
            .navigationBarTitle("Events", displayMode: .automatic)
        }
        .sheet(item: $selectedEntity, content: { artist in
            DetailsView(entity: artist, venue: selectedVenue(from: homeViewModel.venues, selectedArtist: artist))
        })
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
    
    private func selectedVenue(from venues: [EventResponse], selectedArtist: EventResponse) -> EventResponse? {
        let id = selectedArtist.id
        
        for venue in venues {
            if venue.id == id {
                return venue
            }
        }
        return nil
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
