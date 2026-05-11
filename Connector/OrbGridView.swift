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
                ZStack {
                    Color.clear.onAppear {
                        let rowCount = orbs.count / gridSize
                        cellWidth = geo.size.width / CGFloat(gridSize)
                        cellHeight = geo.size.height / CGFloat(rowCount)
                    }
                    if !selectedChain.isEmpty {
                        Canvas { context, size in
                            for i in 0..<(selectedChain.count - 1) {
                                let fromIndex = selectedChain[i]
                                let toIndex = selectedChain[i + 1]
                                
                                let fromRow = fromIndex / gridSize
                                let fromCol = fromIndex % gridSize
                                let toRow = toIndex / gridSize
                                let toCol = toIndex % gridSize
                                
                                let from = CGPoint(
                                    x: CGFloat(fromCol) * cellWidth + cellWidth / 2,
                                    y: CGFloat(fromRow) * cellHeight + cellHeight / 2
                                )
                                let to = CGPoint(
                                    x: CGFloat(toCol) * cellWidth + cellWidth / 2,
                                    y: CGFloat(toRow) * cellHeight + cellHeight / 2
                                )
                                
                                // Blend from one orb's color to the next
                                let fromColor = orbs[fromIndex].color
                                let toColor = orbs[toIndex].color
                                let gradient = Gradient(colors: [fromColor, toColor])
                                let shading = GraphicsContext.Shading.linearGradient(
                                    gradient,
                                    startPoint: from,
                                    endPoint: to
                                )
                                
                                var segment = Path()
                                segment.move(to: from)
                                segment.addLine(to: to)
                                context.stroke(segment, with: shading,
                                               style: StrokeStyle(lineWidth: CGFloat(100 / gridSize), lineCap: .round))
                            }
                        }
                        .allowsHitTesting(false)
                    }
                }
            }
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let location = value.location
                    
                    let col = Int(location.x / cellWidth)
                    let row = Int(location.y / cellHeight)
                    
                    guard row >= 0, row < orbs.count / gridSize, col >= 0, col < gridSize else { return }
                    
                    let index = row * gridSize + col
                    if selectedChain.count >= 2 && selectedChain[selectedChain.count - 2] == index {
                        let removed = selectedChain.removeLast()
                        orbs[removed].isSelected = false
                    }
                    
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
    OrbGridView(gridSize: 10, orbs: createOrbArray(100))
}
