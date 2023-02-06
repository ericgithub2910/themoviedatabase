//
//  VideoCellViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class VideoViewModel: NSObject {

    let movieVideo: MovieVideo

    init(movieVideo: MovieVideo) {
        self.movieVideo = movieVideo
    }
    
    func videoURL() -> URL? {
        let urlString = Constants.youtubeVideoURL + "\(movieVideo.key)"
        return URL(string: urlString)
    }
}
