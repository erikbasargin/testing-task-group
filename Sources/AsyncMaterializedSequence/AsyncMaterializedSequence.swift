import Foundation

extension AsyncSequence {
    
    /// Creates an asynchronous sequence that iterates over the events of the original sequence.
    ///
    /// ```
    /// for await event in (1...3).async.materialize() {
    ///     print("\(event)")
    /// }
    ///
    /// // .value(1)
    /// // .value(2)
    /// // .value(3)
    /// // .completed(.finished)
    /// ```
    ///
    /// - Returns: An `AsyncSequence` where the element is an event of the original `AsyncSequence`.
    @inlinable
    package func materialize() -> AsyncMaterializedSequence<Self> {
        return AsyncMaterializedSequence(self)
    }
}

/// An `AsyncSequence` that iterates over the events of the original `AsyncSequence`.
@usableFromInline
package struct AsyncMaterializedSequence<Base: AsyncSequence> {
    
    @usableFromInline
    let base: Base
    
    @inlinable
    init(_ base: Base) {
        self.base = base
    }
}

extension AsyncMaterializedSequence: AsyncSequence {

    @usableFromInline
    package enum Completion {
        case failure(Base.Failure)
        case finished
    }
    
    @usableFromInline
    package enum Event {
        case value(Base.Element)
        case completed(Completion)
    }
    
    @usableFromInline
    package struct Iterator: AsyncIteratorProtocol {

        @usableFromInline
        var base: Base.AsyncIterator
        
        @usableFromInline
        private(set) var baseIsCompleted: Bool = false
        
        @inlinable
        init(_ base: Base.AsyncIterator) {
            self.base = base
        }
        
        @inlinable
        public mutating func next() async -> Event? {
            guard !baseIsCompleted else {
                return nil
            }
            
            do {
                if let element = try await base.next() {
                    return .value(element)
                } else {
                    baseIsCompleted = true
                    return .completed(.finished)
                }
            } catch let error as Base.Failure {
                baseIsCompleted = true
                return .completed(.failure(error))
            } catch {
                preconditionFailure("Unexpected error: \(error)")
            }
        }
    }
    
    @inlinable
    package func makeAsyncIterator() -> Iterator {
        Iterator(base.makeAsyncIterator())
    }
}

extension AsyncMaterializedSequence: Sendable where Base: Sendable, Base.Element: Sendable {}
extension AsyncMaterializedSequence.Completion: Sendable {}
extension AsyncMaterializedSequence.Event: Sendable where Base.Element: Sendable {}

@available(*, unavailable)
extension AsyncMaterializedSequence.Iterator: Sendable {}

extension AsyncMaterializedSequence.Completion: Equatable where Base.Failure: Equatable {}
extension AsyncMaterializedSequence.Event: Equatable where Base.Element: Equatable, Base.Failure: Equatable {}

extension AsyncMaterializedSequence.Completion: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .failure(let error):
            ".failure(\(error.localizedDescription))"
        case .finished:
            ".finished"
        }
    }
}

extension AsyncMaterializedSequence.Event: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .value(let element):
            ".value(\(element))"
        case .completed(let completion):
            ".completed(\(completion))"
        }
    }
}
