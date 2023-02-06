//
//  FavoritosCollectionViewCell.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class FavoritosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieTextLabel: UILabel!
    @IBOutlet weak var movieRateLabel: UILabel!
    
    func configure(favoritoCellViewModel: FavoritoCellViewModel) {
        let imageURLString = Constants.imageW154BaseURL + favoritoCellViewModel.movie.poster_path
        let url: URL? = URL(string: imageURLString)
        movieImageView.sd_setImage(with: url)
        movieImageView.layer.cornerRadius = 10 //  Le damos la forma redondeada a el movieImageView
        
        movieTitleLabel.text = "\(favoritoCellViewModel.movie.original_title)"
        movieDateLabel.text =  "\(favoritoCellViewModel.movie.release_date)"
        movieTextLabel.text = "\(favoritoCellViewModel.movie.overview)"
        movieRateLabel.text = "★\(favoritoCellViewModel.movie.vote_average)"
    }
}
