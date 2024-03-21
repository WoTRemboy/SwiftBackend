import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "CandleHub server is online!"
    }
    
    app.get("hello", ":name") { req async throws -> String in
        let name = try req.parameters.require("name")
        return "Hello, \(name.capitalized)!"
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
    
    try app.register(collection: TodoController())
}

struct UserResponse: Content {
    let systemMessage: String
    let contentMessage: String
    let contactMessage: String
}

struct UserInfo: Content {
    let name: String
    let age: Int
}


