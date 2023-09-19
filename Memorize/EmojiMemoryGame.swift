//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Kailash Turimella on 1/5/22.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["😀", "😃", "😄", "😁", "😆", "😅" ,"😂", "🤣", "🥲", "☺️", "😊", "😇", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐"]
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairs: 10) { index in
            return emojis[index]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    func choose(_ card: Card){
        model.choose(card)
    }
    func shuffle() {
        model.shuffle();
    }
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
