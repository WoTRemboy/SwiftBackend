import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.get { req async in
        "CandleHub server is online!"
    }
    
    app.post("pattern") { req async throws -> Pattern in
        let patternInfo = try req.content.decode(Pattern.self)
        try await patternInfo.save(on: req.db)
        return patternInfo
    }
    
    app.post("candle-post") { req async throws -> Candle in
        let candle = try req.content.decode(Candle.self)
        try await candle.save(on: req.db)
        return candle
    }
    
    app.get("all-patterns") { req -> EventLoopFuture<[PatternPass]> in
        let query = req.query[String.self, at: "language"]
        let language = detectLanguage(input: query ?? "ru")
        switch language {
        case .ru:
            return Pattern.query(on: req.db).with(\.$candles).all().flatMap { patterns in
                let patternPassFutures = patterns.map { pattern in
                    let patternPassItem = PatternPass(name: pattern.nameRU, candles: pattern.candles, info: pattern.infoRU, filter: pattern.filter)
                    return req.eventLoop.makeSucceededFuture(patternPassItem)
                }
                return patternPassFutures.flatten(on: req.eventLoop)
            }
        case .en:
            return Pattern.query(on: req.db).with(\.$candles).all().flatMap { patterns in
                let patternPassFutures = patterns.map { pattern in
                    let patternPassItem = PatternPass(name: pattern.nameEN, candles: pattern.candles, info: pattern.infoEN, filter: pattern.filter)
                    return req.eventLoop.makeSucceededFuture(patternPassItem)
                }
                return patternPassFutures.flatten(on: req.eventLoop)
            }
        }
        
    }
    
    app.get("all-tickers") { req async throws -> ClientResponse in
        let start = req.query[String.self, at: "start"]
        
        guard let uri = MoexApi.Method.allTiсkers.uri(
            tiсker: nil,
            queryItems: [URLQueryItem(name: "start", value: start)]
        ) else {
            assertionFailure()
            return ClientResponse()
        }
        
        let response = try await req.client.get(uri)
        return response
    }
    
    app.get("candle") { req -> ClientResponse in
        let ticker = req.query[String.self, at: "ticker"]
        let timePeriod = req.query[String.self, at: "interval"]
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "iss.reverse", value: "true"))
        queryItems.append(URLQueryItem(name: "ticker", value: ticker))
        queryItems.append(URLQueryItem(name: "interval", value: timePeriod))
        
        guard let uri = MoexApi.Method.candles.uri(
            tiсker: ticker,
            queryItems: queryItems
        ) else {
            assertionFailure()
            return ClientResponse()
        }
        print(uri)
        
        let response = try await req.client.get(uri)
        return response
    }
    
    app.get("fetch") { req -> EventLoopFuture<MoexCandles> in
        return req.client.get("http://iss.moex.com/iss/engines/stock/markets/shares/securities/YNDX/candles.json").flatMapThrowing { res in
            let result = try res.content.decode(MoexCandles.self)
            print(result)
            return result
        }
    }
    
    app.post("detect-pattern") { req -> EventLoopFuture<[LocalizedPattern]> in
        let candles = try req.content.decode([DetectedCandle].self)
        let query = req.query[String.self, at: "language"]
        let language = detectLanguage(input: query ?? "ru")
        let patterns = DetectionPatterns.detectionPatterns(candles: candles)
        let unPatterns = patterns.compactMap { $0 }
        var result = [LocalizedPattern]()
        switch language {
        case .ru:
            for pattern in unPatterns {
                result.append(LocalizedPattern(name: pattern.nameRU, signal: pattern.signal, dates: pattern.dates))
            }
            return req.eventLoop.makeSucceededFuture(result)
        case .en:
            for pattern in unPatterns {
                result.append(LocalizedPattern(name: pattern.nameEN, signal: pattern.signal, dates: pattern.dates))
            }
            return req.eventLoop.makeSucceededFuture(result)
        }
    }
    
    try app.register(collection: CandleController())
}

private struct Cursor {
    var index: Int
    let total: Int
    let pageSize: Int
}

