//
//  MovieDetailViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit
import CoreData

class MovieDetailViewModel: NSObject {

    var id: Int
    var movieResponse: MovieResponse? = nil
    
    init(id: Int) {
        self.id = id
    }
    
    // MARK: API
    
    func getMovieDetail(completion: @escaping (MovieResponse?, String?) -> Void) {
        let urlString = Constants.apiURL + "/movie/\(id)?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
        guard let _url = url else {
            print("Invalid URL")
            completion(nil, "URL Inválida")
            return
        }
        
        var request: URLRequest = URLRequest(url: _url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let _error = error {
                print("error \(_error.localizedDescription)")
                completion(nil, _error.localizedDescription)
                return
            }
            
            if let _data = data {
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("Response  \(jsonString ?? "")")
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: _data)
                    self.movieResponse = movieResponse
                    completion(movieResponse, nil)
                } catch let errorCatch {
                    print(errorCatch)
                    completion(nil, errorCatch.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
    
    func getMovieVideos(completion: @escaping (MovieVideosResponse?, String?) -> Void) {
        let urlString = Constants.apiURL + "/movie/\(id)/videos?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
        guard let _url = url else {
            print("URL Inválida")
            completion(nil, "URL Inválida")
            return
        }
        
        var request: URLRequest = URLRequest(url: _url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let _error = error {
                print("error \(_error.localizedDescription)")
                completion(nil, _error.localizedDescription)
                return
            }
            
            if let _data = data {
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("Response  \(jsonString ?? "")")
                do {
                    let movieVideosResponse = try JSONDecoder().decode(MovieVideosResponse.self, from: _data)
                    completion(movieVideosResponse, nil)
                } catch let errorCatch {
                    print(errorCatch)
                    completion(nil, errorCatch.localizedDescription)
                }
            } else {
                completion(nil, "Error al consultar los videos")
            }
        }
        dataTask.resume()
    }
    
    // MARK: - CoreData
    
    func addFavorite() {
        guard let movieResponse = movieResponse else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let favorite = Favoritos(context: context)
        favorite.id = Int64(movieResponse.id)
        favorite.title = movieResponse.title
        favorite.overview = movieResponse.overview
        favorite.poster_path = movieResponse.poster_path
        favorite.vote_average = movieResponse.vote_average
        favorite.release_date = movieResponse.release_date
        favorite.original_title = movieResponse.original_title
        favorite.tagline = movieResponse.tagLine
        
        do {
            try context.save()
        } catch {   }
    }
    
    func deleteFavorite() {
        guard let movieResponse = movieResponse else { return }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Favoritos>(entityName: "Favoritos")
        fetchRequest.predicate = NSPredicate(format: "id = %i", movieResponse.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty == false {
                let firstResult = results[0]
                context.delete(firstResult)
            }
        } catch {   }
    }
    
    func existFavorite() -> Bool {
        guard let movieResponse = movieResponse else { return false }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Favoritos>(entityName: "Favoritos")
        fetchRequest.predicate = NSPredicate(format: "id = %i", movieResponse.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            return false
        }
    }
}
