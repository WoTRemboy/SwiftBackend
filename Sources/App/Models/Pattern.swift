import Fluent
import Vapor

final class Pattern: Model, Content, Sequence {
    static let schema = "pattern"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \Candle.$pattern)
    var candles: [Candle]
    
    @Field(key: "info")
    var info: String
    
    init() {}
    
    init(id: UUID? = UUID(), name: String, info: String) {
        self.id = id
        self.name = name
        self.info = info
    }
    
    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
        lhs.name == rhs.name &&
        lhs.info == rhs.info
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

//struct Pattern: Hashable, Identifiable {
//    static func == (lhs: Pattern, rhs: Pattern) -> Bool {
//        lhs.name == rhs.name &&
//        lhs.candles == rhs.candles &&
//        lhs.info == rhs.info
//    }
//    
//    let id = UUID()
//    let name: String
//    let candles: [Candle]
//    let info: String
//    
//    func calculateYAxisDomain() -> ClosedRange<Double> {
//        let lowPrices = candles.map(\.lowPrice)
//        let highPrices = candles.map(\.highPrice)
//        guard let minPrice = lowPrices.min(), let maxPrice = highPrices.max() else {
//            return 0 ... 100
//        }
//        let padding = (maxPrice - minPrice) * 0.15
//        return (minPrice - padding) ... (maxPrice + padding)
//    }
//}
