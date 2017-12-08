//
//  AddMovieViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import UIKit
import CoreData

protocol MovieSaver {
    func saveMovie(movie: Movie)
}

class AddMovieViewController: UIViewController {

    var dataController: DataController!
    var movie: Movie?
    var optimistic: Bool!
    var updatingMovie = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var userRatingTextField: UITextField!
    @IBOutlet weak var userRatingSlider: UISlider!
    @IBOutlet weak var femaleCharacterSwitch: UISwitch!
    @IBOutlet weak var herStorySwitch: UISwitch!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let oldMovie = movie {
//            fetchData(movieToFind: oldMovie)
            updatingMovie = true
            nameTextField.text = oldMovie.name
            yearTextField.text = oldMovie.year.description
            genreTextField.text = oldMovie.genre
            ratingSlider.value = oldMovie.rating
            userRatingSlider.value = oldMovie.userRating
            femaleCharacterSwitch.isOn = oldMovie.mainFemaleCharacter
            herStorySwitch.isOn = oldMovie.herStory
            userRatingTextField.text = String(format: "%.1f", userRatingSlider.value)
            ratingTextField.text = String(format: "%.1f", ratingSlider.value)
        } else {
            switch optimistic {
            case true:
                femaleCharacterSwitch.setOn(true, animated: false)
                herStorySwitch.setOn(true, animated: false)
            case false:
                femaleCharacterSwitch.setOn(false, animated: false)
                 herStorySwitch.setOn(false, animated: false)
            default:
                break
            }
        }
    }
    
    @IBAction func userRatingSliderChanged(_ sender: Any) {
        userRatingTextField.text = String(format: "%.1f", userRatingSlider.value)
    }
    
    @IBAction func ratingSliderChanged(_ sender: Any) {
        ratingTextField.text = String(format: "%.1f", ratingSlider.value)
    }
    
    func fetchData(movieToFind: String) -> Bool {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "name == %@", movieToFind)

        if var result = try? dataController.viewContext.fetch(fetchRequest) {
            if let oldMovie = result.popLast() {
                movie = oldMovie
                return true
            } else {
                print("movie not found")
            }
        } else {
            print("fetch request failed")
        }
        return false
    }

    @IBAction func saveMovieButtonTapped(_ sender: Any) {
        if genreTextField.text != "" && nameTextField.text != "" && yearTextField.text != "" {
            if fetchData(movieToFind: movie!.name!) && updatingMovie {
                movie!.genre = genreTextField.text
                movie!.herStory = herStorySwitch.isOn
                movie!.rating = ratingSlider.value
                movie!.mainFemaleCharacter = femaleCharacterSwitch.isOn
                movie!.name = nameTextField.text
                movie!.userRating = userRatingSlider.value
                movie!.year = Int32(yearTextField.text!)!
            } else {
                let newMovie = Movie(context: dataController.viewContext)
                newMovie.genre = genreTextField.text
                newMovie.herStory = herStorySwitch.isOn
                newMovie.rating = ratingSlider.value
                newMovie.mainFemaleCharacter = femaleCharacterSwitch.isOn
                newMovie.name = title
                newMovie.userRating = userRatingSlider.value
                newMovie.year = Int32(yearTextField.text!)!
                movie = newMovie
            }
            
            try? dataController.viewContext.save()
            
            warningLabel.textColor = .white
            
            //https://stackoverflow.com/questions/25444213/presenting-viewcontroller-with-navigationviewcontroller-swift
            let movieDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "movieDetailView") as! MovieDetailViewController
            movieDetailViewController.movie = movie
            movieDetailViewController.dataController = dataController
            movieDetailViewController.optimistic = optimistic
            self.navigationController!.pushViewController(movieDetailViewController, animated: true)
        } else {
            print("oh no")
            warningLabel.textColor = .red
        }
    }

}

