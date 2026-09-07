//
//  PlayView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 9/6/26.
//

import SwiftUI
import Combine

struct PlayView: View {
    let levelNum: Int
    
    private var level: Level {
        generateLevel(level: levelNum)
    }
    
    private var orbGenerator: OrbGenerator {
        OrbGenerator(level: level)
    }
    
    // timer
    @State private var timeRemaining: Double = 1.0
    @State private var endDate: Date = .now
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Level: \(levelNum)")
                .font(.title.bold())
            VStack {
                OrbGridView(level: level, orbGenerator: orbGenerator)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
            )
            .border(Color.gray.opacity(0.4))
            
            VStack(alignment: .leading) {
                ProgressView(value: timeRemaining, total: level.timeLimit)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                Text("\(Int(timeRemaining))s remaining")
                    .font(.caption2)
            }
            .padding()
        }
        .onAppear {
            timeRemaining = level.timeLimit
            endDate = .now.addingTimeInterval(level.timeLimit)
        }
        .onReceive(timer) { _ in
            timeRemaining = max(0, endDate.timeIntervalSince(.now))
        }
    }
}

#Preview {
    PlayView(levelNum: 2)
}
