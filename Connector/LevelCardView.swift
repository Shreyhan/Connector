//
//  LevelCardView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/6/26.
//

import SwiftUI
import SwiftData

struct LevelCardView: View {
    let levelNum: Int
    
    @Environment(\.modelContext) private var context
    @Query private var allStats: [UserStats]
    var stats: UserStats {
        if let existing = allStats.first {
            return existing
        }
        let newStats = UserStats()
        context.insert(newStats)
        return newStats
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(stats.isUnlocked(levelNum) ? Color.black : Color.gray, lineWidth: 1)
                .scaledToFit()
            VStack(spacing: 4) {
                Text("\(levelNum)")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < stats.getStars(for: levelNum) ? "star.fill" : "star")
                            .foregroundStyle(.yellow)
                    }
                }
            }
        }
    }
}

#Preview {
    LevelCardView(levelNum: 12)
}
