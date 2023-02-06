//
//  FavoritosViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit
import CoreData
import KRProgressHUD

class FavoritosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    var favoritosCellViewModels: [FavoritoCellViewModel] = [FavoritoCellViewModel]()
    var favoritosViewModel: FavoritosViewModel!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("favorites_title", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        favoritosViewModel = FavoritosViewModel()
        
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
            
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        favoritesCollectionView.collectionViewLayout = flowLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    // MARK: - Actions
    
    func loadFavorites() {
        favoritosCellViewModels = favoritosViewModel.getFavorites()
        favoritesCollectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritosCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritosCollectionViewCell", for: indexPath) as? FavoritosCollectionViewCell else {
            return UICollectionViewCell()
        }
        let favoritoCellViewModel: FavoritoCellViewModel = favoritosCellViewModels[indexPath.row]
        cell.configure(favoritoCellViewModel: favoritoCellViewModel)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midWidth = (favoritesCollectionView.frame.width - 10) / 2
        let miheight = midWidth * 2
        return CGSize(width: midWidth, height: miheight)
    }
    
    // MARK: - UICollectionViewDelegate
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoritoCellViewModel: FavoritoCellViewModel = favoritosCellViewModels[indexPath.row]
        let nextStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController: MovieDetailViewController = nextStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as!
        MovieDetailViewController
        movieDetailViewController.movieDetailViewModel = MovieDetailViewModel(id: favoritoCellViewModel.movie.id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
