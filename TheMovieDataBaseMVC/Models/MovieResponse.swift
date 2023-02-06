//
//  Movie.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import Foundation

struct MovieResponse: Codable {
    let id: Int
    let title: String
    let original_title: String
    let overview: String
    let poster_path: String?
    let release_date: String?
    let tagLine: String?
    let vote_average: Double
    let genres: [Genre]?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
