import Fluent
import FluentPostgresDriver

struct CreatePattern: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("pattern")
            .id()
            .field("name-ru", .string, .required)
            .field("name-en", .string, .required)
            .field("info-ru", .string, .required)
            .field("info-en", .string, .required)
            .field("filter", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("pattern").delete()
    }
}
