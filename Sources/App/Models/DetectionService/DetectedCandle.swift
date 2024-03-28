import Foundation
import Fluent
import Vapor

public struct DetectedCandle: Identifiable, Equatable, Hashable, Content {
    public var id = UUID()
    public var date: Date
    public var openPrice: Double
    public var closePrice: Double
    public var highPrice: Double
    public var lowPrice: Double
    public var value: Double?
    public var volume: Double?

    public init(
        date: Date,
        openPrice: Double,
        closePrice: Double,
        highPrice: Double,
        lowPrice: Double,
        value: Double? = nil,
        volume: Double? = nil
    ) {
        self.date = date
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.value = value
        self.volume = volume
    }

    static func stringToDate(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date) ?? Date()
    }

    static func formatDateHH(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }
}

private let minPriceDefaultValue = 0.0
private let maxPriceDefaultValue = 1000.0
extension DetectedCandle {
    static func candlesMinPriceValue(_ candles: [DetectedCandle]) -> Double {
        candles.min(by: { $0.lowPrice < $1.lowPrice })?.lowPrice ?? minPriceDefaultValue
    }

    static func candlesMaxPriceValue(_ candles: [DetectedCandle]) -> Double {
        candles.max(by: { $0.highPrice < $1.highPrice })?.highPrice ?? maxPriceDefaultValue
    }
}
