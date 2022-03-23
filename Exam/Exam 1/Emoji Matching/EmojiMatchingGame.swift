//
//  EmojiMatchingGame.swift
//  Emoji Matching
//
//  Created by Jingkun Liu on 3/22/22.
//

import Foundation

class EmojiMatchingGame: NSObject {
    
    enum CardState: String {
        case normal = "not flipped"
        case flipped = "flipped"
        case removed = "removed"
    }
    
    class GameState {
        
        enum GameStatus: String {
            case normal = "No card has been flipped"
            case one_flipped = "One Card flipped"
            case await_checking = "Waiting for check"
            case all_removed = "All cards removed"
        }
        
        var cardIndex = Array.init(repeating: -1, count: 2)
        var gameStatus: GameStatus
        var numFlipped: Int
        
        init() {
            self.gameStatus = .normal
            self.numFlipped = 0
        }
        
        func simpleDescription() -> String {
            switch self.gameStatus {
            case .normal, .all_removed, .await_checking:
                return "\(self.gameStatus.rawValue)"
            case .one_flipped:
                return "One card at index \(self.cardIndex[0]) has been flipped"
            }
        }
    }
    
    let allCardBacks = Array("🎆🎇🌈🌅🌇🌉🌃🌄⛺⛲🚢🌌🌋🗽")
    let allEmojiCharacters = Array("🚁🐴🐇🐢🐱🐌🐒🐞🐫🐠🐬🐩🐶🐰🐼⛄🌸⛅🐸🐳❄❤🐝🌺🌼🌽🍌🍎🍡🏡🌻🍉🍒🍦👠🐧👛🐛🐘🐨😃🐻🐹🐲🐊🐙")
    
    var cards = [Character]()
    var cardStates = [CardState]()
    var gameState = GameState()
    var cardBack = Character(" ")
    var numPairs = 0
    
    init(numPairs: Int) {
        super.init()
        self.numPairs = numPairs

        self.startNewTurn()
    }
    
    func startNewTurn() {
        
        let cardBackIndex = Int(arc4random_uniform(UInt32(self.allCardBacks.count)))
        self.cardBack = self.allCardBacks[cardBackIndex]
        
        self.cardStates = Array.init(repeating: .normal, count: self.numPairs*2)
        
        var emojiSymbols = [Character]()
        while emojiSymbols.count < self.numPairs {
            let cardEmojiIndex = Int(arc4random_uniform(UInt32(allEmojiCharacters.count)))
            let emoji = self.allEmojiCharacters[cardEmojiIndex]
            
            if !emojiSymbols.contains(emoji) {
                emojiSymbols.append(emoji)
            }
        }
        self.cards = emojiSymbols + emojiSymbols
        self.cards.shuffle()
        
        self.gameState = GameState()
    }
    
    func pressedCard(at index: Int) {
        if self.gameState.numFlipped == 2 {
            print("ERROR: no card can be flipped")
            return
        }
        
        if self.gameState.gameStatus == .all_removed {
            print("ERROR: Game has finished")
            return
        }
        
        switch self.cardStates[index] {
        case .flipped, .removed:
            print("ERROR: this card cannot be flipped")
            return
        case .normal:
            self.cardStates[index] = .flipped
            self.gameState.cardIndex[self.gameState.numFlipped] = index
            self.gameState.numFlipped += 1
        }
        
        if self.gameState.numFlipped == 1 {
            self.gameState.gameStatus = .one_flipped
        } else if self.gameState.numFlipped == 2 {
            self.gameState.gameStatus = .await_checking
        }
    }
    
    func checkTwoFlippedCard() {
        
        if self.gameState.numFlipped < 2 {
            print("ERROR: not enough flipped cards")
            return
        }
        
        let firstIndex = self.gameState.cardIndex[0]
        let secondIndex = self.gameState.cardIndex[1]
        
        if self.cards[firstIndex] == self.cards[secondIndex] {
            self.cardStates[firstIndex] = .removed
            self.cardStates[secondIndex] = .removed
        } else {
            self.cardStates[firstIndex] = .normal
            self.cardStates[secondIndex] = .normal
        }
        
        self.gameState.numFlipped = 0
        self.gameState.cardIndex = Array.init(repeating: -1, count: 2)
        
        self.gameState.gameStatus = self.isAllRemoved() ? .all_removed : .normal
    }
    
    func isAllRemoved() -> Bool {
        for state in self.cardStates {
            if state != .removed {
                return false
            }
        }
        return true
    }
    
    func cardStateToString() -> String {
        var returnStr = ""
        for i in 0..<self.cardStates.count {
            switch self.cardStates[i] {
            case .normal:
                returnStr.append(self.cardBack)
            case .flipped:
                returnStr.append(self.cards[i])
            case .removed:
                returnStr.append(" ")
            }
        }
        return returnStr
    }

    override var description: String {
        return "\(self.gameState.simpleDescription()): \(self.cardStateToString())"
    }
}

extension Array {
  mutating func shuffle() {
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      self.swapAt(i, j)
    }
  }
}
