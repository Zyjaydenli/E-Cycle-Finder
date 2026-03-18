import SwiftUI
import MapKit
import SwiftData


// Enum for battery types
/// Represents the available battery types for recycling.
enum BatteryTypeOption: String, CaseIterable, Identifiable {
    case alkaline
    case lithiumIon
    case rechargeable
    case button
    case leadAcid
    
    var displayName: String {
        switch self {
        case .alkaline: return "Alkaline (AA, AAA, C, D)"
        case .lithiumIon: return "Lithium-ion (Phone, Laptop)"
        case .rechargeable: return "Rechargeable"
        case .button: return "Button / Coin"
        case .leadAcid: return "Car / Lead-acid"
        }
    }
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .alkaline: return "battery.100"
        case .lithiumIon: return "bolt.fill.batteryblock"
        case .rechargeable: return "arrow.triangle.2.circlepath"
        case .button: return "circle.grid.2x2.fill"
        case .leadAcid: return "car.fill"
        }
    }
}

// Step 1: Battery Type Selection Page
struct BatteryTypeView: View {
    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()

            ScrollView {
                VStack(spacing: UI.sectionSpacing) {
                    headerCard
                    optionsList
                }
                .padding(UI.outerPadding)
            }
        }
        .navigationTitle("Batteries")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "bolt.batteryblock.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                Text("What battery would you like to recycle?")
                    .font(.title2.weight(.semibold))
            }
            Text("Select a battery type to see nearby recycling locations.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var optionsList: some View {
        VStack(spacing: 14) {
            ForEach(BatteryTypeOption.allCases) { type in
                NavigationLink(destination: BatteryMapView(selectedBattery: type)) {
                    HStack(spacing: 16) {
                        Image(systemName: type.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.green)
                        Text(type.displayName)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.green.opacity(0.25), lineWidth: 1)
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

#Preview {
    NavigationStack {
        BatteryTypeView()
    }
}
