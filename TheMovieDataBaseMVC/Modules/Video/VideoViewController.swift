//
//  VideoViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {
    
    var videoViewModel: VideoViewModel!
    
    @IBOutlet weak var movieWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = videoViewModel.movieVideo.name
        
        if let url = videoViewModel.videoURL() {
            let request = URLRequest(url: url)
            movieWebView.load(request)
        }
    }
}
