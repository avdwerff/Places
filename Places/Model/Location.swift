//
//  Location.swift
//  Places
//
//  Created by Alexander van der Werff on 25/03/2026.
//

import Foundation
import CoreLocation

nonisolated struct Location: Codable, Equatable, Sendable, CustomStringConvertible {
    let name: String?
    let coordinate: CLLocationCoordinate2D
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
    
    init(name: String? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
    
    var description: String {
        let coords = "\(coordinate.latitude), \(coordinate.longitude)"
        if let name {
            return "\(name) (\(coords))"
        }
        return coords
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.name == rhs.name
        && lhs.coordinate.latitude == rhs.coordinate.latitude
        && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}


extension Location {
    var coordinateDescription: String {
        "\(coordinate.latitude), \(coordinate.longitude)"
    }
    
    var accessibilityDescription: String {
        if let name {
            return "\(name), latitude \(coordinate.latitude), longitude \(coordinate.longitude)"
        }
        return "Latitude \(coordinate.latitude), longitude \(coordinate.longitude)"
    }
}

extension Location: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(name)
    }
}
