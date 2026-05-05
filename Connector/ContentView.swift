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

// should drop, like gravity
func deleteChain(selectedChain: [Int], orbs: [Orb], gridSize: Int) -> [Orb] {
    guard selectedChain.count >= 3 else { return orbs }
    var newOrbs = orbs
    
    for index in selectedChain {
        let row = index / gridSize
        let col = index % gridSize
        
        for i in stride(from: row, through: 0, by: -1) {
            if i > 0 {
                newOrbs[i * gridSize + col] = newOrbs[(i - 1) * gridSize + col]
            } else {
                newOrbs[col] = getNewOrb()
            }
        }
    }
    
    return newOrbs
}

func getNewOrb() -> Orb {
    return Orb(direction: OrbDirection.allCases.randomElement()!)
}


struct ContentView: View {
    let gridSize = 8
    
    let columns = Array(repeating: GridItem(.flexible()), count: 8)
    
    @State var selectedChain: [Int] = []
    
    @State var orbs: [Orb] = (0..<64).map { index in
        return getNewOrb()
    }
    
    var body: some View {
        
        VStack {
            Text("Find the longest chain!")
                .font(.title)
            Text("Score: ")
            GeometryReader { geo in
                
                LazyVGrid(columns: columns) {
                    ForEach(orbs) { orb in
                        OrbView(orb: orb)
                            .padding(5)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let location = value.location
                            let cellSize = (geo.size.width) / CGFloat(gridSize)
                            
                            let col = Int(location.x / cellSize)
                            let row = Int(location.y / cellSize)
                            
                            guard row >= 0, row < gridSize, col >= 0, col < gridSize else { return }
                            
                            let index = row * gridSize + col
                            
                            if !selectedChain.contains(index) {
                                if let lastIndex = selectedChain.last {
                                    if index == orbs[lastIndex].direction.nextValidMove(index: lastIndex, gridSize: gridSize) {
                                        orbs[index].isSelected.toggle()
                                        selectedChain.append(index)
                                    }
                                } else {
                                    orbs[index].isSelected.toggle()
                                    selectedChain.append(index)
                                }
                            }
                        }
                        .onEnded { value in
                            for i in orbs.indices {
                                orbs[i].isSelected = false
                            }
                            orbs = deleteChain(selectedChain: selectedChain, orbs: orbs, gridSize: gridSize)
                            selectedChain.removeAll()
                        }
                )
            }
            .padding()
        }

    }
}

#Preview {
    ContentView()
}
