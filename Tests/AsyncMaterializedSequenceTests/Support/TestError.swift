import Foundation

struct TestError: LocalizedError, Equatable {
    var errorDescription: String? { "TestError" }
}
