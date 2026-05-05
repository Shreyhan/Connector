//
//  ContentView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI

//func validDirections(row: Int, col: Int, gridSize: Int) -> [OrbDirection] {
//    var directions = OrbDirection.allCases
//    
//    if row == 0 {
//        directions.removeAll { $0 == .up || $0 == .upLeft || $0 == .upRight }
//    }
//    
//    if row == gridSize - 1 {
//        directions.removeAll { $0 == .down || $0 == .downLeft || $0 == .downRight }
//    }
//    
//    if col == 0 {
//        directions.removeAll { $0 == .left || $0 == .upLeft || $0 == .downLeft }
//    }
//    
//    if col == gridSize - 1 {
//        directions.removeAll { $0 == .right || $0 == .upRight || $0 == .downRight }
//    }
//    
//    return directions
//}


func getNewOrb() -> Orb {
    return Orb(direction: OrbDirection.allCases.randomElement()!)
}

func createOrbArray(_ n: Int) -> [Orb] {
    var orbs: [Orb] = []
    for _ in 0..<n {
        orbs.append(getNewOrb())
    }
    return orbs
}


struct ContentView: View {
    var gridSize = 8
    var orbs = createOrbArray(64)
    
    var body: some View {
        
        VStack {
            Text("Find the longest chain!")
                .font(.title)
            Text("Score: ")
            OrbGridView(gridSize: gridSize, orbs: orbs)
            .padding()
        }

    }
}

#Preview {
    ContentView()
}
