//
//  WeatherData.swift
//  Clima
//
//  Created by JinSeok Yang on 2022/11/03.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [WeatherInfo]
}

struct Main: Codable {
    let temp: Double
}

struct WeatherInfo: Codable {
    let id: Int
}
