import Foundation

class RWLock {
    private var lock = pthread_rwlock_t()
    
    init() {
        pthread_rwlock_init(&lock, nil).checkSuccess("init")
    }
    
    deinit {
        pthread_rwlock_destroy(&lock).checkSuccess("destroy")
    }
    
    func readAction<T>(_ action: () -> T) -> T {
        pthread_rwlock_rdlock(&lock).checkSuccess("read lock")
        defer {
            pthread_rwlock_unlock(&lock).checkSuccess("unlock read lock")
        }
        return action()
    }
    
    func writeAction<T>(_ action: () -> T) -> T {
        pthread_rwlock_wrlock(&lock).checkSuccess("write lock")
        defer {
            pthread_rwlock_unlock(&lock).checkSuccess("unlock write lock")
        }
        return action()
    }
}

private extension Int32 {
    func checkSuccess(_ action: String = "") {
        if (self != 0) {
            fatalError("RWLock error \(action)")
        }
    }
}
