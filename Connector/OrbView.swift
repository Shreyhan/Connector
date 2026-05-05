//
//  OrbView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI

enum OrbDirection: CaseIterable {
    case up, down, left, right, upLeft, upRight, downLeft, downRight
    
    // sf symbols makes diagonals really annoying so i rotate instead
    var angle: Angle {
        switch self {
        case .up: return .degrees(0)
        case .upRight: return .degrees(45)
        case .right: return .degrees(90)
        case .downRight: return .degrees(135)
        case .down: return .degrees(180)
        case .downLeft: return .degrees(225)
        case .left: return .degrees(270)
        case .upLeft: return .degrees(315)
        }
    }
    
    func nextValidMove(index: Int, gridSize: Int) -> Int {
        switch self {
        case .up: return index - gridSize
        case .down: return index + gridSize
        case .left: return index - 1
        case .right: return index + 1
        case .upLeft: return index - gridSize - 1
        case .upRight: return index - gridSize + 1
        case .downLeft: return index + gridSize - 1
        case .downRight: return index + gridSize + 1
        }
    }
}

struct Orb: Identifiable {
    let id = UUID()
    var color: Color = .red
    var direction: OrbDirection
    var isSelected: Bool = false
}

struct OrbView: View {
    let orb: Orb
    
    var body: some View {
        ZStack {
            Circle()
                .fill(orb.isSelected ? orb.color : orb.color.opacity(0.25))
                .overlay(
                    Circle()
                        .strokeBorder(orb.color, lineWidth: orb.isSelected ? 2 : 1)
                )
            
            Image(systemName: "arrow.up")
                .resizable()
                .scaledToFit()
                .rotationEffect(orb.direction.angle)
                .scaleEffect(0.5)
                .foregroundStyle(orb.isSelected ? .white : orb.color)
        }
        .aspectRatio(1, contentMode: .fit)
        .scaleEffect(orb.isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: orb.isSelected)
    }
}

#Preview("straight") {
    OrbView(orb: Orb(direction: .up))
}

#Preview("diag") {
    OrbView(orb: Orb(direction: .upLeft))
}
