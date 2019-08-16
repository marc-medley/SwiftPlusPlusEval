import XCTest
@testable import SwiftPlusPlus

class SwiftPlusPlusTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        let list = SwiftListWrapper(dataSize: 1)
        list.push_back(value: "1".data(using: .utf8)!)   // 0x31 or 49 decimal
        list.push_back(value: "2".data(using: .utf8)!)   // 0x32 or 50 decimal
        list.push_back(value: "3".data(using: .utf8)!)   // 0x33 or 51 decimal
        list.push_front(value: "0".data(using: .utf8)!)  // 0x30 or 48 decimal

        XCTAssertEqual(list.size(), 4)

        // XCTAssertEqual failed: ("Optional("p")") is not equal to ("Optional("0")")
        // p is 0x70 or 112 decimal
        XCTAssertEqual(String.init(data: list.front()!, encoding: .utf8), "0")

        let it = list.begin()

        let _ = it.increment()
        let _ = it.increment()

        // XCTAssertEqual failed: ("Optional("p")") is not equal to ("Optional("2")")
        XCTAssertEqual(String.init(data: it.value()!, encoding: .utf8), "2")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
