//
//  GameView.swift
//  Memorize
//
//  Created by Kailash Turimella on 1/2/22.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var emojiGame: EmojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack{
            ZStack(alignment: .bottom){
                gameBody
                deckBody
            }
            HStack{
                shuffle
                Spacer()
                restart
            }.padding(.horizontal)
        }
    }
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = emojiGame.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (Constants.totalDealDuration / Double(emojiGame.cards.count))
        }
        return Animation.easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(emojiGame.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: emojiGame.cards, aspectRatio: Constants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(Constants.cardPadding)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            emojiGame.choose(card)
                        }
                }
            }
        }
        .foregroundColor(Constants.gameTheme)
    }
    var deckBody: some View {
        ZStack{
            ForEach(emojiGame.cards.filter(isUndealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: Constants.undealtWidth, height: Constants.undealtHeight)
        .foregroundColor(Constants.gameTheme)
        .onTapGesture {
            for card in emojiGame.cards{
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    var shuffle: some View {
        Button("Shuffle"){
            withAnimation {
                emojiGame.shuffle()
            }
        }.font(.largeTitle)
    }
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                emojiGame.restart()
            }
        }.font(.largeTitle)
    }
    private struct Constants {
        static let gameTheme = Color.red
        static let borderColor = UIColor(red: 100, green: 0, blue: 0, alpha: 1)
        static let animationDuration: CGFloat = 3
        static let dealDuration: CGFloat = 0.5
        static let totalDealDuration: CGFloat = 2
        static let cardPadding: CGFloat = 4
        static let aspectRatio: CGFloat = 2/3
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
    }
}
struct CardView : View{
    let card: MemoryGame<String>.Card
    @State private var animatedBonusRemaining: Double = 0
    var body: some View{
        GeometryReader { geometry in
            ZStack {
                Group{
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(Constants.timerPadding)
                    .opacity(Constants.timerOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360:0))
                    .animation(Animation.easeInOut(duration: 1))
                    .font(Font.system(size: Constants.contentFontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (Constants.contentFontSize / Constants.contentScale)
    }
    private struct Constants {
        static let contentScale: CGFloat = 0.7
        static let contentFontSize: CGFloat = 32
        static let timerPadding: CGFloat = 6
        static let timerOpacity: Double = 0.5
    }
}


























struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame();
//        game.choose(game.cards.first!)
        return GameView(emojiGame: game)
            .preferredColorScheme(.dark)
    }
}
