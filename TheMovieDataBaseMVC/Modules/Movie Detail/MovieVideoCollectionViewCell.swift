//
//  MovieVideoCollectionViewCell.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import UIKit

class MovieVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    
    func configure(videoCellViewModel: VideoCellViewModel) {
        //https://img.youtube.com/vi/LonqJIvAx58/0.jpg
        let url: URL? = videoCellViewModel.videoImageURL()
        videoImageView.sd_setImage(with: url)
    }
}
