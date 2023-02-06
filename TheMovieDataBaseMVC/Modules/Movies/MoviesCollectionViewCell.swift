//
//  MoviesCollectionViewCell.swift
//  TheMovieDataBaseMVC
//
//  Created by EricSH on 02/02/23.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    var stackView: UIStackView!
    var movieImageView: UIImageView!
    var movieTitleLabel: UILabel!
    var movieDateLabel: UILabel!
    var movieTextLabel: UILabel!
    var movieRateLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "background_color")
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 5
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        movieImageView = UIImageView()
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        movieImageView.contentMode = UIView.ContentMode.scaleAspectFill
        movieImageView.clipsToBounds = true
        stackView.addArrangedSubview(movieImageView)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            movieImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            movieImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        movieTitleLabel = UILabel()
        movieTitleLabel.textColor = UIColor.white
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        stackView.addArrangedSubview(movieTitleLabel)
        
        NSLayoutConstraint.activate([
            movieTitleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            movieTitleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
        ])        
        
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.spacing = 10
        stackView.addArrangedSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        movieDateLabel = UILabel()
        movieDateLabel.textColor = UIColor.white
        movieDateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieDateLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        horizontalStackView.addArrangedSubview(movieDateLabel)
        
        movieRateLabel = UILabel()
        movieRateLabel.textColor = UIColor.white
        movieRateLabel.translatesAutoresizingMaskIntoConstraints = false
        movieRateLabel.textAlignment = NSTextAlignment.right
        movieRateLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        horizontalStackView.addArrangedSubview(movieRateLabel)
        
        movieTextLabel = UILabel()
        movieTextLabel.textColor = UIColor.white
        movieTextLabel.translatesAutoresizingMaskIntoConstraints = false
        movieTextLabel.numberOfLines = 4
        movieTextLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        stackView.addArrangedSubview(movieTextLabel)
        
        NSLayoutConstraint.activate([
            movieTextLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            movieTextLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cellViewModel: MoviesCellViewModel) {
        movieImageView.sd_setImage(with: cellViewModel.getPosterPathURL())
        movieImageView.layer.cornerRadius = 10 //  Le damos la forma redondeada a el movieImageView
        movieTitleLabel.text = "\(cellViewModel.movie.original_title)"
        movieDateLabel.text =  "\(cellViewModel.movie.release_date)"
        movieTextLabel.text = "\(cellViewModel.movie.overview)"
        movieRateLabel.text = "★\(cellViewModel.movie.vote_average)"
    }
}
