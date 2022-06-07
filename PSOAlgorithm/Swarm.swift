//
//  Swarm.swift
//  PSOAlgorithm
//
//  Created by kotars01 on 03/06/2022.
//

import Foundation

public class PSOAlgorithm<Particle: ParticleType> {
    
    var swarm: [Particle] = []
    
    func shouldTerminate() {
        
    }
}

public protocol ParticleType {
    associatedtype T
    
    var position: T { get set }
    var velocity: T { get set }
}

struct Simple2DParticle: ParticleType {
    var position: Point2D
    var velocity: Point2D
}

struct Point2D {
    var x, y: Float
}
