//
//  Data.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-02-15.
//
import SwiftData
import CoreLocation

@Model
class Location {
    var name: String
    var long: Double
    var lat: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    init(name: String, long: Double, lat: Double) {
        self.name = name
        self.long = long
        self.lat = lat
    }
}
