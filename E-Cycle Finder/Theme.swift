import SwiftUI
import SwiftData
import CoreLocation

// Added Codable conformance and cached/remote seed support, plus merging helper
struct SeedLocation: Identifiable, Codable {
    let id = UUID()
    let name: String
    let lat: Double
    let long: Double
}

enum SeedData {
    static let locations: [SeedLocation] = [
        SeedLocation(name: "Vancouver Zero Waste Centre", lat: 49.208475, long: -123.115006),
        SeedLocation(name: "Mount Pleasant Return-It Express Depot", lat: 49.262680, long: -123.092770),
        SeedLocation(name: "Powell Street Return-It Express Depot", lat: 49.284426, long: -123.066404),
        SeedLocation(name: "Yaletown Return-It Express Depot", lat: 49.274152, long: -123.127196),
        SeedLocation(name: "Regional Recycling Vancouver Bottle Depot", lat: 49.270626, long: -123.081953),
        SeedLocation(name: "Eazy Return - Vancouver Return-It Depot", lat: 49.265044, long: -123.104525),
        SeedLocation(name: "Vancouver Central Return-It Express Depot", lat: 49.239215, long: -123.051404),
        SeedLocation(name: "South Van Bottle Depot", lat: 49.208822, long: -123.106361),
        SeedLocation(name: "Computie Electronics Recycling Depot", lat: 49.211124, long: -123.112212),
        SeedLocation(name: "Recycling Alternative", lat: 49.269673, long: -123.094286)
    ]

    static func cachedOrDefault() -> [SeedLocation] {
        let cached = RemoteLocationLoader.loadCached()
        return cached.isEmpty ? locations : cached
    }
}

enum LocationSeeder {
    @MainActor
    static func ensureSeeded(context: ModelContext) {
        merge(seeds: SeedData.cachedOrDefault(), context: context)
    }

    @MainActor
    static func refreshFromRemote(context: ModelContext) async {
        let remote = await RemoteLocationLoader.fetchAndCache()
        let seeds = remote.isEmpty ? SeedData.locations : remote
        merge(seeds: seeds, context: context)
    }

    @MainActor
    private static func merge(seeds: [SeedLocation], context: ModelContext) {
        let existing = (try? context.fetch(FetchDescriptor<Location>())) ?? []
        var byName: [String: Location] = [:]
        existing.forEach { byName[$0.name] = $0 }

        var didChange = false
        for seed in seeds {
            if let current = byName[seed.name] {
                if current.lat != seed.lat || current.long != seed.long {
                    current.lat = seed.lat
                    current.long = seed.long
                    didChange = true
                }
            } else {
                context.insert(Location(name: seed.name, long: seed.long, lat: seed.lat))
                didChange = true
            }
        }

        if didChange {
            try? context.save()
        }
    }
}

struct EcoDecorativeBackground: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.93, green: 0.98, blue: 0.95),
                        Color(red: 0.88, green: 0.96, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Circle()
                    .fill(Color.green.opacity(0.16))
                    .frame(width: w * 0.6, height: w * 0.6)
                    .blur(radius: 12)
                    .offset(x: -w * 0.30, y: -h * 0.24)

                Circle()
                    .fill(Color.cyan.opacity(0.16))
                    .frame(width: w * 0.55, height: w * 0.55)
                    .blur(radius: 12)
                    .offset(x: w * 0.28, y: -h * 0.18)

                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.green.opacity(0.18))
                    .rotationEffect(.degrees(-12))
                    .offset(x: -w * 0.30, y: -h * 0.04)

                Image(systemName: "drop.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.blue.opacity(0.20))
                    .offset(x: w * 0.32, y: h * 0.06)

                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.green.opacity(0.14))
                    .offset(x: w * 0.24, y: h * 0.30)
            }
        }
        .allowsHitTesting(false)
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 13)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.10, green: 0.57, blue: 0.34),
                                Color(red: 0.28, green: 0.73, blue: 0.52)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: Color.green.opacity(configuration.isPressed ? 0.08 : 0.22), radius: 8, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline, design: .rounded).weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.vertical, 13)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.green.opacity(0.14), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.90 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
