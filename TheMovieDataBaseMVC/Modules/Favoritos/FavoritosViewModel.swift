//
//  FavoritosViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit
import CoreData

class FavoritosViewModel: NSObject {

    func getFavorites() -> [FavoritoCellViewModel] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var favoritosCellViewModels = [FavoritoCellViewModel]()
                
        let fetchRequest = NSFetchRequest<Favoritos>(entityName: "Favoritos")
        do {
            let results: [Favoritos] = try context.fetch(fetchRequest)
            for result in results {
                let movie = Movie(id: Int(result.id),
                                  original_title: result.original_title ?? "",
                                  overview: result.overview ?? "",
                                  poster_path: result.poster_path ?? "",
                                  release_date: result.release_date ?? "",
                                  title: result.title ?? "",
                                  vote_average: result.vote_average)
                let favoritoViewModel: FavoritoCellViewModel = FavoritoCellViewModel(movie: movie)
                favoritosCellViewModels.append(favoritoViewModel)
            }
        } catch let catchError {
            
        }
        return favoritosCellViewModels
    }
}
