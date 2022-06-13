//
//  ContentView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State var dataPoints: [Point2D] = [.init(x: 1, y: 1), .init(x: 2, y: 2)]
    @State var model = ViewInfoDataModel()
    
    var body: some View {
        VStack {
            LineChartCircleView(
                dataPoints: dataPoints,
                radius: 10.0,
                range: .init(x: 100, y: 100),
                viewInfo: $model
            ).onPointTouch(perform: { location in
                dataPoints.append(.init(x: location.x, y: location.y))
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
