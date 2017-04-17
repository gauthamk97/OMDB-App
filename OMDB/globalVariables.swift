//
//  globalVariables.swift
//  OMDB
//
//  Created by Gautham Kumar on 17/04/17.
//  Copyright © 2017 Gautham Kumar. All rights reserved.
//

import Foundation

var selectedMovie: [String:Any] = [:]
var recentMovies = [[String: String]]() //First element is IMDB ID (Used to obtain movie info). Second is Movie Title (Used to display in the table)
var recentMovieData = [[String:Any]]()
var recentMoviesCount=0

var favoriteMovies = [String: [String:Any]]()
var favoriteMovieKeys = [String]()
