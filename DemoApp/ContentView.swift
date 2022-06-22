//
//  ContentView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI
import PSOAlgorithm

struct ContentView: View {
    //    @State var dataPoints: [Point2D] = [.init(x: 1, y: 1), .init(x: 2, y: 2)]
    @StateObject var model = ViewInfoDataModel(
        range: .init(x: 100, y: 100)
    )
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            LineChartCircleView(
                radius: 10.0,
                viewInfo: model
            ).onPointTouch(perform: { location in
                if model.pickedPoint == nil {
                    model.pickedPoint = .init(x: location.x, y: location.y)
                    model.start()
                }
            })
            .background(Color.gray.opacity(0.1).cornerRadius(16))
            .accentColor(.green)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
