//
//  MoviesDetailViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import UIKit
import KRProgressHUD
import SDWebImage

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var moviesDetailCollectionView: UICollectionView!
    
    var moviesCellViewModelsArray: [MoviesCellViewModel] = [MoviesCellViewModel]()
    
    @IBOutlet weak var userLabel: UILabel!
    
    var profileViewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        moviesDetailCollectionView.dataSource = self
        moviesDetailCollectionView.delegate = self
                
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        moviesDetailCollectionView.collectionViewLayout = flowLayout

        userLabel.text = profileViewModel.getUserName()
        getPopularMovies()
    }
    
    func getPopularMovies() {
        
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
        guard let _url = url else {
            print("Invalid URL")
            KRProgressHUD.showError(withMessage: "URL Invalida")
            return
        }
        
        KRProgressHUD.show()
        var request: URLRequest = URLRequest(url: _url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            
            if let _error = error {
                print("error \(_error.localizedDescription)")
                KRProgressHUD.showError(withMessage: _error.localizedDescription)
                return
            }
            
            if let _data = data {
                KRProgressHUD.dismiss()
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("Response  \(jsonString ?? "")")
                
                do {
                    let moviesResponse: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: _data)
                    
                    let moviesArray = moviesResponse.results ?? [Movie]()
                    for movie in moviesArray {
                        let cellViewModel = MoviesCellViewModel(movie: movie)
                        self.moviesCellViewModelsArray.append(cellViewModel)
                    }
                    
                    DispatchQueue.main.async {
                        self.moviesDetailCollectionView.reloadData()
                    }

                } catch let errorCatch {
                    print(errorCatch)
                    KRProgressHUD.showError(withMessage: errorCatch.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
    
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesCellViewModelsArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        let cellViewModel: MoviesCellViewModel = moviesCellViewModelsArray[indexPath.row]
        cell.configure(cellViewModel: cellViewModel)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let midWidth = (moviesDetailCollectionView.frame.width - 10) / 2
        // la division entre 2 es el numero de collections que va a ver y el -5 es el espacio entre los collections
        let miheight = midWidth * 2
        return CGSize(width: midWidth, height: miheight)
    }
    
}
