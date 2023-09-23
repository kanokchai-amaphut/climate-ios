//
//  ForecastWorker.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//

protocol ForecastWorkerLogic {
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping(ForecastWeatherModel) -> Void, onError: @escaping(CustomError) -> Void)
}


class ForecastWorker: ForecastWorkerLogic {
    
    func getUnits() -> String {
        let isClesius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: true)
        if isClesius {
            return "metric"
        } else {
            return "imperial"
        }
    }
    
    func getForecastWeather(lat: String, lon: String, onSuccess: @escaping (ForecastWeatherModel) -> Void, onError: @escaping (CustomError) -> Void) {
        let units: String = self.getUnits()
        APIClient.shared.request(api: .getForecastWeather(lat: lat, lon: lon, appId: AppConfig.apiKey, units: units)) { json in
            if let jsonData: [String: Any] = json.rawValue as? [String: Any] {
                onSuccess(ForecastWeatherModel(from: jsonData))
            } else {
                onError(CustomError.invalidJSON)
            }
        } onError: { error in
            onError(error)
        }
    }
}
