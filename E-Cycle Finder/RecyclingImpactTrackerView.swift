import SwiftUI

//  RecyclingImpactTrackerView.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-01-25.
//


struct RecyclingImpactTrackerView: View {
    struct RecyclingEntry: Identifiable {
        let id = UUID()
        let quantity: Int

        var totalCO2Saved: Double {
            Double(quantity) * 1.5 // kg CO2e per battery recycled
        }
    }

    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
        static let listRowHeight: CGFloat = 52
    }

    @State private var quantityText: String = ""
    @State private var entries: [RecyclingEntry] = []

    var totalCO2Saved: Double {
        entries.reduce(0) { $0 + $1.totalCO2Saved }
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()

            ScrollView {
                VStack(spacing: UI.sectionSpacing) {
                    headerCard
                    entryCard
                    logCard
                }
                .padding(UI.outerPadding)
            }
        }
        .navigationTitle("Impact Tracker")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                Text("Your Impact")
                    .font(.title2.weight(.semibold))
            }
            Text("Total CO₂ Saved: \(String(format: "%.1f", totalCO2Saved)) kg")
                .font(.headline)
            Text("Keep adding your recycling to see your environmental benefit grow.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var entryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add New Recycling Entry")
                .font(.headline)

            TextField("Quantity of Batteries", text: $quantityText)
                .keyboardType(.numberPad)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Button(action: addEntry) {
                Label("Add Entry", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!canAdd)
            .buttonStyle(PrimaryActionButtonStyle())
            .opacity(canAdd ? 1 : 0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var logCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Recycling Log")
                .font(.headline)

            if entries.isEmpty {
                Text("No entries yet.")
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(entries) { entry in
                        HStack {
                            Text("\(entry.quantity) × Battery")
                            Spacer()
                            Text("\(String(format: "%.1f", entry.totalCO2Saved)) kg CO₂")
                                .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity, minHeight: UI.listRowHeight)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var canAdd: Bool {
        guard let quantity = Int(quantityText) else { return false }
        return quantity > 0
    }

    private func addEntry() {
        guard let quantity = Int(quantityText), quantity > 0 else { return }
        let newEntry = RecyclingEntry(quantity: quantity)
        entries.append(newEntry)
        quantityText = ""
    }
}

#Preview {
    RecyclingImpactTrackerView()
}
