//
//  WeatherManager.swift
//  Clima
//
//  Created by JinSeok Yang on 2022/11/03.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func didUpdateWeather(_ waetherManager: WeatherManager, weather: WeatherModel)
    func didDailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherDelegate?
    
    private let apiKey = Bundle.main.apiKey

    lazy var url = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=\(apiKey)"
    
    mutating func fetchLocationWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlStr = "\(self.url)&lat=\(lat)&lon=\(lon)"
        self.performRequest(urlStr)
    }
    

    mutating func fetchWeather(cityName: String) {
        let urlStr = "\(self.url)&q=\(cityName)"
        self.performRequest(urlStr)
    }
    
    func performRequest(_ urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                delegate?.didDailWithError(error: error!)
                print("Error: URL")
            }
            guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                return
            }
            guard let safeData = data else {
                print("Faild get data")
                return
            }
            if let weather = self.parseJSON(safeData) {
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
            
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didDailWithError(error: error)
            return nil
        }
    }
    
   
}
