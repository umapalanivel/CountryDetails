//
//  MockDataModel.swift
//  CountryDetailsTests
//
//  Created by uma palanivel on 08/07/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import Foundation

import UIKit


public final class MockDataModel {
    public static let mockJSON: URL = Bundle(for: MockDataModel.self).url(forResource: "SampleAPIResponse", withExtension: "json")!
    public static let imageFileUrl: URL = Bundle(for: MockDataModel.self).url(forResource: "Flag", withExtension: "png")!
}

internal extension URL {
    
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
