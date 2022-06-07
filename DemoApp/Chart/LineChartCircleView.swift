//
//  LineChartCircleView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI

struct LineChartCircleView: View {
  var dataPoints: [Double]
  var radius: CGFloat

  var highestPoint: Double {
    let max = dataPoints.max() ?? 1.0
    if max == 0 { return 1.0 }
    return max
  }

  var body: some View {
    GeometryReader { geometry in
      let height = geometry.size.height
      let width = geometry.size.width

      Path { path in
        for index in 1..<dataPoints.count {
            path.addEllipse(
                in: .init(
                    x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                    y: height * ratio(for: index),
                    width: radius,
                    height: radius
                )
            )
        }
      }
      .fill(Color.accentColor)
    }
    .padding(.vertical)
  }

  private func ratio(for index: Int) -> Double { 1 - (dataPoints[index] / highestPoint) }
}
