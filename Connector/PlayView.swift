//
//  PlayView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/6/26.
//

import SwiftUI

struct PlayView: View {
    let level: Level
    let orbs: [Orb]
    
    var body: some View {
        VStack {
            Text("TITLE OF LEVEL")
            OrbGridView(level: level, orbs: orbs)
            Text("SOMETHIGN HERE")
            Divider()
        }
    }
}

#Preview {
    let lev = generateLevel(level: 4)
    PlayView(level: lev, orbs: generateOrbs(level: lev))
}
