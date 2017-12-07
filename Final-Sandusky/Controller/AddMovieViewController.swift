//
//  AddMovieViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import UIKit


protocol MovieSaver {
    func saveMovie(movie: Movie)
}

class AddMovieViewController: UIViewController {

    var dataController: DataController!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var userRatingTextField: UITextField!
    @IBOutlet weak var userRatingSlider: UISlider!
    @IBOutlet weak var femaleCharacterSwitch: UISwitch!
    @IBOutlet weak var herStorySwitch: UISwitch!
    
    var optimistic: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func userRatingSliderChanged(_ sender: Any) {
        userRatingTextField.text = String(format: "%.1f", userRatingSlider.value)
    }
    
    @IBAction func ratingSliderChanged(_ sender: Any) {
        ratingTextField.text = String(format: "%.1f", ratingSlider.value)
    }

    @IBAction func saveMovieButtonTapped(_ sender: Any) {
        let newMovie = Movie(context: dataController.viewContext)
        newMovie.genre = genreTextField.text
        newMovie.herStory = herStorySwitch.isOn
        newMovie.rating = ratingSlider.value
        newMovie.mainFemaleCharacter = femaleCharacterSwitch.isOn
        newMovie.name = nameTextField.text
        newMovie.userRating = userRatingSlider.value
        let year = Int32(yearTextField.text!)
        newMovie.year = year!
        try? dataController.viewContext.save()
        navigationController?.popViewController(animated: true)
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

