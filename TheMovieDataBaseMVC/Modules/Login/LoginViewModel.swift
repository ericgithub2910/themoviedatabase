//
//  LoginViewModel.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import Foundation

class LoginViewModel {
    
    // MARK: Session
    
    func hasSessionActive() -> Bool {
        let session_id: String = UserDefaults.standard.string(forKey: Constants.session_id) ?? ""
        if session_id.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    // MARK: API
    
    func getNewToken(completion: @escaping (NewTokenResponse?, String?) -> Void) {
        let urlString = Constants.apiURL + "/authentication/token/new?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)

        guard let _url = url else {
            print("URL invalida")
            completion(nil, "URL Inválida")
            return
        }
                        
        var request: URLRequest = URLRequest(url: _url)
        request.httpMethod = "GET"
                        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request) { data, response, error in
            if let _error = error {
                print("error: \(_error.localizedDescription)")
                completion(nil, _error.localizedDescription)
                return
            }
                            
            if let _data = data {
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("jsonString: \(jsonString ?? "")")
                do {
                    let newTokenResponse: NewTokenResponse = try JSONDecoder().decode(NewTokenResponse.self, from: _data)
                    if newTokenResponse.success == true {
                        let request_token = newTokenResponse.request_token ?? ""
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(request_token, forKey: Constants.request_token)
                        userDefaults.synchronize()
                        completion(newTokenResponse, nil)
                    } else {
                        completion(nil, newTokenResponse.status_message ?? "")
                    }
                } catch let catchError {
                    print("catchError: \(catchError)")
                    completion(nil, catchError.localizedDescription)
                }
            } else {
                completion(nil, "Error en la respuesta de la autenticación")
            }
        }
        dataTask.resume()
    }
    
    func login(user: String, password: String, request_token: String, completion: @escaping (NewTokenResponse?, String?) -> Void) {
        let urlString = Constants.apiURL + "/authentication/token/validate_with_login?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
        
        guard let _url = url else {
            print("Url Invalida o Token Invalido")
            return
        }
        
        var request : URLRequest = URLRequest(url: _url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parametros = NSMutableDictionary()
            parametros.setValue(user, forKey: Constants.username)
            parametros.setValue(password, forKey: Constants.password)
            parametros.setValue(request_token, forKey: Constants.request_token) // Aqui tenias hardcodeados valores
            
            let postData: Data = try JSONSerialization.data(withJSONObject: parametros, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = postData
        } catch let catchError {
            completion(nil, catchError.localizedDescription)
            return
        }
    
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request) { data, response, error in
                    
            if let _error = error {
                completion(nil, _error.localizedDescription)
                return
            }
                    
            if let _data = data {
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("jsonString: \(jsonString ?? "")")
                do {
                    let loginResponse : NewTokenResponse = try JSONDecoder().decode(NewTokenResponse.self, from: _data)
                    if loginResponse.success {
                        let login_request_token = loginResponse.request_token ?? ""
                        let userDefaults = UserDefaults.standard
                        userDefaults.setValue(login_request_token, forKey: Constants.request_token)
                        userDefaults.setValue(user, forKey: Constants.username)
                        userDefaults.synchronize()
                        completion(loginResponse, nil)
                    } else {
                        completion(nil, "Error en la autenticación")
                    }
                } catch let catchError {
                    completion(nil, catchError.localizedDescription)
                }
            } else {
                completion(nil, "Error en la respuesta de la autenticación")
            }
        }
        dataTask.resume()
    }
    
    func getSession(request_token: String, completion: @escaping (NewSessionResponse?, String?) -> Void) {
          
        let urlString = Constants.apiURL + "/authentication/session/new?api_key=\(Constants.api_key)"
        let url: URL? = URL(string: urlString)
          
        guard let _url = url else {
            completion(nil, "URL Inválida")
            return
        }
          
        var request:  URLRequest = URLRequest(url: _url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let parametros = NSMutableDictionary()
            parametros.setValue(request_token, forKey: "request_token")
              
            let postData: Data = try JSONSerialization.data(withJSONObject: parametros, options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = postData
              
        } catch let catchError {
            completion(nil, catchError.localizedDescription)
            return
        }
          
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request) { data, response, error in
           
            if let _error = error {
                print("error: \(_error.localizedDescription)")
                completion(nil, _error.localizedDescription)
                return
            }
              
            if let _data = data {
                let jsonString: String? = String(data: _data, encoding: String.Encoding.utf8)
                print("jsonString: \(jsonString ?? "")")
                  
                do {
                    let newSessionResponse: NewSessionResponse = try JSONDecoder().decode(NewSessionResponse.self, from: _data)
                    if newSessionResponse.success == true {
                        let session_id = newSessionResponse.session_id ?? ""
                        // Guardamos el session id
                        let userDefault = UserDefaults.standard
                        userDefault.setValue(session_id, forKey: Constants.session_id)
                        userDefault.synchronize()
                        completion(newSessionResponse, nil)
                    }
                } catch let catchError {
                    completion(nil, catchError.localizedDescription)
                }
            } else {
                completion(nil, "Error en la respuesta de la autenticación")
            }
        }
        dataTask.resume()
    }
}

