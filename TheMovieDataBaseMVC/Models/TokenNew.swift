//
//  TokenNew.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import Foundation

struct NewTokenResponse: Decodable {
   
    let success: Bool
    let expires_at: String?
    let request_token: String?
    let status_code: Int?
    let status_message: String?
    
}
