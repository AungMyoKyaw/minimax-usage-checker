import SwiftUI

extension Animation {
    static let appTransition = Animation.easeInOut(duration: 0.3)
    static let appSpring = Animation.spring(response: 0.2, dampingFraction: 0.75)
    static let appSubtle = Animation.easeOut(duration: 0.2)
    static let appValue = Animation.easeInOut(duration: 0.25)

    static func appTransition(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appTransition
    }

    static func appSpring(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appSpring
    }

    static func appSubtle(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appSubtle
    }

    static func appValue(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : appValue
    }
}
