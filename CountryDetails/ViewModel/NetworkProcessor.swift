//
//  NetworkProcessor.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

class NetworkProcessor {
    
    lazy var configuration : URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session : URLSession = URLSession(configuration: self.configuration)
    
    let url : URL
    
    init(url:URL) {
        self.url = url
    }
    
    typealias jsonDictionaryHandler = ((WebDetails?,Error?) -> Void)
    
    /* NetworkRequest to download data from api */
    func downLoadJSONFromURL(completion: @escaping jsonDictionaryHandler){
        
        let request = URLRequest(url: self.url)
        
        let dataTask = session.dataTask(with: request) { (data,response,error) in
            
            if error == nil {
                guard let data = data else { return }
                guard let string = String(data: data, encoding: String.Encoding.isoLatin1) else { return }
                guard let properData = string.data(using: .utf8, allowLossyConversion: true) else { return }
                do{
                  let values = try JSONDecoder().decode(WebDetails.self, from: properData)
                    completion(values, nil)
                } catch let error {
                completion(nil, error)
                }
            } else {
               completion(nil, error)
            }
        }
        dataTask.resume()
    }
}
