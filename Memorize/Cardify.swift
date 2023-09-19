//
//  Cardify.swift
//  Memorize
//
//  Created by Kailash Turimella on 1/11/22.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0:180
    }
    
    var animatableData: Double {
        get {rotation}
        set {rotation = newValue}
    }
    var rotation: Double // in Degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)

            if rotation < 90{
                shape.fill(.white)
                shape.strokeBorder(lineWidth: Constants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation<90 ? 1:0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    private struct Constants {
        static let cornerRadius: CGFloat = 25
        static let lineWidth: CGFloat = 3
    }
}

extension View{
    func cardify(isFaceUp: Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
