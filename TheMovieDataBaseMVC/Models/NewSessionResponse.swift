//
//  NewSessionResponse.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 04/02/23.
//

import Foundation

struct NewSessionResponse: Decodable {
    //Succes200
    let success: Bool?
    let session_id: String?
    //Error 401 y 404
    let status_message: String?
    let status_code: Int?
}
