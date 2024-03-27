import Fluent
import Vapor

final class Pattern: Model, Content, Sequence {
    static let schema = "pattern"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name-ru")
    var nameRU: String
    
    @Field(key: "name-en")
    var nameEN: String
    
    @Children(for: \Candle.$pattern)
    var candles: [Candle]
    
    @Field(key: "info-ru")
    var infoRU: String
    
    @Field(key: "info-en")
    var infoEN: String
    
    @Field(key: "filter")
    var filter: String
    
    init() {}
    
    init(id: UUID? = UUID(), nameRU: String, nameEN: String, infoRU: String, infoEN: String, filter: String) {
        self.id = id
        self.nameRU = nameRU
        self.nameEN = nameEN
        self.infoRU = infoRU
        self.infoEN = infoEN
        self.filter = filter
    }
    
    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
        lhs.nameRU == rhs.nameRU &&
        lhs.infoRU == rhs.infoRU
    }
    
    func calculateYAxisDomain() -> ClosedRange<Double> {
        let lowPrices = candles.map(\.lowPrice)
        let highPrices = candles.map(\.highPrice)
        guard let minPrice = lowPrices.min(), let maxPrice = highPrices.max() else {
            return 0 ... 100
        }
        let padding = (maxPrice - minPrice) * 0.15
        return (minPrice - padding) ... (maxPrice + padding)
    }
    
    func makeIterator() -> Array<Candle>.Iterator {
            return self.candles.makeIterator()
        }
}

enum LanguageType {
    case ru
    case en
}

internal func detectLanguage(input: String) -> LanguageType {
    switch input {
    case "ru":
        return .ru
    case "en":
        return .en
    default:
        return .ru
    }
}
