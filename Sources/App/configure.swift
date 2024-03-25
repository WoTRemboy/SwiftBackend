import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    
    app.databases.use(.postgres(hostname: "localhost", port: 5432, username: "postgres", password: "WoTRemb165", database: "patternsdb"), as: .psql)

    app.migrations.add(CreatePattern())
    app.migrations.add(CreateCandle())
    
    app.autoMigrate().whenComplete { result in
        switch result {
        case .success:
            print("Migration successful")
        case .failure(let error):
            print("Migration failed: \(error)")
        }
    }
    
    try routes(app)
}
