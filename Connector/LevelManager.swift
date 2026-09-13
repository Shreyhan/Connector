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

struct OrbGenerator {
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
