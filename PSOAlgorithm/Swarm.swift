//
//  Swarm.swift
//  PSOAlgorithm
//
//  Created by kotars01 on 03/06/2022.
//

import CoreGraphics

public class PSOAlgorithm<
    Particle: ParticleType,
    Quality: QualityFunction,
    ValueGenerator: RandomGenerator
> {
    public var swarm: [Particle] = []
    var qualityFunction: Quality
    var randomGenerator: ValueGenerator
    
    public init(
        qualityFunction: Quality,
        randomGenerator: ValueGenerator
    ) {
        self.qualityFunction = qualityFunction
        self.randomGenerator = randomGenerator
    }
    
    public func initialSpread(numberOfItems: Int) {
        swarm = (1...numberOfItems).map { _ in randomGenerator.generateRandomValue() as! Particle }
    }
    
    public func computeGeneration(n: Int) {
        
    }
    
}

public protocol ParticleType {
    associatedtype T
    
    var position: T { get set }
    var velocity: T { get set }
}

public struct Simple2DParticle: ParticleType {
    public var position: Point2D
    public var velocity: Point2D
}

public struct Point2D {
    public var x, y: CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

public protocol QualityFunction {
    associatedtype T
    
    func calculate(parameter: T) -> CGFloat
    func shouldTerminate(best: T) -> Bool
}

public struct DistanceQualityFunction: QualityFunction {
    
    private let treshold: CGFloat
    private var pickedPoint: Point2D
    
    public init(treshold: CGFloat, pickedPoint: Point2D) {
        self.treshold = treshold
        self.pickedPoint = pickedPoint
    }
    
    public func calculate(parameter: Point2D) -> CGFloat {
        pointDistance(from: pickedPoint, to: parameter)
    }
    
    public func shouldTerminate(best: Point2D) -> Bool { pointDistance(from: pickedPoint, to: best) <= treshold }
    
    func pointDistance(from: Point2D, to: Point2D) -> CGFloat { sqrt(pointDistanceSquared(from: from, to: to)) }
    
    private func pointDistanceSquared(from: Point2D, to: Point2D) -> CGFloat { (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y) }
}

public protocol RandomGenerator {
    associatedtype T
    
    func generateRandomValue() -> T
}

public struct Point2DRandomGenerator: RandomGenerator {
    public typealias T = Simple2DParticle
    
    let xRange: ClosedRange<CGFloat>
    let yRange: ClosedRange<CGFloat>
    
    public init(xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) {
        self.xRange = xRange
        self.yRange = yRange
    }
    
    public func generateRandomValue() -> T {
        .init(
            position: .init(x: randomFloat(from: xRange), y: randomFloat(from: yRange)),
            velocity: .init(x: randomFloat(from: xRange), y: randomFloat(from: yRange))
        )
    }
    
    private func randomFloat(from range: ClosedRange<CGFloat>) -> CGFloat {
        .random(in: range)
    }
}
