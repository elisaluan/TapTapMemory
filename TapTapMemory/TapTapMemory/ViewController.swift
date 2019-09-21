//
//  ViewController.swift
//  TapTapMemory
//
//  Created by Elisa Luan on 2019-09-20.
//  Copyright © 2019 Elisa Luan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func shuffleButton(_ sender: UIButton) {
        self.shuffle();
        DispatchQueue.main.async {self.collectionView.reloadData()}
    }
    
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var secondFlippedCardIndex:IndexPath?
    var thirdFlippedCardIndex:IndexPath?
    
    let matchesToWin = 10
    var numMatches = 0
    var timer:Timer?
    var maxPointsEach = 100
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.getCards()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func getCards(){
        // declare array stores cards
        let numCards = 10
        let numCardForMatch = 2
        var tempCard = Card()
        
        
        // pairs cards
            // json
        if let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let products = json["products"] as? [Any] {
                        for uniqueImage in 1...numCards {
                            if let product = products[uniqueImage] as? [String: Any] {
                                if let image = product["image"] as? [String: Any] {
                                    if let src = image["src"] as? String {
                                        let imageURL = URL(string: src)
                                        let imageData = try? Data(contentsOf: imageURL!)
                                        let uImage = UIImage(data: imageData!)
                                        for _ in 1...numCardForMatch {
                                            tempCard = Card(id: uniqueImage,image: uImage)
                                            self.cardArray.append(tempCard)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.shuffle()
                DispatchQueue.main.async {self.collectionView.reloadData()}
            }.resume()
        }
    }
    
    // MARK: UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get CardCollectionView object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // get card to be displayed
        let card = cardArray[indexPath.row]
        
        // set card for cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // get user selected cell
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // get user selected card
        let card = cardArray[indexPath.row]
        
        if (card.isFlipped == false && card.isMatched == false) {
            
            // flip card
            cell.flip()
            
            card.isFlipped = true;
            
            // determine if first, second, third, fourth card being flipped
            if(firstFlippedCardIndex == nil) {
                
                // first card being flipped
                firstFlippedCardIndex = indexPath
                
            } else {
                
                // second card being flipped
                
                // performing matching logic
                checkForMatches(indexPath)
                
            }
        }
        
    } // end didSelectItemAt method
    
    func checkForMatches (_ secondFlippedCardIndex:IndexPath) {
        
        // get cells for two revealed cards
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get cards for two revealed cards
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // compare the two cards
        if (cardOne.id == cardTwo.id) {
            
            // match
            numMatches = numMatches + 1;
            score += maxPointsEach;
            
            // set status of cells on grid
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove from grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // check if end game
            checkGameEnded()
            
        } else {
            // not a match
            
            //set status of cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // reload cell of first card if nil
        if (cardOneCell == nil) {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // resets prop check if first card flipped
        firstFlippedCardIndex = nil
    }
    
    @objc func timerElapsed() {
        maxPointsEach -= 1
        
        let matchesString = String(format: "%d", numMatches)
        let scoreString = String(format: "%d", score)
        scoreLabel.text = "Matches: \(matchesString)   |   Score: \(score)";
    }
    
    func shuffle() {
        var last = cardArray.count - 1
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            
            cardArray.swapAt(last, rand)
            
            last -= 1
        }
    }
    
    func checkGameEnded() {
        let title = "Congratulations!"
        let message = "You've Won"
        // determine if there are 10 matches
        
        // if 10 matches win
        if (numMatches == matchesToWin) {
            showAlert(title, message)
        }
    }
    
    func showAlert(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in self.restart()})
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

    func restart() {
        numMatches = 0
        maxPointsEach = 100
        score = 0
        for index in 1...cardArray.count {
            cardArray[index-1].resetCard()
        }
        self.shuffle()
        DispatchQueue.main.async {self.collectionView.reloadData()}
    }
} // end of ViewControllerClas

