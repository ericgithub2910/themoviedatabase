//
//  Constants.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import Foundation

class Constants {
    
    // Constantes de TMDB
    static let apiURL = "https://api.themoviedb.org/3"
    static let api_key = "6a55c83d79ccb0ee520ab24d9185feb0"
    static let imageW154BaseURL = "https://image.tmdb.org/t/p/w154"
    static let youtubeImageURL = "https://img.youtube.com/vi/"
    static let youtubeVideoURL = "https://www.youtube.com/watch?v="

    // Constantes de UserDefaults
    static let username = "username"
    static let password = "password"
    static let request_token = "request_token"
    static let session_id = "session_id"
}

enum MovieType: String {
    case popular
    case top_rated
    case upcoming
    case now_playing
}
