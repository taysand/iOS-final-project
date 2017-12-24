//
//  AddMovieViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import UIKit
import CoreData

class AddMovieViewController: UIViewController {

    var dataController: DataController!
    var movie: Movie?
    var optimistic = false
    var updatingMovie = false
    var posterURL = ""
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var userRatingTextField: UITextField!
    @IBOutlet weak var userRatingSlider: UISlider!
    @IBOutlet weak var femaleCharacterSwitch: UISwitch!
    @IBOutlet weak var herStorySwitch: UISwitch!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optimistic = UserDefaults.standard.bool(forKey: "optimistic")
        
        //https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if let oldMovie = movie {
            self.title = "Edit Movie"
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
            posterURL = oldMovie.poster!
        } else {
            self.title = "Add Movie"
            femaleCharacterSwitch.setOn(optimistic, animated: false)
            herStorySwitch.setOn(optimistic, animated: false)
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
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if nameTextField.text == "" {
            infoLabel.textColor = .red
            infoLabel.text = "Enter a title"
        } else {
            infoLabel.textColor = .black
            infoLabel.text = "Searching"
            
            //make api url
            var url = "https://www.omdbapi.com/?apikey=ced835d8&type=movie"
            if yearTextField.text != "" {
                //use year
                let yearString = yearTextField.text!.trimmingCharacters(in: .whitespaces)
                url = url + "&y=\(yearString)"
            }
            var titleString = nameTextField.text!.trimmingCharacters(in: .whitespaces)
            titleString = titleString.replacingOccurrences(of: " ", with: "+")
            url = url + "&t=\(titleString)"
            print(url)
            loadMovie(link: url)
        }
    }
    
    func loadMovie(link: String) {
        guard let movieURL = URL(string: link) else {
            print("that string wasn't a url")
            searchFailed()
            return
        }
        
        //create data task
        let task = URLSession.shared.dataTask(with: movieURL, completionHandler: handleMovieDataLoad(data:response:error:))
        
        //resume task
        task.resume()
    }
    
    func searchFailed() {
        DispatchQueue.main.async {
            self.infoLabel.textColor = .red
            self.infoLabel.text = "Search failed"
        }
    }
    
    func handleMovieDataLoad(data: Data?, response: URLResponse?, error: Error?) {
        //handle error/no data
        guard error == nil, let data = data else {
            print("either there was an error or no data")
            searchFailed()
            return
        }
        
        //if we got data back, decode the JSON
        let decoder = JSONDecoder()
        let tempMovie: CodableMovie
        do {
            tempMovie = try decoder.decode(CodableMovie.self, from: data)
        } catch {
            print("couldn't decode JSON to struct")
            searchFailed()
            return
        }
        
        //fill in fields
        DispatchQueue.main.async {
            self.nameTextField.text = tempMovie.Title
            self.yearTextField.text = tempMovie.Year.description
            self.genreTextField.text = tempMovie.Genre
            if let onlineRating = Float(tempMovie.imdbRating) {
                self.ratingSlider.value = onlineRating / 2
            } else {
                self.ratingSlider.value = 3
            }
            self.ratingTextField.text = String(format: "%.1f", self.ratingSlider.value)
            //plot
        }
        posterURL = tempMovie.Poster
        
        DispatchQueue.main.async {
            self.infoLabel.textColor = .green
            self.infoLabel.text = "Successful search"
        }
    }
    
    @IBAction func saveMovieButtonTapped(_ sender: Any) {
        if genreTextField.text != "" && nameTextField.text != "" && yearTextField.text != "" {
            let genre = genreTextField.text
            let herStory = herStorySwitch.isOn
            let rating = ratingSlider.value
            let femaleCharacter = femaleCharacterSwitch.isOn
            let name = nameTextField.text
            let userRating = userRatingSlider.value
            let year = Int32(yearTextField.text!)!
            if updatingMovie && fetchData(movieToFind: movie!.name!) {
                movie!.genre = genre
                movie!.herStory = herStory
                movie!.rating = rating
                movie!.mainFemaleCharacter = femaleCharacter
                movie!.name = name
                movie!.userRating = userRating
                movie!.year = year
                movie!.poster = posterURL
            } else {
                let newMovie = Movie(context: dataController.viewContext)
                newMovie.genre = genre
                newMovie.herStory = herStory
                newMovie.rating = rating
                newMovie.mainFemaleCharacter = femaleCharacter
                newMovie.name = name
                newMovie.userRating = userRating
                newMovie.year = year
                newMovie.poster = posterURL
                movie = newMovie
            }
            
            try? dataController.viewContext.save()
            
            infoLabel.textColor = .white
            
            //https://stackoverflow.com/questions/25444213/presenting-viewcontroller-with-navigationviewcontroller-swift
            let movieDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "movieDetailView") as! MovieDetailViewController
            movieDetailViewController.movie = movie
            movieDetailViewController.dataController = dataController
            self.navigationController!.pushViewController(movieDetailViewController, animated: true)
        } else {
            print("oh no")
            infoLabel.textColor = .red
            infoLabel.text = "Please fill all fields"
        }
    }
    
}

