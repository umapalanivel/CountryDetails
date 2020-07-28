//
//  CountryModel.swift
//  CountryDetails
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation
import UIKit

struct DataModel {
    var imageURL :String?
    var title    :String
    var description :String
}

struct WebDetails:Codable {
   let title :String
   let rows : [Rows]?
}

struct Rows:Codable {
    let title:String?
    let description:String?
    let imageHref :String?
}

struct Url {
   static let apiURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}
