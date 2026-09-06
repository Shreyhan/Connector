//
//  LevelView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/10/26.
//

import SwiftUI
import SwiftData

struct LevelView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1...25, id: \.self) { level in
                    NavigationLink(destination: PlayView(levelNum: level)) {
                        LevelCardView(levelNum: level)
                    }
                }
            }
        }
    }
}

#Preview {
    LevelView()
}
