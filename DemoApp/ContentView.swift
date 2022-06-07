//
//  ContentView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State var dataPoints: [Double] = [15, 2, 7, 16, 32, 39, 5, 3, 25, 21]

    var body: some View {
        VStack {
        LineChartCircleView(dataPoints: dataPoints, radius: 10.0)
              .padding(4)
              .background(Color.gray.opacity(0.1).cornerRadius(16))
              .padding()
              .accentColor(.green)
              
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
