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

enum OtherTechRoute: Hashable {
    case action(OtherTechType)
    case map(OtherTechType, MapPurpose)
}

struct Other_Tech: View {
    @State private var path = NavigationPath()

    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
    }

    var body: some View {
        NavigationStack(path: $path) {
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
            .navigationTitle("Other E‑Waste")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: OtherTechRoute.self) { route in
                switch route {
                case .action(let type):
                    OtherTechActionView(type: type) { purpose in
                        path.append(OtherTechRoute.map(type, purpose))
                    }
                case .map(let type, let purpose):
                    OtherTechMapFlowView(selectedType: type, purpose: purpose)
                }
            }
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
                DeviceOptionRow(type: type) {
                    path.append(OtherTechRoute.action(type))
                }
            }
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private struct DeviceOptionRow: View {
        var type: OtherTechType
        var action: () -> Void

        private enum RowUI {
            static let cornerRadius: CGFloat = 18
            static let padding: CGFloat = 12
        }

        var body: some View {
            Button(action: action) {
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
                .padding(RowUI.padding)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: RowUI.cornerRadius, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: RowUI.cornerRadius, style: .continuous)
                    .stroke(Color.blue.opacity(0.25), lineWidth: 1))
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
            }
        }
    }
}

struct OtherTechActionView: View {
    var type: OtherTechType
    var onChoice: (MapPurpose) -> Void

    private enum UI {
        static let cardPadding: CGFloat = 20
        static let cardCornerRadius: CGFloat = 18
        static let spacing: CGFloat = 16
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()
            VStack(spacing: UI.spacing) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What would you like to do?")
                        .font(.title2.weight(.semibold))
                    Text("Select whether you want to recycle or repair your \(type.displayName.lowercased()).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(UI.cardPadding)
                .background(Color(.systemBackground).opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))

                HStack(spacing: UI.spacing) {
                    ChoiceButton(title: "Repair", subtitle: "Find repair shops", color: .green) {
                        onChoice(.repair)
                    }
                    ChoiceButton(title: "Recycle", subtitle: "Drop it off safely", color: .blue) {
                        onChoice(.recycle)
                    }
                }
            }
            .padding(24)
        }
        .navigationTitle(type.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func ChoiceButton(title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(color.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
        }
    }
}

struct OtherTechMapFlowView: View {
    var selectedType: OtherTechType
    var purpose: MapPurpose

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
    @State private var showRepairAlert = false
    @State private var hasAskedRepair = false
    @State private var navigateToRepairInfo = false

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
            NavigationLink("", isActive: $navigateToRepairInfo) {
                OtherTechRepairInfoView(selectedType: selectedType)
            }
            .hidden()
        }
        .navigationTitle("\(purpose.titlePrefix) \(selectedType.displayName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard purpose == .repair, !hasAskedRepair else { return }
            hasAskedRepair = true
            showRepairAlert = true
        }
        .alert("Want to learn more about repairing these devices?", isPresented: $showRepairAlert) {
            Button("Learn More") {
                navigateToRepairInfo = true
            }
            Button("Skip", role: .cancel) { }
        }
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

struct OtherTechRepairInfoView: View {
    var selectedType: OtherTechType

    private enum UI {
        static let cardPadding: CGFloat = 20
        static let cornerRadius: CGFloat = 18
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Why repair your \(selectedType.displayName.lowercased())?")
                        .font(.largeTitle.weight(.bold))
                    Text("Repairing extends the life of your device, reduces e-waste, and helps conserve valuable materials.")
                        .font(.body)
                    Text("Where to repair")
                        .font(.title2.weight(.semibold))
                    Text("Visit certified repair shops or local repair cafes that offer diagnosis, parts, and guidance for safe device upkeep. This placeholder space can later list vetted locations.")
                        .font(.body)
                }
                .padding(UI.cardPadding)
                .background(Color(.systemBackground).opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: UI.cornerRadius, style: .continuous))
                .padding()
            }
        }
        .navigationTitle("Repair Benefits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        Other_Tech()
    }
}
