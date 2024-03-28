import Foundation

// Перечисление для определения цвета свечи
enum CandleColor {
    case white
    case black
    case neutral
}

// Функция для определения цвета свечи
func candleColor(open: Double, close: Double) -> CandleColor {
    if close > open {
        return .white
    } else if close < open {
        return .black
    } else {
        return .neutral
    }
}

// Функция для поиска паттерна "Two Crows"
func findTwoCrows(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let secondCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let thirdCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .white, secondCandle == .black,
           thirdCandle == .black, candles[i].openPrice < candles[i - 1].openPrice,
           candles[i].openPrice > candles[i - 1].closePrice, candles[i].closePrice > candles[i - 2].openPrice,
           candles[i].closePrice < candles[i - 2].closePrice
        {
            signal = -1
        }

        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Две вороны",
            nameEN: "Two crows",
            signal: signals.last!,
            dates: dates
        )
    }
}

// Функция для поиска паттерна "Three White Soldiers"
func findThreeWhiteSoldiers(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let secondCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let thirdCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        // Проверяем, что все три свечи белые
        if firstCandle == .white, secondCandle == .white, thirdCandle == .white {
            // Проверяем, что текущая свеча выше двух предыдущих
            if candles[i].highPrice > candles[i - 1].highPrice, candles[i].highPrice > candles[i - 2].highPrice {
                signal = 1
            }
        }

        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Три белых солдата",
            nameEN: "Three White Soldiers",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findThreeBlackCrows(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let secondCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let thirdCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .black, secondCandle == .black, thirdCandle == .black {
            if candles[i].openPrice < candles[i - 1].openPrice, candles[i - 1].openPrice < candles[i - 2].openPrice {
                if candles[i].closePrice < candles[i - 1].closePrice, candles[i - 1].closePrice < candles[i - 2].closePrice {
                    signal = -1
                }
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Три черные вороны",
            nameEN: "Three Black Crows",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findThreeInside(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let secondCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        _ = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .white, secondCandle == .black {
            if candles[i].openPrice > candles[i - 1].openPrice, candles[i].closePrice < candles[i - 1].closePrice {
                signal = 1
            }
        } else if firstCandle == .black, secondCandle == .white {
            if candles[i].openPrice < candles[i - 1].openPrice, candles[i].closePrice > candles[i - 1].closePrice {
                signal = -1
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Трое внутри",
            nameEN: "Three Inside",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findThreeLineStrike(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 4 else { return nil }
    for i in 4 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 4].openPrice, close: candles[i - 4].closePrice)
        let secondCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        let thirdCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let fourthCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let fifthCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .black, secondCandle == .black, thirdCandle == .black,
           fourthCandle == .white, fifthCandle == .white
        {
            if candles[i].openPrice < candles[i - 4].openPrice, candles[i].closePrice > candles[i - 4].closePrice {
                signal = 1
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Трехлинейный удар",
            nameEN: "Three Line Strike",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findThreeOutsideUp(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let secondCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let thirdCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .black, secondCandle == .white, thirdCandle == .white {
            if candles[i].highPrice > candles[i - 2].highPrice, candles[i].highPrice > candles[i - 1].highPrice {
                signal = 1
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Трое идущих вверх",
            nameEN: "Three Outside Up",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findThreeStarsInSouth(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 3 else { return nil }
    for i in 3 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        let secondCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let thirdCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let fourthCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .white, secondCandle == .black, thirdCandle == .black,
           fourthCandle == .black
        {
            if candles[i].lowPrice < candles[i - 3].lowPrice {
                signal = -1
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Три звезды на юге",
            nameEN: "Three Stars In South",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findAbandonedBaby(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 3 else { return nil }
    for i in 3 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        _ = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let thirdCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        _ = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        if firstCandle == .white, thirdCandle == .black {
            let secondCandleRange = candles[i - 2].highPrice - candles[i - 2].lowPrice
            if secondCandleRange < (candles[i - 2].openPrice - candles[i - 2].closePrice) * 0.5,
               secondCandleRange > 0
            {
                if candles[i].openPrice < candles[i - 3].openPrice, candles[i].closePrice > candles[i - 2].closePrice {
                    signal = 1
                }
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Брошенный младенец",
            nameEN: "Abandoned Baby",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findAdvanceBlock(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 3 else { return nil }
    for i in 3 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        let secondCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let thirdCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let fourthCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        // Проверяем, что первая свеча - белая, а следующие две - черные
        if firstCandle == .white, secondCandle == .black, thirdCandle == .black,
           fourthCandle == .black
        {
            // Проверяем, что третья свеча закрывается выше второй и имеет меньшую амплитуду
            if candles[i - 1].closePrice > candles[i - 2].closePrice,
               candles[i - 1].highPrice < candles[i - 2].highPrice,
               candles[i - 1].lowPrice > candles[i - 2].lowPrice,
               (candles[i - 2].highPrice - candles[i - 2].lowPrice) > (candles[i - 1].highPrice - candles[i - 1].lowPrice)
            {
                // Проверяем, что четвертая свеча закрывается выше третьей
                if candles[i].closePrice > candles[i - 1].closePrice {
                    signal = 1
                }
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Предварительный блок",
            nameEN: "Advance Block",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findClosingMarubozu(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 0 else { return nil }
    for i in 0 ..< candles.count {
        let candle = candles[i]

        var signal = 0
        // Проверяем, что тело свечи полностью заполнено (открытие и закрытие на максимуме или минимуме дня)
        if abs(candle.openPrice - candle.highPrice) < 0.01, abs(candle.closePrice - candle.lowPrice) < 0.01 {
            // Проверяем, что свеча белая (закрытие выше открытия) или черная (закрытие ниже открытия)
            if candle.closePrice > candle.openPrice {
                signal = 1 // Сигнал на покупку
            } else if candle.closePrice < candle.openPrice {
                signal = -1 // Сигнал на продажу
            }
        }
        if signal != 0 {
            dates.append(candle.date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Закрывающийся Марубозу",
            nameEN: "Closing Marubozu",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findConcealingBabySwallow(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 6 else { return nil }
    for i in 6 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 6].openPrice, close: candles[i - 6].closePrice)
        let secondCandle = candleColor(open: candles[i - 5].openPrice, close: candles[i - 5].closePrice)
        let thirdCandle = candleColor(open: candles[i - 4].openPrice, close: candles[i - 4].closePrice)
        let fourthCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        let fifthCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let sixthCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let seventhCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        // Проверяем, что первые шесть свечей - белые и с телом, которое полностью поглощает предыдущую свечу
        if firstCandle == .white, secondCandle == .white, thirdCandle == .white,
           fourthCandle == .white, fifthCandle == .white, sixthCandle == .white,
           candles[i - 6].closePrice > candles[i - 5].openPrice, candles[i - 5].closePrice > candles[i - 4].openPrice,
           candles[i - 4].closePrice > candles[i - 3].openPrice, candles[i - 3].closePrice > candles[i - 2].openPrice,
           candles[i - 2].closePrice > candles[i - 1].openPrice, candles[i - 1].closePrice > candles[i].openPrice
        {
            // Проверяем, что седьмая свеча - черная и открывается ниже предыдущей
            if seventhCandle == .black, candles[i].openPrice < candles[i - 1].openPrice {
                signal = 1 // Сигнал на покупку
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Прячущийся ребенок-ласточка",
            nameEN: "Concealing Baby Swallow",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findBeltHold(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 1 else { return nil }
    for i in 1 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let secondCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        // Проверяем, что первая свеча - белая и вверху тренда, а вторая - длинная черная свеча
        if firstCandle == .white, secondCandle == .black,
           candles[i].openPrice > candles[i - 1].closePrice, candles[i].closePrice < candles[i - 1].closePrice
        {
            signal = 1
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Пряжка",
            nameEN: "Belt Hold",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findBreakaway(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 4 else { return nil }
    for i in 4 ..< candles.count {
        let firstCandle = candleColor(open: candles[i - 4].openPrice, close: candles[i - 4].closePrice)
        let secondCandle = candleColor(open: candles[i - 3].openPrice, close: candles[i - 3].closePrice)
        let thirdCandle = candleColor(open: candles[i - 2].openPrice, close: candles[i - 2].closePrice)
        let fourthCandle = candleColor(open: candles[i - 1].openPrice, close: candles[i - 1].closePrice)
        let fifthCandle = candleColor(open: candles[i].openPrice, close: candles[i].closePrice)

        var signal = 0
        // Проверяем, что первая свеча - длинная белая свеча, а следующие четыре - темные
        if firstCandle == .white, secondCandle == .black, thirdCandle == .black,
           fourthCandle == .black, fifthCandle == .black
        {
            // Проверяем, что последняя темная свеча открывается ниже первой и закрывается выше первой
            if candles[i].openPrice < candles[i - 4].openPrice, candles[i].closePrice > candles[i - 4].closePrice {
                signal = 1
            }
        }
        if signal != 0 {
            dates.append(candles[i].date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Выбивание",
            nameEN: "Breakaway",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findDoji(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    for candle in candles {
        // Проверяем, что тело свечи очень маленькое (разница между открытием и закрытием небольшая)
        if abs(candle.openPrice - candle.closePrice) < 0.01 {
            dates.append(candle.date)
            signals.append(.buy)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Доджи",
            nameEN: "Doji",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findDojiStar(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 1 else { return nil }
    for i in 1 ..< candles.count {
        let firstCandle = candles[i - 1]
        let secondCandle = candles[i]

        // Проверяем, что первая свеча - Doji
        if abs(firstCandle.openPrice - firstCandle.closePrice) < 0.01 {
            // Проверяем, что вторая свеча имеет длинное тело и открывается и закрывается на области Doji
            if secondCandle.highPrice > firstCandle.highPrice, secondCandle.lowPrice < firstCandle.lowPrice {
                dates.append(secondCandle.date)
                signals.append(.buy)
            }
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Звезда Доджи",
            nameEN: "Doji Star",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findDragonflyDoji(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    for candle in candles {
        // Проверяем, что Doji имеет длинную верхнюю тень и отсутствует нижняя тень
        if abs(candle.openPrice - candle.closePrice) < 0.01, candle.highPrice - max(candle.openPrice, candle.closePrice) < 0.01, candle.lowPrice - min(candle.openPrice, candle.closePrice) > 0.01 {
            dates.append(candle.date)
            signals.append(.buy)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Стрекоза Доджи",
            nameEN: "Dragonfly Doji",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findEngulfing(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 1 else { return nil }
    for i in 1 ..< candles.count {
        let firstCandle = candles[i - 1]
        let secondCandle = candles[i]

        var signal = 0
        // Проверяем, что первая свеча - бычья свеча (белая), а вторая свеча - медвежья (черная),
        // и что тело второй свечи полностью поглощает тело первой свечи
        if firstCandle.closePrice < firstCandle.openPrice, secondCandle.closePrice > secondCandle.openPrice,
           secondCandle.openPrice < firstCandle.closePrice, secondCandle.closePrice > firstCandle.openPrice
        {
            signal = 1 // Сигнал на покупку
        } else if firstCandle.closePrice > firstCandle.openPrice, secondCandle.closePrice < secondCandle.openPrice,
                  secondCandle.openPrice > firstCandle.closePrice, secondCandle.closePrice < firstCandle.openPrice
        {
            signal = -1 // Сигнал на продажу
        }
        if signal != 0 {
            dates.append(secondCandle.date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Поглощение",
            nameEN: "Engulfing",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findEveningDojiStar(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    guard candles.count > 2 else { return nil }
    for i in 2 ..< candles.count {
        let firstCandle = candles[i - 2]
        let secondCandle = candles[i - 1]
        let thirdCandle = candles[i]

        var signal = 0
        // Проверяем, что первая свеча - бычья свеча (белая), а вторая свеча - Doji,
        // а третья свеча - медвежья свеча (черная)
        if firstCandle.closePrice < firstCandle.openPrice, abs(secondCandle.openPrice - secondCandle.closePrice) < 0.01,
           thirdCandle.closePrice < thirdCandle.openPrice, thirdCandle.closePrice < secondCandle.openPrice,
           thirdCandle.openPrice > secondCandle.closePrice, thirdCandle.openPrice < firstCandle.closePrice
        {
            signal = -1 // Сигнал на продажу
        }
        if signal != 0 {
            dates.append(thirdCandle.date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Вечерняя звезда Доджи",
            nameEN: "Evening Doji Star",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findGravestoneDoji(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    for i in 0 ..< candles.count {
        let candle = candles[i]

        var signal = 0
        // Проверяем, что Doji имеет длинную нижнюю тень и отсутствует верхняя тень
        if abs(candle.openPrice - candle.closePrice) < 0.01, candle.lowPrice - min(candle.openPrice, candle.closePrice) < 0.01, candle.highPrice - max(candle.openPrice, candle.closePrice) > 0.01 {
            signal = -1 // Сигнал на продажу
        }
        if signal != 0 {
            dates.append(candle.date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Надгробный Доджи",
            nameEN: "Gravestone Doji",
            signal: signals.last!,
            dates: dates
        )
    }
}

func findHammer(candles: [DetectedCandle]) -> DetectedPattern? {
    var dates = [Date]()
    var signals = [Signal]()

    for i in 0 ..< candles.count {
        let candle = candles[i]

        var signal = 0
        // Проверяем, что свеча имеет длинную нижнюю тень, короткое или отсутствующее верхнее тело и
        // открытие и закрытие находятся близко друг к другу, но в пределах верхней половины свечи
        if candle.closePrice - candle.openPrice < 0.01, candle.lowPrice - min(candle.openPrice, candle.closePrice) < 0.01,
           max(candle.openPrice, candle.closePrice) - candle.highPrice < 0.01, (candle.openPrice - candle.lowPrice) / (candle.highPrice - candle.lowPrice) < 0.5
        {
            signal = 1 // Сигнал на покупку
        }
        if signal != 0 {
            dates.append(candle.date)
            signals.append((signal != -1) ? .buy : .sell)
        }
    }

    if signals.isEmpty {
        return nil
    } else {
        return DetectedPattern(
            nameRU: "Молот",
            nameEN: "Hammer",
            signal: signals.last!,
            dates: dates
        )
    }
}
