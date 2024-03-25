import Vapor
import Fluent

struct CandleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let candles = routes.grouped("candlesticks")
        candles.get(use: index)
        candles.post(use: create)
        candles.group(":candleID") { candle in
            candles.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Candle] {
        try await Candle.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Candle {
        let candle = try req.content.decode(Candle.self)
        try await candle.save(on: req.db)
        return candle
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let candle = try await Candle.find(req.parameters.get("candleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await candle.delete(on: req.db)
        return .noContent
    }
}

