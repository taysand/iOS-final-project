//
//  CodableMovie.swift
//  Final-Sandusky
//
//  Created by Taylor Sandusky on 12/18/17.
//  Copyright © 2017 Taylor Sandusky. All rights reserved.
//

import Foundation

struct CodableMovie: Codable {
    let Title: String
    let Year: String
    let Genre: String
    let Plot: String
    let Poster: String
    let imdbRating: String
    
}

//{"Title":"Wonder Woman",
//"Year":"2017",
//"Rated":"PG-13",
//"Released":"02 Jun 2017",
//"Runtime":"141 min",
//"Genre":"Action, Adventure, Fantasy",
//"Director":"Patty Jenkins",
//"Writer":"Allan Heinberg (screenplay by), Zack Snyder (story by), Allan Heinberg (story by), Jason Fuchs (story by), William Moulton Marston (Wonder Woman created by)",
//"Actors":"Gal Gadot, Chris Pine, Connie Nielsen, Robin Wright",
//"Plot":"When a pilot crashes and tells of conflict in the outside world, Diana, an Amazonian warrior in training, leaves home to fight a war, discovering her full powers and true destiny.",
//"Language":"English, German, Dutch, French, Spanish, Chinese, Greek,  Ancient (to 1453), North American Indian",
//"Country":"Hong Kong, China, USA",
//"Awards":"8 wins & 13 nominations.",
//"Poster":"https://images-na.ssl-images-amazon.com/images/M/MV5BNDFmZjgyMTEtYTk5MC00NmY0LWJhZjktOWY2MzI5YjkzODNlXkEyXkFqcGdeQXVyMDA4NzMyOA@@._V1_SX300.jpg",
//"Ratings":[{"Source":"Internet Movie Database","Value":"7.6/10"},{"Source":"Rotten Tomatoes","Value":"92%"},{"Source":"Metacritic","Value":"76/100"}],
//"Metascore":"76",
//"imdbRating":"7.6",
//"imdbVotes":"337,662",
//"imdbID":"tt0451279",
//"Type":"movie",
//"DVD":"19 Sep 2017",
//"BoxOffice":"$412,400,625"
//"Production":"Warner Bros. Pictures",
//"Website":"http://wonderwomanfilm.com/",
//"Response":"True"}

