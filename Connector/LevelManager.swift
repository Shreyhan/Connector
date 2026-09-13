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
    let rng: GKARC4RandomSource
    
    init(num: Int) {
        // 25 levels for now?
        let gridSize = min(3 + num / 3, 10)
        let timeLimit = max(60 - Double(num) * 2, 30)
        
        let seed = withUnsafeBytes(of: num) { Data($0) }
        
        self.num = num
        self.gridSize = gridSize
        self.orbCount = gridSize * gridSize
        self.timeLimit = timeLimit
        self.allowedColors = OrbColor.getLevelColors(for: num)
        self.allowedDirections = OrbDirection.getLevelDirections(for: num)
        self.rng = GKARC4RandomSource(seed: seed)
        
    }
}

struct OrbGenerator {
    let level: Level
    
    func getNextOrb() -> Orb {
        let color = level.allowedColors[level.rng.nextInt(upperBound: level.allowedColors.count)]
        let dir = level.allowedDirections[level.rng.nextInt(upperBound: level.allowedDirections.count)]
        return Orb(color: color, direction: dir)
    }

    func generateOrbs() -> [Orb] {
        var orbs:[Orb] = []
        for _ in 0..<level.orbCount {
            orbs.append(getNextOrb())
        }
        return orbs
    }
    
    func getGridSize() -> Int {
        return level.gridSize
    }

}
