//
//  FindCentre.swift
//  E-Cycle Finder
//
//  Created by Jayden Li on 2026-01-20.
//

import SwiftUI

struct FindCenter: View {
    private enum UI {
        static let outerPadding: CGFloat = 20
        static let sectionSpacing: CGFloat = 18
        static let cardPadding: CGFloat = 18
        static let cardCornerRadius: CGFloat = 20
        static let chipCornerRadius: CGFloat = 12
    }

    var body: some View {
        NavigationStack {
            ZStack {
                EcoDecorativeBackground()

                ScrollView {
                    VStack(spacing: UI.sectionSpacing) {
                        headerSection
                        optionsSection
                        infoSection
                    }
                    .padding(UI.outerPadding)
                }
            }
            .navigationTitle("Recycle")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "leaf.arrow.circlepath")
                    .font(.title2)
                    .foregroundStyle(.green)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Find a Recycling Center")
                        .font(.title2.weight(.semibold))
                    Text("What would you like to recycle?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var optionsSection: some View {
        VStack(spacing: 14) {
            NavigationLink {
                BatteryTypeView()
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "battery.100")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.green)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Batteries")
                            .font(.headline)
                        Text("Find places that accept batteries of many types")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
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

            NavigationLink {
                Other_Tech()
                    .font(.title)
                    .padding()
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "desktopcomputer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Other E‑Waste")
                            .font(.headline)
                        Text("Computers, phones, peripherals (coming soon)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.blue.opacity(0.22), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 4)
            }
        }
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Why recycle e‑waste?")
                .font(.headline)
            Text("E‑waste contains hazardous materials and valuable resources. Recycling helps protect the environment and your health.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
    }
}

#Preview{
    FindCenter()
}
