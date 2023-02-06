//
//  MoviesViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import UIKit

class MoviesViewModel: NSObject {

    // MARK: API

    func getMovies(type: String, completion: @escaping (MoviesResponse?, String?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(type)?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
        print("url: \(urlString)")
        guard let _url = url else {
            print("Invalid URL")
            completion(nil, "URL Invalida")
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
                    let moviesResponse: MoviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: _data)
                    completion(moviesResponse, nil)
                } catch let errorCatch {
                    print(errorCatch)
                    completion(nil, errorCatch.localizedDescription)
                }
            } else {
                completion(nil, "Error en la respuesta de películas")
            }
        }
        dataTask.resume()
    }
}
