//
//  MoviesViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import UIKit
import KRProgressHUD
import SDWebImage

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var segmentedControl: UISegmentedControl!
    var moviesCollectionView: UICollectionView!
    
    var moviesViewModel: MoviesViewModel!
    var cellViewModelsArray: [MoviesCellViewModel] = [MoviesCellViewModel]()
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        view.backgroundColor = UIColor(named: "background_color")
        moviesViewModel = MoviesViewModel()
        
        segmentedControl = UISegmentedControl(items: [
            NSLocalizedString("segment_popular", comment: ""),
            NSLocalizedString("segment_top_rated", comment: ""),
            NSLocalizedString("segment_on_tv", comment: ""),
            NSLocalizedString("segment_airing_tv", comment: "")
        ])
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlPressed(sender:)), for: UIControl.Event.valueChanged)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        
        moviesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.register(MoviesCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "MoviesCollectionViewCell")
        moviesCollectionView.backgroundColor = UIColor(named: "background_color")
        view.addSubview(moviesCollectionView)
   
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
                
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_settings"), style: UIBarButtonItem.Style.done, target: self, action: #selector(rightBarButtonPressed))
        let favoritesBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_favorites"), style: UIBarButtonItem.Style.done, target: self, action: #selector(favoritesButtonPressd))
        navigationItem.rightBarButtonItems = [rightBarButton, favoritesBarButton]
        
        navigationItem.hidesBackButton = true
        navigationItem.title = NSLocalizedString("movies_title", comment: "")
        
        getMovies(type: MovieType.popular.rawValue)
    }
    
    // MARK: - Actions
    
    @objc func favoritesButtonPressd() {
        let nextStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let favoritosViewController: FavoritosViewController = nextStoryboard.instantiateViewController(withIdentifier: "FavoritosViewController") as!
        FavoritosViewController
        navigationController?.pushViewController(favoritosViewController, animated: true)
    }
    
    @objc func rightBarButtonPressed() {
        showOptionsActionSheet()
    }
    
    func showOptionsActionSheet() {
        let alertController = UIAlertController(title: NSLocalizedString("alert_title", comment: ""), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_profile", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let mystoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController: ProfileViewController = mystoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.present(profileViewController, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_logout", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            let userDefaults = UserDefaults.standard
            userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
            userDefaults.synchronize()
            self.navigationController?.popViewController(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_cancel", comment: ""), style: UIAlertAction.Style.destructive, handler: { action in
            
        }))
        self.present(alertController, animated: true)
    }
    
    func getMovies(type: String) {
        KRProgressHUD.show()
        moviesViewModel.getMovies(type: type) { [weak self] (response: MoviesResponse?, error: String?) in
            guard let self = self else { return }

            KRProgressHUD.dismiss()

            if let _error = error {
                KRProgressHUD.showError(withMessage: _error)
                return
            }
            
            self.cellViewModelsArray.removeAll()
            
            DispatchQueue.main.async {
                let moviesArray = response?.results ?? [Movie]()
                for movie in moviesArray {
                    let cellViewModel = MoviesCellViewModel(movie: movie)
                    self.cellViewModelsArray.append(cellViewModel)
                }
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    @objc func segmentedControlPressed(sender: UISegmentedControl) {
        let currentSegmentIndex = sender.selectedSegmentIndex
        print("currentSegementIndex: \(currentSegmentIndex)")
        switch currentSegmentIndex {
        case 0: // Popular
            getMovies(type: MovieType.popular.rawValue)
        case 1: // Top Rated
            getMovies(type: MovieType.top_rated.rawValue)
        case 2: // On Tv
            getMovies(type: MovieType.upcoming.rawValue)
        case 3: // Airing Todat
            getMovies(type: MovieType.now_playing.rawValue)
        default:
           break
        }
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModelsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movieCellViewModel = cellViewModelsArray[indexPath.row]
        cell.configure(cellViewModel: movieCellViewModel)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieCellViewModel: MoviesCellViewModel = cellViewModelsArray[indexPath.row]
        
        let nextStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailViewController: MovieDetailViewController = nextStoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as!
        MovieDetailViewController
        movieDetailViewController.movieDetailViewModel = MovieDetailViewModel(id: movieCellViewModel.movie.id)
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let midWidth = (moviesCollectionView.frame.width - 10) / 2
        // la division entre 2 es el numero de collections que va a ver y el -5 es el espacio entre los collections
        let miheight = midWidth * 2
        return CGSize(width: midWidth, height: miheight)
    }
}

