//
//  Bundle.swift
//  WeatherApp
//
//  Created by JINSEOK on 2022/11/14.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_Key' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}
