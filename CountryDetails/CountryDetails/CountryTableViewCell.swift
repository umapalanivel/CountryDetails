//
//  CountryTableViewCell.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

       var photo = CustomUIImageView()
       var titleLabel = UILabel()
       var descriptionLabel = UITextView()
       
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(photo)
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            configurePhotoView()
            configureLableView()
            configureDescriptionView()
            setConstranitsForPhotoImage()
            setConstraintsForTitle()
            setConstranitsForDescription()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not implemented")
        }
        
        func loadCell(details:Rows){
            //photo.image = image.photoImage
            photo.load(urlString: details.imageHref ?? "No Image")
            titleLabel.text = details.title
            descriptionLabel.text = details.description
            
        }
        
        func configurePhotoView(){
            photo.layer.cornerRadius = 10
            photo.clipsToBounds = true
           // photo.load(urlString: url)
        }
        
        func configureDescriptionView(){
    //        photo.layer.cornerRadius = 10
    //        photo.clipsToBounds = true
        }
        
        func configureLableView(){
           titleLabel.numberOfLines = 0
           titleLabel.adjustsFontSizeToFitWidth = true
        }
        
        func setConstranitsForPhotoImage(){
            photo.translatesAutoresizingMaskIntoConstraints                                       = false
            photo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                       = true
            photo.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 12).isActive          = true
            photo.heightAnchor.constraint(equalToConstant: 60).isActive                           = true
            photo.widthAnchor.constraint(equalTo: photo.heightAnchor,multiplier: 10/9).isActive   = true
        }
        
        func setConstraintsForTitle() {
            
            titleLabel.translatesAutoresizingMaskIntoConstraints                                       = false
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor,constant:-30).isActive                       = true
            
            titleLabel.leadingAnchor.constraint(equalTo: photo.trailingAnchor,constant: 20).isActive   = true
            titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive                           = true
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12).isActive       = true
            
        }
        
        func setConstranitsForDescription(){
            descriptionLabel.translatesAutoresizingMaskIntoConstraints                                       = false
        
            descriptionLabel.leadingAnchor.constraint(equalTo: photo.trailingAnchor,constant: 20).isActive   = true
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.centerYAnchor,constant:10).isActive = true
            descriptionLabel.heightAnchor.constraint(equalToConstant: 200).isActive                           = true
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -12).isActive       = true
        }

}
