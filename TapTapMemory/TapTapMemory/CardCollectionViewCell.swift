//
//  CardCollectionViewCell.swift
//  TapTapMemory
//
//  Created by Elisa Luan on 2019-09-21.
//  Copyright © 2019 Elisa Luan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card: Card) {
        // keep track of card passed in
        self.card = card
        
        if (card.isMatched == true) {
            // if matched make invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        } else {
            // if not match make visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = card.image
        
        // determine if card in flipped up or down state
        if (card.isFlipped == true) {
            
            // front image view on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        } else {
            
            // back image view on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
    }
    
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.2, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.2, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)

        }
    }
    
    func remove() {
        
        // remove visibility of both card faces
        backImageView.alpha = 0;
        
        // animate it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut,animations: {
            self.frontImageView.alpha = 0;
        }, completion: nil)
    }
}
