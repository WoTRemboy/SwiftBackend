import Fluent
import Vapor

func routes(_ app: Application) throws {
app.get { req async in
        "Testing the display of new changes"
    }

    try app.register(collection: TodoController())
}
