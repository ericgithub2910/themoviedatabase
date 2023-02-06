//
//  FavoritoViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class FavoritoCellViewModel: NSObject {

    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
}
