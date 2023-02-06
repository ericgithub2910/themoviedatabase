//
//  MovieVideoCellViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class VideoCellViewModel: NSObject {

    let movieVideo: MovieVideo
    
    init(movieVideo: MovieVideo) {
        self.movieVideo = movieVideo
    }
    
    func videoImageURL() -> URL? {
        let urlString = Constants.youtubeImageURL + "\(movieVideo.key)/0.jpg"
        return URL(string: urlString)
    }
}
