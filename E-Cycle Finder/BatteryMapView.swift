//
//  BatteryMapView.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-01-19.
//
import SwiftData
import SwiftUI
import MapKit
import CoreLocation

struct BatteryMapView: View {
    var selectedBattery: BatteryTypeOption
    
    @Environment(\.modelContext) private var context
    @Query var locations: [Location]
    
    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 20
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
        static let chipCornerRadius: CGFloat = 12
        static let mapHeight: CGFloat = 320
    }
    
    private enum Theme {
        static let titleFont = Font.system(.title2, design: .rounded).weight(.semibold)
        static let bodyFont = Font.system(.subheadline, design: .rounded)
        static let accent = Color.green
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    private var fallbackSeeds: [SeedLocation] {
        SeedData.cachedOrDefault()
    }
    
    private var displayLocations: [MapPoint] {
        if locations.isEmpty {
            return fallbackSeeds.map { MapPoint(name: $0.name, coordinate: CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)) }
        }
        return locations.map { MapPoint(name: $0.name, coordinate: $0.coordinate) }
    }
    
    private var nearbyDisplay: [MapPoint] {
        let centerLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        return displayLocations.sorted { lhs, rhs in
            let lhsDistance = centerLocation.distance(from: CLLocation(latitude: lhs.coordinate.latitude, longitude: lhs.coordinate.longitude))
            let rhsDistance = centerLocation.distance(from: CLLocation(latitude: rhs.coordinate.latitude, longitude: rhs.coordinate.longitude))
            return lhsDistance < rhsDistance
        }
    }
    
    private func updateRegionToFitLocations() {
        let targets = displayLocations
        guard !targets.isEmpty else { return }
        let lats = targets.map { $0.coordinate.latitude }
        let longs = targets.map { $0.coordinate.longitude }
        guard let minLat = lats.min(), let maxLat = lats.max(), let minLong = longs.min(), let maxLong = longs.max() else { return }
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2.0,
            longitude: (minLong + maxLong) / 2.0
        )
        let latDelta = max((maxLat - minLat) * 1.5, 0.05)
        let longDelta = max((maxLong - minLong) * 1.5, 0.05)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        region = MKCoordinateRegion(center: center, span: span)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                EcoDecorativeBackground()
                
                ScrollView {
                    VStack(spacing: UI.sectionSpacing) {
                        headerSection
                        mapSection
                        listSection
                    }
                    .padding(UI.outerPadding)
                }
            }
        }
        .onAppear {
            updateRegionToFitLocations()
        }
        .onChange(of: locations.count) { _ in
            updateRegionToFitLocations()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            // MARK: Header Card
            Image(systemName: "battery.100.bolt")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(Theme.accent)
            
            Text("Battery Recycling")
                .font(Theme.titleFont)
            
            Text("\(selectedBattery)")
                .font(Theme.bodyFont)
                .foregroundStyle(.secondary)
            
            Text("Locations: \(displayLocations.count)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: UI.chipCornerRadius, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
    
    private struct MapPoint: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
    
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recycling Locations")
                .font(.headline)
            
            // MARK: Map Card
            Map(coordinateRegion: $region, annotationItems: displayLocations) { point in
                MapAnnotation(coordinate: point.coordinate) {

                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 36, height: 36)

                            Image(systemName: "leaf.fill")
                                .foregroundColor(.white)
                        }
                        .shadow(color: .green.opacity(0.4), radius: 6, x: 0, y: 4)

                        Text(point.name)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                    }
                }
            }
            .onAppear { updateRegionToFitLocations() }
            .task { updateRegionToFitLocations() }
            .onChange(of: locations.count) { _ in updateRegionToFitLocations() }
            .frame(height: UI.mapHeight)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
    
    private var listSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nearby Recycling Centers")
                .font(.headline)
            
            if nearbyDisplay.isEmpty {
                Text("No locations found.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(nearbyDisplay.prefix(5).enumerated()), id: \.offset) { _, point in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundStyle(Theme.accent)
                            Text(point.name)
                                .font(.headline)
                            Spacer()
                            Text(distanceText(for: point))
                                .font(.subheadline)
                                .foregroundStyle(Theme.accent)
                        }
                        
                        Text("Open 9am – 6pm")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
}

private extension BatteryMapView {
     private func distanceText(for point: MapPoint) -> String {
        let centerLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        let distanceKm = centerLocation.distance(from: CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)) / 1000.0
        return String(format: "%.1f km", distanceKm)
    }
}

