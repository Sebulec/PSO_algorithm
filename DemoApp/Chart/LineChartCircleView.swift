//
//  LineChartCircleView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI

struct LineChartCircleView: View {
    var dataPoints: [Point2D]
    var radius: CGFloat
    
    var highestPoint: Double {
        let max = dataPoints.maxY() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            
            Path { path in
                for index in 0..<dataPoints.count {
                let point = dataPoints[index]
                    path.addEllipse(
                        in: .init(
                            x: point.x * width / CGFloat(dataPoints.count),
                            y: height * ratio(for: point.y),
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
    
    private func ratio(for y: Double) -> Double { 1 - y / highestPoint }
}

private extension Array where Element == Point2D {
    func maxY() -> Double? { map { $0.y }.max() }
    func minY() -> Double? { map { $0.y }.min() }
    func maxX() -> Double? { map { $0.x }.max() }
    func minX() -> Double? { map { $0.x }.min() }
}
