//
//  OrbView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI

enum OrbDirection: CaseIterable {
    case up, down, left, right, upLeft, upRight, downLeft, downRight
    
    var symbol: String {
        switch self {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        case .upLeft: return "arrow.up.left"
        case .upRight: return "arrow.up.right"
        case .downLeft: return "arrow.down.left"
        case .downRight: return "arrow.down.right"
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
            
            Image(systemName: orb.direction.symbol)
                .foregroundStyle(orb.isSelected ? .white : orb.color)
        }
        .scaleEffect(orb.isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: orb.isSelected)
    }
}

#Preview {
    OrbView(orb: Orb(direction: .up))
}
