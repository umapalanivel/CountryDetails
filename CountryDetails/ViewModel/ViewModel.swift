//
//  ViewModel.swift
//  CountryDetails
//
//  Created by uma palanivel on 07/07/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

protocol ViewModelDelegate: class {
    func updateTitle()  // Title update
    
    func didFinishUpdates()// update each row
    
  //  func stopLoadingLoader() // stop loader
}


import UIKit
import Foundation

class ViewModel
{
   
    var dataList : [DataModel]  = [DataModel]()
    weak var delegate: ViewModelDelegate?
    var titleForViewController : String?
    var errorMsg : String?
    var countryDetails = [Rows]()

    func downloadDataFromServer() {
        
        dataList.removeAll()
        guard let url = URL(string: Url.apiURL) else{return}
        let networkProcessor = NetworkProcessor(url: url)
        networkProcessor.downLoadJSONFromURL{(results,error) in
        
            let errorMsg = error?.localizedDescription ?? nil
            self.errorMsg = errorMsg
            self.titleForViewController = results?.title
            self.countryDetails = results?.rows ?? []
            
//            DispatchQueue.global().async {
                self.loadData()
                
 //           }
            
        }
    
    }
    
    func loadData()  {
          
            for values in self.countryDetails  {
                 let titles = values.title ?? "No title available"
              //Loading default description for nil value from json
                 let descriptions = values.description ?? "No Description available"
                 let imageUrl =  values.imageHref ?? "nil"
                        //Place the default image from assets if imageurl not found
                 self.dataList.append(DataModel(imageURL: imageUrl, title: titles, description: descriptions))
                 
            }
                  self.delegate?.didFinishUpdates()
                  self.delegate?.updateTitle()
     }
            
 }
    

