//
//  ApiManager.swift
//  weather
//
//  Created by Arpit on 09/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol APIManagerProtocol {
  func fetchWeatherData (city:String, success successBlock: @escaping ((weatherData) -> Void), failure failureBlock: @escaping ((AnyObject) -> Void))
    func fetchCities (city:String, success successBlock: @escaping (([CityData]) -> Void), failure failureBlock: @escaping ((AnyObject) -> Void))
}

class ApiManager: APIManagerProtocol {
  
    let storage = StorageHelper()
  func fetchWeatherData (city:String, success successBlock: @escaping ((weatherData) -> Void), failure failureBlock: @escaping ((AnyObject) -> Void)) {
    if !WeatherHelper.isConnectedToInternet() {
      return failureBlock(AppStrings.noInternet as AnyObject)
    }
   
    let requestURL = BaseURLs.url + PathURLs.weatherDataPath   + city + "&" + ParameterKeys.keyToken + "="  + Constants.appToken + "&" + ParameterKeys.keyUnits + "=" + Constants.dataTypeMetric
    
     AF.request(requestURL).validate().responseString { response in
         switch response.result {
             case .success(let value):
                 
                self.storage.saveDataToCache(data: value, keyString: Constants.cachedObjectKey)
                 var dataFromString = Data()
                 var json = JSON()
             
                     dataFromString =  value.data(using: .utf8, allowLossyConversion:false) ?? Data()
               
                 do{
                 json = try JSON(data: dataFromString)
                 }catch {
                    return failureBlock(Error.self as AnyObject)
                 }
                let weatherInfo = weatherData.init(fromJson: json)
             return successBlock(weatherInfo)
             
            
             case .failure(let error):
                return failureBlock(error.localizedDescription as AnyObject)
             }
     }

  }
    
    
    
    func fetchCities (city:String, success successBlock: @escaping (([CityData]) -> Void), failure failureBlock: @escaping ((AnyObject) -> Void)) {
      if !WeatherHelper.isConnectedToInternet() {
        return failureBlock(AppStrings.noInternet as AnyObject)
      }
     
        let apiUrl = BaseURLs.url + PathURLs.citySearchPath  + city + ParameterKeys.keyAmpersand + ParameterKeys.keyToken + ParameterKeys.keyEquals + Constants.appToken
        
        AF.request(apiUrl).validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value).arrayValue
                    //print("JSON: \(json)")
                    var cities = [CityData]()
                    for object in json {
                        let cityInfo = CityData.init(fromJson: object)
                        cities.append(cityInfo)
                    }
                    return successBlock(cities)
                   
                case .failure(let error):
                    if error.responseCode == 404 {
                        return failureBlock("City Not found" as AnyObject)
                    }
                    print(error)
                }
        }
    }
  
}
