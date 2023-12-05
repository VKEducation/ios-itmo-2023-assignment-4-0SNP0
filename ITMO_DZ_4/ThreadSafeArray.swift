import Foundation

class ThreadSafeArray<T>  {
    private var array: [T] = []
    private let lock = RWLock()
    
    required init(_ elements: T...) {
        array = Array(elements)
    }
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index { lock.readAction { array.startIndex } }
    var endIndex: Index { lock.readAction { array.endIndex } }

    subscript(index: Index) -> Element {
        get { lock.readAction { array[index] } }
        set { lock.writeAction { array[index] = newValue } }
    }

    func index(after i: Index) -> Index {
        return lock.readAction { array.index(after: i) }
    }
}

extension ThreadSafeArray {
    func append(_ newElement: Element) {
        lock.writeAction { array.append(newElement) }
    }
    
    func insert(_ newElement: Element, at index: Index) {
        lock.writeAction { array.insert(newElement, at: index) }
    }
    
    func remove(at index: Index) -> Element {
        return lock.writeAction { array.remove(at: index) }
    }
    
    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        lock.writeAction { array.removeAll(keepingCapacity: keepCapacity) }
    }
}
