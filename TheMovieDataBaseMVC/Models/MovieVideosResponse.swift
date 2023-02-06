//
//  MovieVideosResponse.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import Foundation

struct MovieVideosResponse: Codable {
    let results: [MovieVideo]?
}

struct MovieVideo: Codable {
    let name: String
    let key: String
    let site: String
}
