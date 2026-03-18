//
//  Other Tech.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-01-28.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation

enum OtherTechType: String, CaseIterable, Identifiable {
    case laptop
    case cellPhone
    case tablet

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .laptop: return "Laptops"
        case .cellPhone: return "Cell Phones"
        case .tablet: return "Tablets"
        }
    }

    var iconName: String {
        switch self {
        case .laptop: return "laptopcomputer"
        case .cellPhone: return "iphone"
        case .tablet: return "ipad"
        }
    }
}

enum MapPurpose {
    case recycle
    case repair

    var titlePrefix: String {
        switch self {
        case .recycle: return "Recycle:"
        case .repair: return "Repair:"
        }
    }
}

struct Other_Tech: View {
    @State private var selectedType: OtherTechType? = nil
    @State private var showChoiceDialog = false
    @State private var navigateToMap = false
    @State private var purpose: MapPurpose = .recycle

    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
    }

    var body: some View {
        NavigationStack {
            ZStack {
                EcoDecorativeBackground()

                ScrollView {
                    VStack(spacing: UI.sectionSpacing) {
                        headerCard
                        optionsCard
                    }
                    .padding(UI.outerPadding)
                }
            }
        }
        .navigationTitle("Other E‑Waste")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToMap) {
            OtherTechPlaceholderMapView(selectedType: selectedType ?? .laptop, purpose: purpose)
        }
        .confirmationDialog(
            "Would you like to repair it instead?",
            isPresented: $showChoiceDialog,
            titleVisibility: .visible
        ) {
            Button("Yes, find repair near me") {
                purpose = .repair
                navigateToMap = true
            }
            Button("No, recycle it") {
                purpose = .recycle
                navigateToMap = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Choose an option for your selected item.")
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "desktopcomputer")
                    .font(.title3)
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recycle or repair your tech")
                        .font(.title2.weight(.semibold))
                    Text("Choose an item to see nearby options.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var optionsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Select a device type")
                .font(.headline)
            ForEach(OtherTechType.allCases) { type in
                Button {
                    selectedType = type
                    showChoiceDialog = true
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: type.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 28)
                            .foregroundStyle(.blue)
                        Text(type.displayName)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.blue.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
                }
            }
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
}

struct OtherTechPlaceholderMapView: View {
    var selectedType: OtherTechType
    var purpose: MapPurpose = .recycle

    private struct MapPoint: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }

    private let placeholderPoints: [MapPoint] = [
        MapPoint(name: "Eco Repair Hub", coordinate: .init(latitude: 49.276, longitude: -123.118)),
        MapPoint(name: "Sustainable Tech Depot", coordinate: .init(latitude: 49.265, longitude: -123.105)),
        MapPoint(name: "Urban Recycle Center", coordinate: .init(latitude: 49.255, longitude: -123.125)),
        MapPoint(name: "Green Gadget Dropoff", coordinate: .init(latitude: 49.245, longitude: -123.110))
    ]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.265, longitude: -123.115),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
        static let mapHeight: CGFloat = 320
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()

            ScrollView {
                VStack(spacing: UI.sectionSpacing) {
                    headerCard
                    mapCard
                    listCard
                }
                .padding(UI.outerPadding)
            }
        }
        .navigationTitle("\(purpose.titlePrefix) \(selectedType.displayName)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                Text("Nearby Options")
                    .font(.title2.weight(.semibold))
            }
            Text("Showing placeholder locations for now.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var mapCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Map")
                .font(.headline)
            Map(coordinateRegion: $region, annotationItems: placeholderPoints) { point in
                MapAnnotation(coordinate: point.coordinate) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle().fill(Color.green).frame(width: 32, height: 32)
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.white)
                        }
                        Text(point.name)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: UI.mapHeight)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var listCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Placeholder Locations")
                .font(.headline)
            ForEach(placeholderPoints) { point in
                VStack(alignment: .leading, spacing: 6) {
                    Text(point.name)
                        .font(.headline)
                    Text("Lat: \(point.coordinate.latitude), Long: \(point.coordinate.longitude)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        Other_Tech()
    }
}
