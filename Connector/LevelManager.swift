//
//  LevelManager.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/10/26.
//

import SwiftUI
import SwiftData
import GameKit

struct Level {
    let num: Int
    let gridSize: Int
    let orbCount: Int
    let timeLimit: TimeInterval
    let allowedColors: [OrbColor]
    let allowedDirections: [OrbDirection]
    let seed: Data
}

class OrbGenerator {
    private let rng: GKARC4RandomSource
    private let allowedColors: [OrbColor]
    private let allowedDirections: [OrbDirection]
    private let initialOrbCount: Int
    private let gridSize: Int
    
    init(level: Level) {
        self.rng = GKARC4RandomSource(seed: level.seed)
        self.allowedColors = level.allowedColors
        self.allowedDirections = level.allowedDirections
        self.initialOrbCount = level.orbCount
        self.gridSize = level.gridSize
    }
    
    func getNextOrb() -> Orb {
        let color = allowedColors[rng.nextInt(upperBound: allowedColors.count)]
        let dir = allowedDirections[rng.nextInt(upperBound: allowedDirections.count)]
        return Orb(color: color, direction: dir)
    }

    func generateOrbs() -> [Orb] {
        var orbs:[Orb] = []
        for _ in 0..<initialOrbCount {
            orbs.append(getNextOrb())
        }
        return orbs
    }
    
    func getGridSize() -> Int {
        return gridSize
    }

}

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

func generateLevel(level: Int) -> Level {
    // 25 levels for now?
    let gridSize = min(3 + level / 3, 10)
    let timeLimit = max(60 - Double(level) * 2, 30)
    
    let allowedColors = OrbColor.getLevelColors(for: level)
    let allowedDirections = OrbDirection.getLevelDirections(for: level)
    
    let seed = withUnsafeBytes(of: level) { Data($0) }
    
    return Level(
        num: level,
        gridSize: gridSize,
        orbCount: gridSize * gridSize,
        timeLimit: timeLimit,
        allowedColors: allowedColors,
        allowedDirections: allowedDirections,
        seed: seed,
    )
}
