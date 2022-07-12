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
    public var c1: CGFloat = 0.5 {
        willSet {
            assert(c1 >= 0.0 && c1 <= 1.0)
        }
    }
    public var c2: CGFloat = 0.5 {
        willSet {
            assert(c1 >= 0.0 && c1 <= 1.0)
        }
    }
    public var w: CGFloat = 0.5 {
        willSet {
            assert(c1 >= 0.0 && c1 <= 1.0)
        }
    }
    
    var qualityFunction: Quality
    var randomGenerator: ValueGenerator
    
    private var currentGlobalBest: BestCandidate?
    private var bestForEachParticle: [Int: BestCandidate] = [:]
    
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
        print("Compute generation: \(n)")
        let currentSwarmCosts = swarm.map { qualityFunction.calculate(parameter: $0.position as! Quality.T) }
        
        swarm.enumerated().forEach { (offset: Int, element: ParticleType) in
            let currentParticleCost = currentSwarmCosts[offset]
            let currentBestCandidateCost = bestForEachParticle[offset]?.cost ?? .infinity
            if currentParticleCost < currentBestCandidateCost, let element = element as? Simple2DParticle {
                bestForEachParticle[offset] = .init(particle: element, cost: currentParticleCost)
                if currentParticleCost < currentGlobalBest?.cost ?? .infinity {
                    currentGlobalBest = .init(particle: element, cost: currentParticleCost)
                }
            }
        }
        
        if let element = currentGlobalBest {
            print("\nGlobal best cost: \(element.cost) \nPos: \(element.particle)")
        }
        calculateSwarmNewPositions()
    }
    
    public func shouldTerminate() -> Bool {
        guard let currentGlobalBest = currentGlobalBest as? Quality.T else { return false }
        return qualityFunction.shouldTerminate(best: currentGlobalBest)
    }
    
    private func calculateSwarmNewPositions() {
        bestForEachParticle.forEach { calculateVelocityAndPositionForParticle(at: $0.key) }
    }
    
    private func calculateVelocityAndPositionForParticle(at offset: Int) {
        guard let particleVelocity = swarm[offset].velocity as? Point2D,
              let particlePosition = swarm[offset].position as? Point2D else { return }
        let range: ClosedRange<CGFloat> = 0...1
        let randoms: (CGFloat, CGFloat) = (.random(in: range), .random(in: range))
        let bestForParticle = bestForEachParticle[offset]!
        
        let newPositionForX = particlePosition.x + particleVelocity.x
        let newPositionForY = particlePosition.y + particleVelocity.y
        
        let newVelocityForX = w * particleVelocity.x + c1 * randoms.0 * (bestForParticle.particle.position.x - particlePosition.x) + c2 * randoms.1 * (currentGlobalBest!.particle.position.x - particlePosition.x)
        let newVelocityForY = w * particleVelocity.y + c1 * randoms.0 * (bestForParticle.particle.position.y - particlePosition.y) + c2 * randoms.1 * (currentGlobalBest!.particle.position.y - particlePosition.y)

        let particle = Simple2DParticle.init(
            position: .init(
                x: newPositionForX,
                y: newPositionForY
            ),
            velocity: .init(
                x: newVelocityForX,
                y: newVelocityForY
            )
        )
        
        swarm[offset] = particle as! Particle
    }
}

struct BestCandidate {
    var particle: Simple2DParticle
    var cost: CGFloat
}

public protocol ParticleType {
    associatedtype T
    
    var position: T { get set }
    var velocity: T { get set }
}

public struct Simple2DParticle: ParticleType {
    public var position: Point2D
    public var velocity: Point2D
    
    var readableForm: String { "\(position.readableForm) -> \(velocity.readableForm)" }
}

public struct Point2D: Equatable {
    public var x, y: CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    var readableForm: String { "(\(x), \(y))" }
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
