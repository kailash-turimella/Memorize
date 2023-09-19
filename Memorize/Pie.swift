//
//  Pie.swift
//  Memorize
//
//  Created by Kailash Turimella on 1/10/22.
//

import SwiftUI

struct Pie: Shape{
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let startPoint = CGPoint(
            x: centerPoint.x + radius * CGFloat(cos(startAngle.radians)),
            y: centerPoint.y + radius * cos(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: centerPoint)
        p.addLine(to: startPoint)
        p.addArc(center: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: centerPoint)
        return p
    }
}
