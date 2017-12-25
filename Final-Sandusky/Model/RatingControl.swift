//
//  RatingControl.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/25/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//
// https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementingACustomControl.html

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0
    
    @IBInspectable var starSize: CGSize = CGSize(width: 30, height: 30) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
    
    //MARK: Private methods
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
    }
}
