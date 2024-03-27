import Fluent
import Vapor
import Foundation

func routes(_ app: Application) throws {
    app.get { req async in
        "CandleHub server is online!"
    }
    
    app.get("hello") { req async throws -> String in
        return "Hello!"
    }
    
    app.get("json", ":name") { req async throws -> UserResponse in
        let name = try req.parameters.require("name")
        let message = "Hello, \(name.capitalized)!"
        return UserResponse(systemMessage: "CandleHub is coming soon!",
                            contentMessage: message,
                            contactMessage: "by @voity_vit")
    }
    
    app.post("user-info") { req async throws -> UserResponse in
        let userInfo = try req.content.decode(UserInfo.self)
        let message = "Hello, \(userInfo.name.capitalized)! You are \(userInfo.age) years old."
        return UserResponse(systemMessage: "CandleHub is coming soon!",
                            contentMessage: message,
                            contactMessage: "by @voity_vit")
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
    
    app.get("test-pattern") { req -> Pattern in
        let pattern = Pattern(nameRU: "Pattern", nameEN: "Pattern", infoRU: "here is", infoEN: "here is", filter: "")
        let candle = Candle(date: Candle.stringToDate("2016-04-14T10:44:00+0000"), openPrice: 120, closePrice: 108, highPrice: 119, lowPrice: 108.1, value: 0, volume: 0, patternID: pattern.id ?? UUID())
        
        return pattern
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
    
    app.get("two-plus-two") { req -> ResultSum in
        let lsh = req.query[Int.self, at: "lsh"]
        let rhs = req.query[Int.self, at: "rsh"]
        let result = SimpleLogic.twoPlusTwo(rhs: rhs, lhs: lsh)
        return ResultSum(result: result)
    }
    
    app.get("fetch") { req -> EventLoopFuture<MoexCandles> in
        return req.client.get("http://iss.moex.com/iss/engines/stock/markets/shares/securities/YNDX/candles.json").flatMapThrowing { res in
            let result = try res.content.decode(MoexCandles.self)
            print(result)
            return result
        }
    }
    
    try app.register(collection: CandleController())
}

private struct Cursor {
    var index: Int
    let total: Int
    let pageSize: Int
}

struct ResultSum: Content {
    let result: Int
}

let jsonString = """
{
    "metadata": {
        "open": {"type": "double"},
        "close": {"type": "double"},
        "high": {"type": "double"},
        "low": {"type": "double"},
        "value": {"type": "double"},
        "volume": {"type": "double"},
        "begin": {"type": "datetime","bytes": 19,"maxSize": 0},
        "end": {"type": "datetime","bytes": 19,"maxSize": 0}
    },
    "columns": [
        "open",
        "close",
        "high",
        "low",
        "value",
        "volume",
        "begin",
        "end"
    ],
    "data": []
}
"""

func convertResponseToDictionary(_ response: Response) throws -> [String: Any]? {
    let data = response.body.data
    
    do {
        if let jsonData = data,
           let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return jsonDictionary
        } else {
            print("Failed to convert JSON data to dictionary")
            return nil
        }
    } catch {
        print("Error decoding JSON data: \(error)")
        return nil
    }
}

struct UserResponse: Content, Equatable {
    let systemMessage: String
    let contentMessage: String
    let contactMessage: String
}

struct UserInfo: Content {
    let name: String
    let age: Int
}
