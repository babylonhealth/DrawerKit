import UIKit

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func equal(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    let epsilon: CGFloat = 0.5
    return abs(lhs - rhs) <= epsilon
}

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func smallerThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs < rhs || equal(lhs, rhs)
}

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func greaterThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs > rhs || equal(lhs, rhs)
}
