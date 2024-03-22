//
//  Candlestick.swift
//
//
//  Created by Roman Tverdokhleb on 22.03.2024.
//

import Fluent
import Vapor

final class Candlestick: Model, Content {
    static let schema = "candlesticks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "open")
    var open: Double
    
    @Field(key: "high")
    var high: Double
    
    @Field(key: "low")
    var low: Double
    
    @Field(key: "close")
    var close: Double
    
    @Field(key: "timestamp")
    var timestamp: Double
    
    init() {}
    
    init(id: UUID = UUID(), open: Double, high: Double, low: Double, close: Double, timestamp: Double) {
        self.id = id
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.timestamp = timestamp
    }
    
}
