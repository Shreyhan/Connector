//
//  LevelView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/10/26.
//

import SwiftUI
import SwiftData

struct LevelView: View {
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
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1...25, id: \.self) { level in
                    let lev = generateLevel(level: level)
                    NavigationLink(destination: OrbGridView(level: lev, orbs: generateOrbs(level: lev))) {
                        ZStack {
                            Circle()
                                .strokeBorder(manager.isUnlocked(level) ? Color.black : Color.gray, lineWidth: 1)
                                .scaledToFit()
                            VStack(spacing: 4) {
                                Text("\(level)")
                                    .font(.headline)
                                HStack(spacing: 2) {
                                    ForEach(0..<3, id: \.self) { i in
                                        Image(systemName: i < manager.stars(for: level) ? "star.fill" : "star")
                                            .font(.caption2)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LevelView()
}
