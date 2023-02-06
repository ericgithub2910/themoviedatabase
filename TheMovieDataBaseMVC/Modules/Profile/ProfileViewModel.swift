//
//  ProfileViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 05/02/23.
//

import UIKit

class ProfileViewModel: NSObject {
    
    func getUserName() -> String {
        let username: String = UserDefaults.standard.string(forKey: Constants.username) ?? ""
        return "@\(username)"
    }
}
