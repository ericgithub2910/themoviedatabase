//
//  MoviesResponse.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]?
}

struct Movie: Decodable {
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let title: String
    let vote_average: Double
}
