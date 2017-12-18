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
    var dataController: DataController!
    var optimistic: Bool!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var myRatingLabel: UILabel!
    @IBOutlet weak var femaleCharacterLabel: UILabel!
    @IBOutlet weak var herStoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        //https://stackoverflow.com/questions/39223039/override-back-button-in-navigation-controller
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Movies", style: .done, target: self, action: #selector(self.backToInitial(sender:)))
    }

    func updateUI() {
        self.title = movie.name
        yearLabel.text = "Year: \(movie.year)"
        genreLabel.text = "Genre: \(movie.genre!)"
        ratingLabel.text = "Rating: \(String(format: "%.1f", movie.rating))/5"
        myRatingLabel.text = "My rating: \(String(format: "%.1f", movie.userRating))/5"
        femaleCharacterLabel.text = "Main female character? \((movie.mainFemaleCharacter ? "Yes" : "No"))"
        herStoryLabel.text = "Her story? \((movie.herStory ? "Yes" : "No"))"
        if movie.poster != "" {
            loadPoster()
        }
    }
    
    func loadPoster() {
        guard let url = URL(string: movie.poster!) else {
            print("that string wasn't a url")
            return
        }
        
        //create data task
        let task = URLSession.shared.dataTask(with: url, completionHandler: handlePosterDataLoad(data:response:error:))
        
        //resume task
        task.resume()
    }
    
    func handlePosterDataLoad(data: Data?, response: URLResponse?, error: Error?) {
        //handle error/no data
        guard error == nil, let data = data else {
            print("either there was an error or no data")
            return
        }
        
        let downloadedImage = UIImage(data: data)
        
        DispatchQueue.main.async {
            self.posterImageView.image = downloadedImage
        }
    }
    
//    func handlePosterImageLoad(data: Data?, response: URLResponse?, error: Error?) {
//        //check that we got data back
//        guard error == nil, let data = data else {
//            print("no data or an error")
//            return
//        }
//
//        let downloadedImage = UIImage(data: data)
//
//        DispatchQueue.main.async {
//            self.posterImageView.image = downloadedImage
//        }
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addMovieViewController = segue.destination as! AddMovieViewController
        addMovieViewController.dataController = dataController
        addMovieViewController.movie = movie
        addMovieViewController.optimistic = optimistic
    }
    
    @objc func backToInitial(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func swipeRight(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
