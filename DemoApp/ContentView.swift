//
//  ContentView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI
import PSOAlgorithm

struct ContentView: View {
    @StateObject var model = ViewInfoDataModel(
        range: .init(x: 1000, y: 1000)
    )
    
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            LineChartCircleView(
                viewInfo: model,
                radius: 10.0
            ).onPointTouch(perform: { location in
                model.pickedPoint = .init(x: location.x, y: location.y)
                model.start()
            })
            .background(Color.gray.opacity(0.1).cornerRadius(16))
            .accentColor(.green)
            .onReceive(timer) { _ in
                model.next()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
