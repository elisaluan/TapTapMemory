//
//  CardCell.swift
//  TapTapMemory
//
//  Created by Elisa Luan on 2019-09-20.
//  Copyright © 2019 Elisa Luan. All rights reserved.
//

import Foundation
import UIKit
//import AFNetworking

class CardCell: UICollectionViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card? {
        didSet {
            guard let card = card else { return }
            
            frontImageView.layer.cornerRadius = 5.0
            backImageView.layer.cornerRadius = 5.0
            
            frontImageView.layer.masksToBounds = true
            backImageView.layer.masksToBounds = true
        }
    }
    
    var shown: Bool = false
    
    // MARK: - Methods
    func showCard(_ show: Bool, animted: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        shown = show
        
        if animted {
            if show {
                UIView.transition(
                    from: backImageView,
                    to: frontImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(
                    from: frontImageView,
                    to: backImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubviewToFront(toFront: frontImageView)
                backImageView.isHidden = true
            } else {
                bringSubviewToFront(toFront: backImageView)
                frontImageView.isHidden = true
            }
        }
    }
}

