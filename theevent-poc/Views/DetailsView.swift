//
//  DetailsView.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-21.
//

import SwiftUI
import EventAPI

enum EntitySelected {
    case venue, artist
}

struct DetailsView: View {
    var entity: EventResponse
    var venue: EventResponse?
    var entitySelected : EntitySelected
    @Environment(\.dismiss) var dismiss
    @StateObject var detailsViewModel: DetailsViewModel
    
    
    init(entity: EventResponse, venue: EventResponse?, entitySelected: EntitySelected) {
        self.entity = entity
        self.venue = venue
        self.entitySelected = entitySelected
        self._detailsViewModel = StateObject(wrappedValue: DetailsViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    switch entitySelected {
                    case .venue:
                        entityImage(eventParams: .artists(id: nil), entity: entity)
                            .padding()
                    case .artist:
                        if let venue = venue {
                            entityImage(eventParams: .venue(id: nil), entity: venue)
                                .padding()
                        }
                    }
                    VStack (spacing: 15) {
                        entityName
                        entityGenre
                        venueName
                    }
                    .padding()
                }
                entityPerformances
            }
            .navigationBarItems(trailing: dismissButton)
        }
        .onAppear() {
            detailsViewModel.fetchPerformances(name: entity.name ?? "", id: entity.id )
        }
    }
    
    var entityGenre: some View {
        VStack {
            Text("Genre")
                .bold()
                .font(.title2)
            Text(entity.genre ?? "")
        }
    }
    
    var entityName: some View {
        VStack {
            Text("Artist")
                .bold()
                .font(.title2)
            Text(entity.name ?? "")
        }
    }
    
    var venueName: some View {
        VStack {
            if venue?.name != entity.name {
                Text("Venue")
                    .bold()
                    .font(.title2)
                Text(venue?.name ?? "")
            }
        }
    }
    
    var entityPerformances: some View {
        VStack {
            Text("Next Performances")
                .bold()
                .font(.title2)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(detailsViewModel.performances, id: \.id) { performance in
                        if let dateTime = performance.date?.splitISODateAndTime() {
                            HStack {
                                Text(dateTime.date)
                                    .padding(.vertical, 10)
                                Spacer()
                                Text(dateTime.time)
                                    .padding(.vertical, 10)
                            }
                            .padding(.horizontal, 100)
                        } else {
                            Text("Invalid date format")
                        }
                    }
                }
            }
        }
    }
    
    func entityImage(eventParams: EventParams, entity: EventResponse) -> some View {
        let url: String = detailsViewModel.buildImageURL(name: entity.name ?? "", eventParams: eventParams)
        return ImageCard(size: .small, url: url)
    }
    
    var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "x.circle.fill")
        }
    }
}
