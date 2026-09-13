//
//  ScoreManager.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/7/26.
//

import SwiftData

@Model
class UserStats {
    var levelStars: [Int : Int]

    init() {
        self.levelStars = [:]
    }
    
    func getStars(for level: Int) -> Int {
        return levelStars[level] ?? 0
    }
     
    func setStars(_ stars: Int, for level: Int) {
        guard level >= 1 else { return }
        levelStars[level] = stars
    }
    
    func updateStars(_ stars: Int, for level: Int) {
        let currentStars = getStars(for: level)
        if currentStars < stars {
            setStars(stars, for: level)
        }
    }
    
    func isUnlocked(_ level: Int) -> Bool {
        if level == 1 { return true }
        return getStars(for: level - 1) > 0
    }
}

@Model
class UserSettings {
    var minimumChainLength: Int
    
    init() {
        self.minimumChainLength = 3
    }
}

func scoreForChain(_ orbs: [Orb]) -> Double {
    let length = Double(orbs.count)
    var multiplier = 10.0
    
    // all orbs same color!
    if orbs.allSatisfy({ $0.color == orbs[0].color }) {
        multiplier *= 3
    }
    
    // TODO: if starting orb is == end orb (theres a loop, loop must be size >=4)
    
    
    return length * (length - 1) * multiplier
}

func targetScore(for level: Level) -> Int {
    level.orbCount * 8
}

func starsForScore(_ score: Int, for level: Level) -> Int {
    let target = targetScore(for: level)
    guard target > 0 else { return 0 }
    let ratio = Double(score) / Double(target)
    if ratio >= 1.0 { return 3 }
    if ratio >= 0.6 { return 2 }
    if ratio >= 0.3 { return 1 }
    return 0
}
