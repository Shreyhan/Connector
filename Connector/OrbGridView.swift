//
//  OrbGridView.swift
//  Connector
//
//  Created by Shreyhan Lakhina on 5/5/26.
//

import SwiftUI

struct OrbGridView: View {
    @State var level: Level
    
    @State private var selectedChain: [Int] = []
    @State private var orbs: [Orb] = []
    @State private var cellWidth: CGFloat = 0
    @State private var cellHeight: CGFloat = 0
    
    private var orbGenerator: OrbGenerator {
        OrbGenerator(level: level)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: level.gridSize), spacing: 0) {
            ForEach(orbs) { orb in
                OrbView(orb: orb)
                    .padding(5)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onAppear {
            orbs = orbGenerator.generateOrbs()
        }
        .background(
            GeometryReader { geo in //create clear background to calculate size
                ZStack {
                    Color.clear
                        .onAppear {
                            cellWidth = geo.size.width / CGFloat(level.gridSize)
                            cellHeight = geo.size.height / CGFloat(level.orbCount / level.gridSize)
                        }
                        .onChange(of: geo.size) {
                            cellWidth = geo.size.width / CGFloat(level.gridSize)
                            cellHeight = geo.size.height / CGFloat(level.orbCount / level.gridSize)
                        }
                    if !selectedChain.isEmpty {
                        Canvas { context, size in
                            for i in 0..<(selectedChain.count - 1) {
                                let fromIndex = selectedChain[i]
                                let toIndex = selectedChain[i + 1]
                                
                                let fromRow = fromIndex / level.gridSize
                                let fromCol = fromIndex % level.gridSize
                                let toRow = toIndex / level.gridSize
                                let toCol = toIndex % level.gridSize
                                
                                let from = CGPoint(
                                    x: CGFloat(fromCol) * cellWidth + cellWidth / 2,
                                    y: CGFloat(fromRow) * cellHeight + cellHeight / 2
                                )
                                let to = CGPoint(
                                    x: CGFloat(toCol) * cellWidth + cellWidth / 2,
                                    y: CGFloat(toRow) * cellHeight + cellHeight / 2
                                )
                                
                                // Blend from one orb's color to the next
                                let fromColor = orbs[fromIndex].color.color
                                let toColor = orbs[toIndex].color.color
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
                                               style: StrokeStyle(lineWidth: CGFloat(100 / level.gridSize), lineCap: .round))
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
                    
                    guard cellWidth > 0, cellHeight > 0 else { return }
                    
                    let col = Int(location.x / cellWidth)
                    let row = Int(location.y / cellHeight)
                    
                    let index = row * level.gridSize + col
                    
                    // backtracking
                    if selectedChain.count >= 2 && selectedChain[selectedChain.count - 2] == index {
                        let removed = selectedChain.removeLast()
                        orbs[removed].isSelected = false
                    }
                    
                    if !selectedChain.contains(index) {
                        if let lastIndex = selectedChain.last {
                            // a chain already exists
                            if index == orbs[lastIndex].direction.nextValidMove(index: lastIndex, gridSize: level.gridSize) {
                                orbs[index].isSelected.toggle()
                                selectedChain.append(index)
                            }
                        } else {
                            // empty chain doesnt need to check where to start from
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
                        orbs = orbGenerator.deleteChain(selectedChain: selectedChain, orbs: orbs)
                    }
                    selectedChain.removeAll()
                }
        )
    }
}

#Preview {
//    @Previewable
//    @State 
    var lev = Level(num: 2)
    OrbGridView(
        level: lev
    )
}
