//
//  LevelCardView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/6/26.
//

import SwiftUI
import SwiftData

struct LevelCardView: View {
    let level: Level
//    let isUnlocked: Bool
//    let stars: Int
    
    @Environment(\.modelContext) private var context
    @Query private var managers: [LevelManager]
    var manager: LevelManager {
        if let existing = managers.first {
            return existing
        }
        let newManager = LevelManager()
        context.insert(newManager)
        return newManager
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(manager.isUnlocked(level.num) ? Color.black : Color.gray, lineWidth: 1)
                .scaledToFit()
            VStack(spacing: 4) {
                Text("\(level.num)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < manager.stars(for: level.num) ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                }
            }
        }
    }
}

#Preview {
    let lev = generateLevel(level: 12)
    LevelCardView(level: lev)
}
