//
//  MoviesTableViewController.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/6/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//
// LaunchScreen image from https://pixabay.com/en/clapboard-movie-film-clapper-scene-311208/

import UIKit
import CoreData

class MoviesTableViewController: UITableViewController {

    var movies:[Movie] = []
    var dataController: DataController!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var optimismButton: UIBarButtonItem!
    var optimistic = false
    
    //sorting
//    var picker = UIPickerView()
    let pickerDataSource = ["Title", "Rating", "Year", "Female Character", "Her Story"];

    override func viewDidLoad() {
        super.viewDidLoad()
        optimistic = userDefaults.bool(forKey: "optimistic")
        reloadData()
        
        //set up sorting picker
        //https://stackoverflow.com/questions/42319153/show-uipickerview-on-label-click
//        picker.frame = CGRect(x: 0, y: view.bounds.height / 1.7, width: view.bounds.width, height: 200)
//        picker.backgroundColor = .white
//        picker.delegate = self
//        picker.dataSource = self
//        picker.isHidden = true
//        view.addSubview(picker)
    }
    
    func reloadData() {
//        updateOptimism()
        fetchData()
    }
    
//    func updateOptimism() {
//        switch optimistic {
//        case true:
//            optimismButton.tintColor = .green
//        case false:
//            optimismButton.tintColor = .red
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
//        picker.isHidden = false
        
        //https://stackoverflow.com/questions/40190629/swift-uialertcontroller-with-pickerview-button-action-stay-up/40191156#40191156
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 150)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Sort by", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        self.present(editRadiusAlert, animated: true)
//
//        optimistic = !optimistic
//        updateOptimism()
//        userDefaults.set(optimistic, forKey: "optimistic")
    }
    
    // MARK: - Core Data
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest();
        let sortByTitleAscending = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortByTitleAscending]

        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            movies = result
            tableView.reloadData()
        } else {
            print("couldn't fetch data")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellIdentifier", for: indexPath)
        
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.name
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let movieToDelete = movies[indexPath.row]
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataController.viewContext.delete(movieToDelete)
            try? dataController.viewContext.save()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            print("no identifier")
            return
        }
        
        switch identifier {
        case "specificMovieSegue":
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedMovie = movies[selectedRow!]
            movieDetailViewController.movie = selectedMovie
            movieDetailViewController.dataController = dataController
            movieDetailViewController.optimistic = optimistic
        case "addMovieSegue":
            let addMovieViewController = segue.destination as! AddMovieViewController
            addMovieViewController.dataController = dataController
            addMovieViewController.optimistic = optimistic
        default:
            break
        }
    }
}

extension MoviesTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row] as String
    }
}
