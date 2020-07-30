//
//  UIImageView+Extensions.swift
//  CountryDetails
//
//  Created by uma palanivel on 07/07/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject,AnyObject>()
private var task: URLSessionDataTask?
extension UIImageView{
func load(urlString: String) {
    guard let imageUrl = URL(string: urlString) else {
      image = nil
      return
      }
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      DispatchQueue.main.async {
        self.image = cachedImage
      }
      return
      }
    /* Downloading images on backgrnd thread*/
    URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
        guard let data = data,
          let image = UIImage(data: data),
          error == nil else{
            DispatchQueue.main.async {
              self.image = UIImage(named: "NoImage")
            }
            return
        }
        DispatchQueue.main.async {
          imageCache.setObject(image, forKey: urlString as NSString)
          self.image = image
        }
      }.resume()
   }
}
