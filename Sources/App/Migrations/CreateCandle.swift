import Fluent

struct CreateCandle: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("candle")
            .id()
            .field("open", .double, .required)
            .field("high", .double, .required)
            .field("low", .double, .required)
            .field("close", .double, .required)
            .field("date", .date, .required)
            .field("value", .int, .required)
            .field("volume", .int, .required)
            .field("pattern_id", .uuid, .required, .references("pattern", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("candle").delete()
    }
}
