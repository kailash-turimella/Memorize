//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Kailash Turimella on 1/2/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            GameView(emojiGame: game)
        }
    }
}
