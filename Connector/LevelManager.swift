//
//  LevelManager.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/10/26.
//

import SwiftUI
import SwiftData

struct Level {
    let id: Int
    let gridSize: Int
    let orbCount: Int
    let timeLimit: TimeInterval
    let allowedColors: [Color]
    let allowedDirections: [OrbDirection]
}

@Model
class LevelManager {
    var levelStars: [Int]

    init() {
        self.levelStars = []
    }
    
    func stars(for level: Int) -> Int {
        guard level >= 1, level <= levelStars.count else { return 0 }
        return levelStars[level - 1]
    }
    
    func setStars(_ stars: Int, for level: Int) {
        guard level >= 1 else { return }
        if level > levelStars.count {
            levelStars.append(contentsOf: Array(repeating: 0, count: level - levelStars.count))
        }
        levelStars[level - 1] = max(levelStars[level - 1], stars)
    }
    
    func isUnlocked(_ level: Int) -> Bool {
        if level == 1 { return true }
        return stars(for: level - 1) > 0
    }
}

func generateLevel(level: Int) -> Level {
    // 25 levels for now?
    let gridSize = min(3 + level / 3, 10)
    let timeLimit = max(60 - Double(level) * 2, 30)
    
    let allColors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .brown, .gray]
    let colorCount = min(1 + level / 2, allColors.count)
    let allowedColors = Array(allColors.prefix(colorCount))
    
    let allDirections: [OrbDirection] = [.right, .down, .left, .up, .upRight, .upLeft, .downRight, .downLeft]
    let dirCount = min(2 + level / 2, allDirections.count)
    let allowedDirections = Array(allDirections.prefix(dirCount))
    
    return Level(
        id: level,
        gridSize: gridSize,
        orbCount: gridSize * gridSize,
        timeLimit: timeLimit,
        allowedColors: allowedColors,
        allowedDirections: allowedDirections
    )
}

func getNewOrb(level: Level) -> Orb {
    return Orb(color: level.allowedColors.randomElement()!, direction: level.allowedDirections.randomElement()!)
}

func generateOrbs(level: Level) -> [Orb] {
    var orbs:[Orb] = []
    for _ in 0..<level.orbCount {
        orbs.append(getNewOrb(level: level))
    }
    return orbs
}
