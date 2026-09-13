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
    let minChainSize: Int
    let rng: GKARC4RandomSource
    
    init(num: Int) {
        // 25 levels for now?
        let gridSize = min(3 + num / 3, 10)
        let timeLimit = max(60 - Double(num) * 2, 30)
        let minChainSize = min(3 + (num - 1) / 5, 6) // increases chain length by 1 every 5 levels
        
        let seed = withUnsafeBytes(of: num) { Data($0) }
        
        self.num = num
        self.gridSize = gridSize
        self.orbCount = gridSize * gridSize
        self.timeLimit = timeLimit
        self.allowedColors = OrbColor.getLevelColors(for: num)
        self.allowedDirections = OrbDirection.getLevelDirections(for: num)
        self.minChainSize = minChainSize
        self.rng = GKARC4RandomSource(seed: seed)
        
    }
}

struct OrbGenerator {
    let level: Level
    
    /// creates an orb that matches the restraints put on by the level
    ///
    ///  - Returns
    ///     - a new orb for a given level
    func getNextOrb() -> Orb {
        let color = level.allowedColors[level.rng.nextInt(upperBound: level.allowedColors.count)]
        let dir = level.allowedDirections[level.rng.nextInt(upperBound: level.allowedDirections.count)]
        return Orb(color: color, direction: dir)
    }

    /// creates an initial grid of orbs
    ///
    /// - Returns
    ///     - a new grid of orbs for a given level
    func generateOrbs() -> [Orb] {
        var orbs:[Orb] = []
        for _ in 0..<level.orbCount {
            orbs.append(getNextOrb())
        }
        
        while !validMoveExists(orbs: orbs) {
            print("no valid moves exists... shuffling...")
            // TODO: display a card, show orbs being shuffled
            orbs = level.rng.arrayByShufflingObjects(in: orbs) as! [Orb]
        }
        
        return orbs
    }
    
    /// gives a new grid with the selected chain being deleted, and a new chain replacing it
    /// orbs should "drop down" like a gravity effect is pulling them down
    ///
    /// - Parameters
    ///     - selectedChain: the actual order of orbs the user selects
    ///     - orbs: the entire grid of orbs
    /// - Returns
    ///     - a new grid of orbs with the selected chain being deleted and new orbs replacing them
    func deleteChain(selectedChain: [Int], orbs: [Orb]) -> [Orb] {
        guard selectedChain.count >= level.minChainSize else { return orbs }
        let gridSize = level.gridSize
        var newOrbs = orbs
        
        for index in selectedChain {
            let row = index / gridSize
            let col = index % gridSize
            
            for i in stride(from: row, through: 0, by: -1) {
                if i > 0 {
                    newOrbs[i * gridSize + col] = newOrbs[(i - 1) * gridSize + col]
                } else {
                    newOrbs[col] = getNextOrb()
                }
            }
        }
        
        while !validMoveExists(orbs: newOrbs) {
            print("no valid moves exists... shuffling...")
            // TODO: display a card, show orbs being shuffled
            newOrbs = level.rng.arrayByShufflingObjects(in: newOrbs) as! [Orb]
        }
        
        return newOrbs
    }
    
    /// checks a valid move exists on the board
    func validMoveExists(orbs: [Orb]) -> Bool {
        for start in orbs.indices {
            if chainLength(from: start, orbs: orbs) >= level.minChainSize {
                print("valid move exists starting at: \(start)")
                return true
            }
        }

        print("no valid move exists")
        return false
    }
    
    /// returns the longest possible chain starting at a certain orb
    private func chainLength(from start: Int, orbs: [Orb]) -> Int {
        var visited: Set<Int> = [start]
        var current = start
        var direction = orbs[current].direction
        var next = direction.nextValidMove(index: current, gridSize: level.gridSize)
        
        while let n = next, !visited.contains(next!) {
            visited.insert(n)
            current = n
            direction = orbs[current].direction
            next = direction.nextValidMove(index: current, gridSize: level.gridSize)
        }
        return visited.count
    }
    
    
}
