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
       var descriptionLabel = UITextView()
    
       var data : DataModel? {
             didSet {
                photo.image = data?.photoImage
                titleLabel.text = data?.title
                descriptionLabel.text = data?.description
             }
         }
    
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(photo)
            addSubview(titleLabel)
            addSubview(descriptionLabel)
            configurePhotoView()
            configureLableView()
            configureDescriptionView()
            setConstraints()

        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not implemented")
        }
        
        
        func configurePhotoView(){
            photo.layer.cornerRadius = 10
            photo.clipsToBounds = true
        }
        
        func configureDescriptionView(){
             descriptionLabel.textColor = .black
             descriptionLabel.font = UIFont.systemFont(ofSize: 12)
             descriptionLabel.textAlignment = .justified
        }
        
        func configureLableView(){
           titleLabel.numberOfLines = 0
           titleLabel.adjustsFontSizeToFitWidth = true
        }
        
        func setConstraints() {
            
            photo.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 120, height: 120, enableInsets: false)
             titleLabel.anchor(top: topAnchor, left: photo.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
            descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: photo.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 1.5 , height: 80, enableInsets: false)
        }


}
