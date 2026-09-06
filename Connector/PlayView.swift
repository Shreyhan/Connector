//
//  PlayView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/6/26.
//

import SwiftUI

struct PlayView: View {
    let levelNum: Int
    
    @State private var level: Level? = nil
    @State private var orbs: [Orb] = []
    
    var body: some View {
        VStack {
            Text("TITLE OF LEVEL")
            if let level {
                OrbGridView(level: level, orbs: orbs)
            } else {
                ProgressView()
            }
            Text("SOMETHIGN HERE")
            Divider()
        }
        .onAppear {
            let newLevel = generateLevel(level: levelNum)
            level = newLevel
            orbs = generateOrbs(level: newLevel)
        }
    }
}

#Preview {
    PlayView(levelNum: 2)
}
