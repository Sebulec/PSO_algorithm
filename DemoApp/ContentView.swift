//
//  ContentView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State var dataPoints: [Point2D] = [.init(x: 1, y: 1), .init(x: 2, y: 2)]

    var body: some View {
        VStack {
        LineChartCircleView(dataPoints: dataPoints, radius: 10.0)
              .padding(4)
              .background(Color.gray.opacity(0.1).cornerRadius(16))
              .padding()
              .accentColor(.green)
              .onTouch(type: .ended, limitToBounds: false, perform: { location in
                  dataPoints.append(Point2D(x: Double.random(in: 1..<10), y: Double.random(in: 1..<100)))
              })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
