//
//  MovieDetailViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import UIKit
import KRProgressHUD
import SDWebImage
import CoreData

class MovieDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var movieDetailViewModel: MovieDetailViewModel!
    var movieResponse: MovieResponse!
    var videosCellViewModelsArray: [VideoCellViewModel] = [VideoCellViewModel]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        videosCollectionView.dataSource = self
        videosCollectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        videosCollectionView.collectionViewLayout = flowLayout
        videosCollectionView.isPagingEnabled = true
        
        getMovieDetail()
        getMovieVideos()
        
        if movieDetailViewModel.existFavorite() {
            addFavoriteButton.setTitle(NSLocalizedString("remove_favorites", comment: ""), for: UIControl.State.normal)
        } else {
            addFavoriteButton.setTitle(NSLocalizedString("add_favorites", comment: ""), for: UIControl.State.normal)
        }
    }
    
    // MARK: - Actions

    @IBAction func addFavoriteButtonPressed(_ sender: Any) {
        if movieDetailViewModel.existFavorite() {
            movieDetailViewModel.deleteFavorite()
            addFavoriteButton.setTitle(NSLocalizedString("add_favorites", comment: ""), for: UIControl.State.normal)
        } else {
            movieDetailViewModel.addFavorite()
            addFavoriteButton.setTitle(NSLocalizedString("remove_favorites", comment: ""), for: UIControl.State.normal)
        }
    }
    
    // MARK: - API
    
    func getMovieDetail() {
        KRProgressHUD.show()
        
        movieDetailViewModel.getMovieDetail { [weak self] (response: MovieResponse?, error: String?) in
            guard let self = self else { return }
            KRProgressHUD.dismiss()
        
            if let _error = error {
                KRProgressHUD.showError(withMessage: _error)
                return
            }
            
            self.movieResponse = response
            
            DispatchQueue.main.async {
                self.titleLabel.text = self.movieResponse.title
                self.taglineLabel.text = self.movieResponse.tagLine
                self.overviewLabel.text = self.movieResponse.overview
                
                if let _genres = self.movieResponse.genres {
                    for genre in _genres {
                        if self.genresLabel.text == "" {
                            self.genresLabel.text = genre.name
                        } else {
                            self.genresLabel.text = self.genresLabel.text! + ", " + genre.name!
                        }
                    }
                }
                
                let imageURLString = Constants.imageW154BaseURL + (self.movieResponse.poster_path ?? "")
                let url: URL? = URL(string: imageURLString)
                self.posterImageView.sd_setImage(with: url)
                    
                
                if self.movieDetailViewModel.existFavorite() {
                    self.addFavoriteButton.setTitle(NSLocalizedString("remove_favorites", comment: ""), for: UIControl.State.normal)
                } else {
                    self.addFavoriteButton.setTitle(NSLocalizedString("add_favorites", comment: ""), for: UIControl.State.normal)
                }
            }
        }
    }
    
    func getMovieVideos() {
        movieDetailViewModel.getMovieVideos { [weak self] (response: MovieVideosResponse?, error: String?) in
            guard let self = self else { return }
            
            if let _error = error {
                KRProgressHUD.showError(withMessage: _error.description)
                return
            }
            
            let videos: [MovieVideo] = response?.results ?? [MovieVideo]()
            for video in videos {
                let videoCellViewModel: VideoCellViewModel = VideoCellViewModel(movieVideo: video)
                self.videosCellViewModelsArray.append(videoCellViewModel)
            }
            
            DispatchQueue.main.async {
                self.videosCollectionView.reloadData()
            }
        }
    }
    
    // MARK:  UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videosCellViewModelsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieVideoCollectionViewCell", for: indexPath) as? MovieVideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let videoCellViewModel: VideoCellViewModel = videosCellViewModelsArray[indexPath.row]
        cell.configure(videoCellViewModel: videoCellViewModel)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoCellViewModel: VideoCellViewModel = videosCellViewModelsArray[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let videoViewController: VideoViewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        videoViewController.videoViewModel = VideoViewModel(movieVideo: videoCellViewModel.movieVideo)
        navigationController?.pushViewController(videoViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midWidth = videosCollectionView.frame.width
        let miheight = videosCollectionView.frame.height
        return CGSize(width: midWidth, height: miheight)
    }
}


