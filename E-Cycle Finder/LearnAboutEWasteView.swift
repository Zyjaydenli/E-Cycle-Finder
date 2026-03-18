import SwiftUI
//  LearnAboutEWasteView.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-01-25.
//


struct LearnAboutEWasteView: View {
    private enum UI {
        static let outerPadding: CGFloat = 20
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
    }

    var body: some View {
        ZStack {
            EcoDecorativeBackground()

            ScrollView {
                VStack(spacing: UI.sectionSpacing) {
                    headerCard
                    factsCard
                    tipsCard
                }
                .padding(UI.outerPadding)
            }
        }
        .navigationTitle("Learn About E-Waste")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "book.closed.fill")
                    .font(.title3)
                    .foregroundStyle(.green)
                Text("E-Waste Basics")
                    .font(.title2.weight(.semibold))
            }
            Text("Understand why e-waste recycling matters and how to handle devices responsibly.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var factsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "globe.americas.fill")
                    .foregroundStyle(.green)
                Text("Key Facts")
                    .font(.headline)
            }
            ForEach(facts, id: \.self) { fact in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.green)
                    Text(fact)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Quick Tips")
                    .font(.headline)
            }
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text(tip)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var facts: [String] {
        [
            "E-waste is the fastest-growing solid waste stream globally.",
            "Recycling recovers valuable metals like gold, copper, and rare earth elements.",
            "Improper disposal can release hazardous substances into soil and water."
        ]
    }

    private var tips: [String] {
        [
            "Back up and wipe your data before recycling devices.",
            "Separate batteries from electronics and recycle them safely.",
            "Donate working devices to extend their life and reduce waste.",
            "Use certified e-waste recyclers whenever possible."
        ]
    }
}

#Preview {
    LearnAboutEWasteView()
}
