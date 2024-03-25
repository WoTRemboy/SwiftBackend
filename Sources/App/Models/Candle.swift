import Fluent
import Foundation
import Vapor

final class Candle: Model, Content, Equatable {
    static let schema = "candle"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "open")
    var openPrice: Double
    
    @Field(key: "high")
    var highPrice: Double
    
    @Field(key: "low")
    var lowPrice: Double
    
    @Field(key: "close")
    var closePrice: Double
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "value")
    var value: Int
    
    @Field(key: "volume")
    var volume: Int
    
    @Parent(key: "pattern_id")
    var pattern: Pattern
    
    init() {}
    
    init(id: UUID = UUID(), date: Date, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, value: Int, volume: Int, patternID: UUID) {
        self.id = id
        self.openPrice = openPrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.closePrice = closePrice
        self.date = date
        self.value = value
        self.volume = volume
        self.$pattern.id = patternID
    }
    
    static func == (lhs: Candle, rhs: Candle) -> Bool {
        lhs.id == rhs.id && lhs.openPrice == rhs.openPrice &&
        lhs.highPrice == rhs.highPrice && lhs.lowPrice == rhs.lowPrice &&
        lhs.closePrice == rhs.closePrice && lhs.date == rhs.date
    }
    
    static func stringToDate(_ date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: date) ?? Date()
    }
    
}

struct MoexCandles: Content {
    let candles: Candles

    struct Candles: Content {
        let data: [[Candle]]

        enum Candle: Content {
            case value(Double)
            case date(String)

            init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                if let x = try? container.decode(Double.self) {
                    self = .value(x)
                    return
                }
                if let x = try? container.decode(String.self) {
                    self = .date(x)
                    return
                }
                let debugDescription = "Wrong type for MoexTiсker"
                let error = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: debugDescription)
                throw DecodingError.typeMismatch(Candle.self, error)
            }
        }
    }
}
