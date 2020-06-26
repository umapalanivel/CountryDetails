//
//  CustomUIImageView.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import UIKit

var imageCache = NSCache<AnyObject,AnyObject>()

class CustomUIImageView: UIImageView {
   func load(urlString: String) {
       if let image = imageCache.object(forKey: urlString as NSString) as? UIImage{
           self.image = image
           return
       }
       guard let url = URL(string: urlString) else {return}
       DispatchQueue.global().async { [weak self] in
           if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                      self?.image = image
                    }
                 }
            }
       }
   }
}
