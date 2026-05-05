//
//  OrbGridView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI

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

struct OrbGridView: View {
    var gridSize: Int
    @State var orbs: [Orb]
    @State var selectedChain: [Int] = []
    @State private var cellWidth: CGFloat = 0
    @State private var cellHeight: CGFloat = 0
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: gridSize), spacing: 0) {
            ForEach(orbs) { orb in
                OrbView(orb: orb)
                    .padding(5)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(
            GeometryReader { geo in //create clear background to calculate size
                Color.clear.onAppear {
                    let rowCount = orbs.count / gridSize
                    cellWidth = geo.size.width / CGFloat(gridSize)
                    cellHeight = geo.size.height / CGFloat(rowCount)
                }
            }
        )
        .coordinateSpace(name: "grid")
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("grid"))
                .onChanged { value in
                    let location = value.location
                    
                    let col = Int(location.x / cellWidth)
                    let row = Int(location.y / cellHeight)
                    
                    guard row >= 0, row < orbs.count / gridSize, col >= 0, col < gridSize else { return }
                    
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
                    withAnimation(
                        .interpolatingSpring(mass: 1.0, stiffness: 250, damping: 25, initialVelocity: 8)
                    ) {
                        orbs = deleteChain(selectedChain: selectedChain, orbs: orbs, gridSize: gridSize)
                    }
                    selectedChain.removeAll()
                }
        )
        
    }
}

#Preview {
    OrbGridView(gridSize: 5, orbs: createOrbArray(30))
}
