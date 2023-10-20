//
//  EventResponse.swift
//
//
//  Created by Felipe Gil on 2023-10-19.
//

import Foundation

public struct EventResponse: Decodable, Identifiable, Equatable {
    public let artist: [Artists]?
    public let artistID: Int?
    public let date: String?
    public let genre: String?
    public let id: Int?
    public let name: String?
    public let sortID: Int?
    public let venue: [Venue]?
    public let venueID: String?

    enum CodingKeys: String, CodingKey {
        case artistID = "artistId"
        case sortID = "sortId"
        case venueID = "venueId"
        case date, genre, id, name, artist, venue
    }
}

public struct Venue: Decodable, Identifiable, Equatable {
    public let id: Int
    public let name: String?
    public let sortID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, sortID = "sortId"
    }
}

public struct Artists: Decodable, Identifiable, Equatable {
    public let genre: String?
    public let id: Int
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case genre, id, name
    }
}
