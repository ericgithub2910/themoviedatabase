//
//  MoviesDetailCollectionViewCell.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieDetailImageView: UIImageView!
    @IBOutlet weak var movieDetailTitleLabel: UILabel!
    @IBOutlet weak var movieDetailDateLabel: UILabel!
    @IBOutlet weak var movieDetailTextLabel: UILabel!
    @IBOutlet weak var movieDetailRateLabel: UILabel!
    
    func configure(cellViewModel: MoviesCellViewModel) {
        movieDetailImageView.sd_setImage(with: cellViewModel.getPosterPathURL())
        movieDetailImageView.layer.cornerRadius = 10 //  Le damos la forma redondeada a el movieImageView
        movieDetailTitleLabel.text = "\(cellViewModel.movie.original_title)"
        movieDetailDateLabel.text =  "\(cellViewModel.movie.release_date)"
        movieDetailTextLabel.text = "\(cellViewModel.movie.overview)"
        movieDetailRateLabel.text = "★\(cellViewModel.movie.vote_average)"
    }
}
