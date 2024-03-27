import Foundation


class SimpleLogic {
    static func twoPlusTwo(rhs: Int?, lhs: Int?) -> Int {
        guard let rhs, let lhs else { return 0 }
        return rhs + lhs
    }
}
