//
//  MovieDetailViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: Movie!
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myRatingLabel: UILabel!
    @IBOutlet weak var femaleCharacterLabel: UILabel!
    @IBOutlet weak var herStoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    func updateUI() {
        self.title = movie.name
        yearLabel.text = "Year: \(movie.year)"
        genreLabel.text = "Genre: \(movie.genre!)"
        ratingLabel.text = "Rating: \(String(format: "%.1f", movie.rating))/10"
        myRatingLabel.text = "My rating: \(String(format: "%.1f", movie.userRating))/10"
        femaleCharacterLabel.text = "Main female character? \((movie.mainFemaleCharacter ? "Yes" : "No"))"
        herStoryLabel.text = "Her story? \((movie.herStory ? "Yes" : "No"))"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
