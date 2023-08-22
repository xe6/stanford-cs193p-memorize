//
//  ContentView.swift
//  Memorize
//
//  Created by Max Ellisen on 22.08.2023.
//

import SwiftUI

struct ContentView: View {
    let halloweenEmojis: [String] = ["👻", "👻", "🎃", "🎃", "🕷️", "🕷️", "😈", "😈", "💀", "💀", "🕸️", "🕸️", "🧙", "🧙", "🙀", "🙀", "👹", "👹", "😱", "😱", "☠️", "☠️", "🍭", "🍭"]
    let winterEmojis: [String] = ["🥶", "🥶", "❄️", "❄️", "☃️", "☃️", "🧣", "🧣", "🏂", "🏂", "🎅", "🎅", "🌨️", "🌨️", "🧤", "🧤", "🎿", "🎿", "⛸️", "⛸️", "🤧", "🤧", "🛷", "🛷"]
    let fruitsEmojis: [String] = ["🍒", "🍒", "🍓", "🍓", "🍇", "🍇", "🥑", "🥑", "🍎", "🍎", "🍉", "🍉", "🍑", "🍑", "🍋", "🍋", "🥝", "🥝", "🫐", "🫐", "🍌", "🍌", "🍐", "🍐"]
    
    @State var currentTheme: [String] = ["🍒", "🍓", "🍇", "🥑", "🍎", "🍉", "🍑", "🍋", "🥝", "🫐", "🍌", "🍐", "🍒", "🍓", "🍇", "🥑", "🍎", "🍉", "🍑", "🍋", "🥝", "🫐", "🍌", "🍐"] // Should replace initial assignment later
    
    @State var cardCount: Int = 24
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle).padding(.bottom)
            ScrollView {
                cards
            }
            Spacer()
//            cardCountAdjusters
            themeAdjuster.padding()
        }
        .padding()
    }
    
    var themeAdjuster: some View {
        HStack {
            themeSelectorButton(theme: "Halloween", symbol: "apple.logo")
            Spacer()
            themeSelectorButton(theme: "Winter", symbol: "snowflake")
            Spacer()
            themeSelectorButton(theme: "Fruits", symbol: "carrot")
        }.imageScale(.large)
    }
    
    
    func themeSelectorButton(theme: String, symbol: String) -> some View {
        Button(action: {
           setTheme(theme: theme)
        }, label: {
            VStack{
                Image(systemName: symbol).padding(2)
                Text(theme).font(.caption)
            }
        })
    }
    
    func setTheme(theme: String) -> Void {
        switch theme {
        case "Halloween":
            currentTheme = halloweenEmojis.shuffled()
        case "Winter":
            currentTheme = winterEmojis.shuffled()
        case "Fruits":
            currentTheme = fruitsEmojis.shuffled()
        default:
            currentTheme = fruitsEmojis.shuffled()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: currentTheme[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.red)
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > halloweenEmojis.count)
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}
