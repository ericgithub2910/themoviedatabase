//
//  MoviesCellViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class MoviesCellViewModel: NSObject {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getPosterPathURL() -> URL? {
        let imageURLString = Constants.imageW154BaseURL + movie.poster_path
        let url: URL? = URL(string: imageURLString)
        return url
    }
}
