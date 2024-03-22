import Fluent

struct CreateCandle: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("candlesticks")
            .id()
            .field("open", .double, .required)
            .field("high", .double, .required)
            .field("low", .double, .required)
            .field("close", .double, .required)
            .field("timestamp", .double, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("candlesticks").delete()
    }
}
