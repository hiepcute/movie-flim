//
//  TitleTableViewCell.swift
//  MovieFlim
//
//  Created by MACBOOK on 16/08/2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier: String  = "TitleTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    private let titlePosterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds  = true
        return imageView
        
    }()
    private let playTitleButton: UIButton = {
        let titleButton = UIButton()
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        titleButton.setImage(image, for: .normal)
        titleButton.tintColor = .black
        return titleButton
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyContrains()
        
    }
    private func applyContrains() {
        let titlePosterImageConstrains = [
            titlePosterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            titlePosterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            titlePosterImage.widthAnchor.constraint(equalToConstant: 100)]
        
       
            
        let titleLableConstrains = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterImage.trailingAnchor,constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let playTitleConstrains = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterImageConstrains)
        NSLayoutConstraint.activate(titleLableConstrains)
        NSLayoutConstraint.activate(playTitleConstrains)
            
    }
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {  return }
        titlePosterImage.sd_setImage(with: url)
        titleLabel.text = model.titleName
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   

}
