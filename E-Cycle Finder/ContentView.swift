import SwiftUI

struct ContentView: View {
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
                        heroSection
                        actionsSection
                        infoSection
                    }
                    .padding(UI.outerPadding)
                }
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.10, green: 0.57, blue: 0.34), Color(red: 0.59, green: 0.87, blue: 0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    Image(systemName: "leaf.arrow.circlepath")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                    Text("E-Cycle Finder")
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.8)
                }

                Text("Find nearby e-waste recycling centers and build better recycling habits.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(UI.cardPadding)

            Image(systemName: "bolt.batteryblock.fill")
                .font(.system(size: 54, weight: .semibold))
                .foregroundStyle(.white.opacity(0.22))
                .padding(14)
        }
        .frame(minHeight: 175)
        .shadow(color: Color.green.opacity(0.20), radius: 14, x: 0, y: 8)
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.green)
                Text("Explore")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
            }

            NavigationLink(destination: FindCenter()) {
                Label("Find Recycling Centers", systemImage: "location.fill")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(PrimaryActionButtonStyle())

            NavigationLink {
                LearnAboutEWasteView()
            } label: {
                Label("Learn About E-Waste", systemImage: "book.closed.fill")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(SecondaryActionButtonStyle())

            NavigationLink {
                RecyclingImpactTrackerView()
            } label: {
                Label("Track Your Battery Recycling Impact", systemImage: "chart.line.uptrend.xyaxis")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(SecondaryActionButtonStyle())
        }
        .padding(UI.cardPadding)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.45), lineWidth: 1)
        )
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "globe.americas.fill")
                    .foregroundStyle(Color.green)
                    .font(.title3)

                Text("Why recycle e-waste?")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
            }

            Text("E-waste contains hazardous materials and valuable resources. Recycling helps protect the environment, conserve raw materials, and improve community health.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)

            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                .font(.system(size: 42))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.10, green: 0.57, blue: 0.34), Color(red: 0.59, green: 0.87, blue: 0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(UI.cardPadding)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: UI.cardCornerRadius, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ContentView()
}
