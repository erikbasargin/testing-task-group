import Foundation

extension AsyncSequence {
    
    @inlinable 
    func collect() async rethrows -> [Element] {
        try await reduce(into: []) { $0.append($1) }
    }
}
