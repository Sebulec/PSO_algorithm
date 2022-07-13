//
//  ChartRange.swift
//  DemoApp
//
//  Created by kotars01 on 10/06/2022.
//

import UIKit

struct ChartRange {
    let x, y: CGFloat
    
    func closedRange(for keyPath: KeyPath<Self, CGFloat>) -> ClosedRange<CGFloat> { 0...self[keyPath: keyPath] }
}
