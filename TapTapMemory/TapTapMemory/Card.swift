//
//  Card.swift
//  TapTapMemory
//
//  Created by Elisa Luan on 2019-09-20.
//  Copyright © 2019 Elisa Luan. All rights reserved.
//
import Foundation

import UIKit

class Card {
    
    // MARK: - Properties
    var id = 0
    var image: UIImage?
    var isMatched = false
    var isFlipped = false
    
    static var allCards = [Card]()
    
    init() {
        self.id = 0
        self.isMatched = false
        self.isFlipped = false
    }
    
    init(id: Int, image: UIImage?) {
        self.id = id
        self.image = image
        self.isMatched = false
        self.isFlipped = false
    }
    
    init(card: Card) {
        self.id = card.id
        self.image = card.image
        self.isMatched = card.isMatched
        self.isFlipped = card.isFlipped
    }
    
    // MARK: - Methods
    func copy() -> Card {
        return Card(card: self)
    }
    
    func resetCard() {
        isMatched = false
        isFlipped = false
    }
}
