//
//  LineChartCircleView.swift
//  DemoApp
//
//  Created by kotars01 on 07/06/2022.
//

import SwiftUI
import PSOAlgorithm

struct LineChartCircleView: View {
    @ObservedObject var viewInfo: ViewInfoDataModel
    var radius: CGFloat
    
    private var range: ChartRange { viewInfo.range }
    
    private var highestPoint: Double {
        let max = viewInfo.dataPoints.maxY() ?? 1.0
        if max == 0 { return 1.0 }
        return max
    }
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            
            Path { path in
                for index in 0..<viewInfo.dataPoints.count {
                    let point = viewInfo.dataPoints[index]
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
            
            if let pickedPoint = viewInfo.pickedPoint {
                Path { path in
                    path.addEllipse(
                        in: .init(
                            x: pickedPoint.ratio(range.x, realSize: width, for: \.x),
                            y: pickedPoint.ratio(range.y, realSize: height, for: \.y),
                            width: radius * 2,
                            height: radius * 2
                        )
                    )
                }.fill(.red)
            }
        }
    }
}

private extension Array where Element == Point2D {
    func maxY() -> CGFloat? { map { $0.y }.max() }
    func minY() -> CGFloat? { map { $0.y }.min() }
    func maxX() -> CGFloat? { map { $0.x }.max() }
    func minX() -> CGFloat? { map { $0.x }.min() }
}

private extension Point2D {
    func ratio(
        _ range: CGFloat,
        realSize: CGFloat,
        `for` keyPath: KeyPath<Self, CGFloat>
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
    @Published var dataPoints: [Point2D] = []
    var size: CGSize = .zero
    var pickedPoint: Point2D!
    var range: ChartRange!
    let treshold = 0.1
    
    var psoAlgorithm: PSOAlgorithm<Simple2DParticle, DistanceQualityFunction, Point2DRandomGenerator>?
    
    private var iterationNumber = 0
    
    init(range: ChartRange) {
        self.range = range
    }
    
    func start() {
        psoAlgorithm = PSOAlgorithm<Simple2DParticle, DistanceQualityFunction, Point2DRandomGenerator>(
            qualityFunction: DistanceQualityFunction(treshold: treshold, pickedPoint: pickedPoint),
            randomGenerator: .init(xRange: range.closedRange(for: \.x), yRange: range.closedRange(for: \.y))
        )
        iterationNumber = 0
        
        psoAlgorithm?.c1 = 0.1
        psoAlgorithm?.c2 = 0.1
        psoAlgorithm?.w = 0.1
        
        psoAlgorithm?.initialSpread(numberOfItems: 100)
        let newPoints: [Point2D] = psoAlgorithm?.swarm.map { $0.position } ?? []
        
        dataPoints.append(contentsOf: newPoints)
    }
    
    func next() {
        iterationNumber += 1
        psoAlgorithm?.computeGeneration(n: iterationNumber)
        dataPoints = psoAlgorithm?.swarm.map { $0.position } ?? []
    }
}


