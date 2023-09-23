//
//  ClimateWorker.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 22/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ClimateWorkerLogic {
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping(WeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
    func getWeatherByCity(q: String, onSuccess: @escaping(WeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
}

class ClimateWorker: ClimateWorkerLogic {
    func getUnits() -> String {
        let isClesius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: true)
        if isClesius {
            return "metric"
        } else {
            return "imperial"
        }
    }
    
    func getCurrentWeather(lat: String, lon: String, onSuccess: @escaping (WeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getCurrentWeather(lat: lat, lon: lon, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(WeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
    
    func getWeatherByCity(q: String, onSuccess: @escaping (WeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getWeatherByCity(q: q, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(WeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
}
