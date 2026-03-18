import Foundation
import CoreLocation

/// Fetches locations from a Google Doc/Sheet and caches them locally so seeding can use fresh data.
enum RemoteLocationLoader {
    // Replace with your published Google Sheet CSV or Doc export URL.
    // For a Sheet: https://docs.google.com/spreadsheets/d/<SHEET_ID>/export?format=csv&gid=<TAB_ID>
    // For the provided Doc, use the TXT export so we can parse lines like: "Name – 49.208475, -123.115006".
    static let remoteURL = URL(string: "https://docs.google.com/document/d/1Lm86KyminC_dPC6LP-NTVSDZudCQlCgS7Zh5dMPprZc/export?format=txt")!

    private static let cacheFilename = "remote_locations.json"

    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        return URLSession(configuration: config)
    }()

    static func fetchAndCache() async -> [SeedLocation] {
        do {
            let (data, _) = try await session.data(from: remoteURL)
            guard let text = String(data: data, encoding: .utf8) else { return [] }
            let seeds = parse(text: text)
            cache(seeds: seeds)
            return seeds
        } catch {
            return loadCached()
        }
    }

    static func loadCached() -> [SeedLocation] {
        let url = cacheURL()
        guard let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([SeedLocation].self, from: data)) ?? []
    }

    // MARK: - Parsing

    private static func parse(text: String) -> [SeedLocation] {
        let lines = text.split(whereSeparator: { $0.isNewline })
        var seeds: [SeedLocation] = []

        let numberPattern = "(-?[0-9]+(?:\\.[0-9]+)?)\\s*,\\s*(-?[0-9]+(?:\\.[0-9]+)?)"
        let regex = try? NSRegularExpression(pattern: numberPattern, options: [])

        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty else { continue }

            let range = NSRange(location: 0, length: (line as NSString).length)
            guard let match = regex?.matches(in: line, options: [], range: range).last,
                  match.numberOfRanges == 3,
                  let latRange = Range(match.range(at: 1), in: line),
                  let longRange = Range(match.range(at: 2), in: line),
                  let lat = Double(String(line[latRange])),
                  let long = Double(String(line[longRange])) else { continue }

            // Name is everything before the first coordinate.
            let namePart = line[..<latRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: CharacterSet(charactersIn: "–- "))
            guard !namePart.isEmpty else { continue }

            seeds.append(SeedLocation(name: namePart, lat: lat, long: long))
        }
        return seeds
    }

    // MARK: - Cache

    private static func cache(seeds: [SeedLocation]) {
        guard !seeds.isEmpty else { return }
        let url = cacheURL()
        if let data = try? JSONEncoder().encode(seeds) {
            try? data.write(to: url, options: [.atomic])
        }
    }

    private static func cacheURL() -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(cacheFilename)
    }
}
