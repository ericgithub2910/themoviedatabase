//
//  ViewController.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {

    var stackView: UIStackView!
    var logoImageView: UIImageView!
    var userTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    
    var loginViewModel: LoginViewModel!
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        
        // icon_tmdb
        loadViews()
        
        userTextField.text = "Eric_2910"
        passwordTextField.text = "Qwerty2910"
        print("HomeDirectory: \(NSHomeDirectory())")
    }
    
    func loadViews() {
        view.backgroundColor = UIColor(named: "background_color")
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 20
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
        
        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "icon_tmdb")
        logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
        stackView.addArrangedSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            logoImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            logoImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        userTextField = UITextField()
        userTextField.borderStyle = UITextField.BorderStyle.roundedRect
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.placeholder = "User"
        stackView.addArrangedSubview(userTextField)
        
        NSLayoutConstraint.activate([
            userTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            userTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            userTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        passwordTextField = UITextField()
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        stackView.addArrangedSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            passwordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        loginButton = UIButton(configuration: UIButton.Configuration.filled())
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: UIControl.State.normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: UIControl.Event.touchUpInside)
        stackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            loginButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            loginButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loginViewModel.hasSessionActive() {
            let moviesViewController: MoviesViewController = MoviesViewController()
            self.navigationController?.pushViewController(moviesViewController, animated: true)
        }
    }
    
    // MARK: - Actions

    @objc func loginButtonPressed() {
        let user: String = userTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        if user.isEmpty || password.isEmpty {
            KRProgressHUD.showError(withMessage: NSLocalizedString("user_password_error", comment: ""))
        } else {
            getNewToken(user: user, password: password)
        }
    }
    
    // MARK: - API Calls
    func getNewToken(user: String, password: String) {
        KRProgressHUD.show()
        loginViewModel.getNewToken { [weak self] (response: NewTokenResponse?, error: String?) in
            guard let self = self else { return }
            
            if let _error = error {
                KRProgressHUD.dismiss()
                KRProgressHUD.showError(withMessage: _error)
                return
            }
            
            let request_token: String = response?.request_token ?? ""
            self.login(user: user, password: password, request_token: request_token)
        }
    }
    
    func login(user: String, password: String, request_token: String) {
        loginViewModel.login(user: user, password: password, request_token: request_token) { [weak self] (response: NewTokenResponse?, error: String?) in
            
            guard let self = self else { return }
                                                    
            if let _error = error {
                KRProgressHUD.dismiss()
                KRProgressHUD.showError(withMessage: _error)
                return
            }
                                    
            let request_token: String = response?.request_token ?? ""
            self.getSession(request_token: request_token)
        }
    }
    
    func getSession(request_token: String) {
        loginViewModel.getSession(request_token: request_token) { [weak self] (response: NewSessionResponse?, error: String?) in
            guard let self = self else { return }

            KRProgressHUD.dismiss()

            if let _error = error {
                KRProgressHUD.showError(withMessage: _error)
                return
            }
    
            DispatchQueue.main.async {
                let moviesViewController: MoviesViewController = MoviesViewController()
                self.navigationController?.pushViewController(moviesViewController, animated: true)
            }
        }
    }
}
