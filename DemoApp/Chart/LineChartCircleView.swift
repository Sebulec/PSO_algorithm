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
    var range: ChartRange
    @Binding var viewInfo: ViewInfoDataModel
    
    private var highestPoint: Double {
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
                            x: point.ratio(range.x, realSize: width, for: \.x),
                            y: point.ratio(range.y, realSize: height, for: \.y),
                            width: radius,
                            height: radius
                        )
                    )
                }
                
            }
            .fill(Color.accentColor)
            .onChange(of: geometry.size, perform: { newValue in
                viewInfo.size = newValue
            })
        }
    }
}

private extension Array where Element == Point2D {
    func maxY() -> Double? { map { $0.y }.max() }
    func minY() -> Double? { map { $0.y }.min() }
    func maxX() -> Double? { map { $0.x }.max() }
    func minX() -> Double? { map { $0.x }.min() }
}

private extension Point2D {
    func ratio(
        _ range: Double,
        realSize: CGFloat,
        `for` keyPath: KeyPath<Self, Double>
    ) -> Double { self[keyPath: keyPath] / range * realSize }
}

extension LineChartCircleView {
    func onPointTouch(perform: @escaping (CGPoint) -> Void) -> some View {
        onTouch(type: .ended, limitToBounds: true) { locationInView in
            let xRangeDiff = range.x
            let yRangeDiff = range.y
            let x = (xRangeDiff * locationInView.x) / viewInfo.size.width
            let y = (yRangeDiff * locationInView.y) / viewInfo.size.height
            perform(.init(x: x, y: y))
        }
    }
}

class ViewInfoDataModel: ObservableObject {
    var size: CGSize = .zero
}
