////
////  ContentView.swift
////  Connector
////
////  Created by Shreyhan Lakhina on 5/5/26.
////
//
//import SwiftUI
//
//func getNewOrb() -> Orb {
//    return Orb(color: [Color.blue, Color.red, Color.yellow, Color.green].randomElement()!, direction: OrbDirection.allCases.randomElement()!)
//}
//
//func createOrbArray(_ n: Int) -> [Orb] {
//    var orbs: [Orb] = []
//    for _ in 0..<n {
//        orbs.append(getNewOrb())
//    }
//    return orbs
//}
//
//
//struct ContentView: View {
//    var gridSize = 10
//    var orbs = createOrbArray(100)
//    
//    var body: some View {
//        
//        VStack {
//            Text("Find the longest chain!")
//                .font(.title)
//            Text("Score: ")
//            OrbGridView(gridSize: gridSize, orbs: orbs)
//            .padding()
//        }
//
//    }
//}
//
//#Preview {
//    ContentView()
//}
