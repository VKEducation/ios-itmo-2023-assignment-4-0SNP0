import Foundation

let queue = DispatchQueue(label: "writeArray", attributes: .concurrent)

let ff = ThreadSafeArray<Int>(1, 2, 3)
let sd = ff[0]
print(ff.count)

for i in 0..<100 {
    queue.async {
        ff.append(i)
    }
}
