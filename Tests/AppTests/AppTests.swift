@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testGetHelloRequestWithoutParams() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        let expectedResponse = "Hello!"
        
        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, expectedResponse)
        })
    }
    
    func testPostEncodeDecodeRequestWithParams() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        let userInfo = UserInfo(name: "Tim", age: 99)
        
        try app.test(.POST, "user-info", beforeRequest: { req in
            try req.content.encode(userInfo)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNoThrow(try res.content.decode(UserResponse.self))
        })
    }
    
    func testPostExpectedEqualHelloRequestWithParams() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        let userInfo = UserInfo(name: "Tim", age: 99)
        let expected = UserResponse(systemMessage: "CandleHub is coming soon!",
                                    contentMessage: "Hello, Tim! You are 99 years old.",
                                    contactMessage: "by @voity_vit")
        
        try app.test(.POST, "user-info", beforeRequest: { req in
            try req.content.encode(userInfo)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(expected, try res.content.decode(UserResponse.self))
        })
    }
}
