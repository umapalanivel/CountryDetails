//
//  CountryTableViewCell.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    var photo = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    let stackkView = UIStackView()
    var data : DataModel? {
        didSet {
           if let imageUrl = data?.imageURL{
               photo.load(urlString: imageUrl)
           }else{
            photo.image = UIImage(named: "NoImage")
           }
        titleLabel.text = data?.title
        descriptionLabel.text = data?.description
      
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    layer.borderWidth = 1
    layer.cornerRadius = 3
    layer.borderColor = UIColor.clear.cgColor
    layer.masksToBounds = true
    configurePhotoView()
    configureLableView()
    configureDescriptionView()
    configureStackView()
    self.contentView.addSubview(photo)
    stackkView.addArrangedSubview(titleLabel)
    stackkView.addArrangedSubview(descriptionLabel)
    self.contentView.addSubview(stackkView)
    setNewConstraints()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not implemented")
  }
  
  
  func configurePhotoView(){
    photo.translatesAutoresizingMaskIntoConstraints = false
    photo.contentMode = .scaleAspectFit
    photo.clipsToBounds = true
  }
  
  func configureDescriptionView(){
    descriptionLabel.font = UIFont.systemFont(ofSize: 14)
    descriptionLabel.textColor = .black
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.textAlignment = .justified
  }
  
  func configureLableView(){
    titleLabel.font = UIFont.systemFont(ofSize: 18)
    titleLabel.textColor = UIColor(red: 35.0/255.0, green: 70.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byWordWrapping
  }
  
  func configureStackView(){
    stackkView.axis = .vertical
    stackkView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setNewConstraints () {
    photo.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
    photo.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor, constant: 5).isActive = true
    photo.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    photo.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
    photo.heightAnchor.constraint(lessThanOrEqualToConstant: 70.0).isActive = true
    stackkView.topAnchor.constraint(equalTo: photo.topAnchor, constant: -3).isActive = true
    stackkView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
    stackkView.leadingAnchor.constraint(equalTo: self.photo.trailingAnchor, constant: 10).isActive = true
    stackkView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
    
    titleLabel.widthAnchor.constraint(equalTo: self.stackkView.widthAnchor, multiplier: 0).isActive = true
    descriptionLabel.widthAnchor.constraint(equalTo: self.stackkView.widthAnchor, multiplier: 0).isActive = true
  }
  
}
