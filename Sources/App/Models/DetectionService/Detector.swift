import Foundation
import Fluent
import Vapor

struct DetectionPatterns: Hashable {
    static func detectionPatterns(candles: [DetectedCandle]) -> [DetectedPattern?] {
        var patterns: [DetectedPattern?] = []
        patterns.append(findTwoCrows(candles: candles))
        patterns.append(findThreeWhiteSoldiers(candles: candles))
        patterns.append(findThreeBlackCrows(candles: candles))
        patterns.append(findThreeInside(candles: candles))
        patterns.append(findThreeLineStrike(candles: candles))
        patterns.append(findThreeOutsideUp(candles: candles))
        patterns.append(findThreeStarsInSouth(candles: candles))
        patterns.append(findAbandonedBaby(candles: candles))
        patterns.append(findAdvanceBlock(candles: candles))
        patterns.append(findBeltHold(candles: candles))
        patterns.append(findBreakaway(candles: candles))
        patterns.append(findClosingMarubozu(candles: candles))
        patterns.append(findConcealingBabySwallow(candles: candles))
//        patterns.append(findDoji(candles: candles))
        patterns.append(findDojiStar(candles: candles))
        patterns.append(findDragonflyDoji(candles: candles))
        patterns.append(findEngulfing(candles: candles))
        patterns.append(findEveningDojiStar(candles: candles))
        patterns.append(findGravestoneDoji(candles: candles))
        patterns.append(findHammer(candles: candles))

        return patterns
    }
}

struct DetectedPattern: Hashable, Content {
    var nameRU: String
    var nameEN: String
    var signal: Signal
    var dates: [Date]
}

enum Signal: String, Codable {
    case buy = "buy"
    case sell = "sell"
}

struct LocalizedPattern: Content {
    var name: String
    var signal: Signal
    var dates: [Date]
}
