import Fluent
import Vapor

enum MoexApi {
    enum Method: String {
        case allTiсkers = "/iss/history/engines/stock/markets/shares/boards/tqbr/securities.json"
        case candles = "/iss/engines/stock/markets/shares/boards/TQBR/securities/"
        func uri(tiсker: String?, queryItems: [URLQueryItem]? = nil) -> URI? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            if let tiсker {
                components.path = rawValue + tiсker + candle
            } else {
                components.path = rawValue
            }
            if let queryItems {
                components.queryItems = queryItems
            }
            guard let uri = components.string else { return nil }
            return URI(string: uri)
        }
    }
}

private let scheme = "https"
private let host = "iss.moex.com"
private let candle = "/candles.json"
