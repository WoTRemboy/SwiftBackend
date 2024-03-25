import Fluent
import FluentPostgresDriver

struct CreatePattern: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("pattern")
            .id()
            .field("name", .string, .required)
            .field("info", .string, .required)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("pattern").delete()
    }
}
