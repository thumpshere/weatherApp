//
//  weatherViewModel.swift
//  weather
//
//  Created by Arpit on 09/05/21.
//

import UIKit
import Alamofire
import Cache
import SwiftyJSON

class weatherViewModel: NSObject {
  var apiRequestManager: APIManagerProtocol = ApiManager()
  var dataEmpty:(() -> Void)?
  var dataLoadingSuccess:(() -> Void)?
  var cityRequestSuccess:(() -> Void)?
  var cityRequestError:(() -> Void)?
  var dataLoadingError:(() -> Void)?
  var dataFetchFromCacheSuccess:(() -> Void)?
  var Cities = [CityData]()
  let storage = StorageHelper()
  var weatherModel:weatherData?
  
  // MARK:Local Data Storage METHODS
  func getDatafromStorage() {
    let jsonString = self.storage.getDataFromCache(keyString: Constants.cachedObjectKey)
    var dataFromString = Data()
    var json = JSON()
    dataFromString =  jsonString.data(using: .utf8, allowLossyConversion:false) ?? Data()
    do{
      json = try JSON(data: dataFromString)
    }catch {
      self.dataEmpty?()
      return
    }
    self.weatherModel = weatherData.init(fromJson: json)
    self.dataFetchFromCacheSuccess?()
  }

  
  func saveFavoritesToUserDefaults(city:String,shouldAppend:Bool,favoritesArray:[String]) {
    var favorites = favoritesArray
    if (shouldAppend && !favorites.contains(city)){
      favorites.append(city)
    }else if (!shouldAppend)  {
      let fav = favorites.filter { $0 != city }
      favorites = fav
    }
    WeatherHelper.saveCityObjecttoUserDefaults(value: favorites, key: UserDefaultKeys.favorites)
  }
  
  // MARK:API call METHODS
  func callWeatherDataAPI(city:String){
    var requestedCity:String = ""
    if city == "" {
      requestedCity = WeatherHelper.getDataFromUserDefaults(key: UserDefaultKeys.city)
    }else {
      requestedCity = city
    }
    
    apiRequestManager.fetchWeatherData(city: requestedCity) { (WeatherInfo) in
      self.weatherModel = WeatherInfo
      self.dataLoadingSuccess?()
    } failure: { (error) in
      self.dataLoadingError?()
    }
  }
  
  func callCitySearchAPI(city:String){
    apiRequestManager.fetchCities(city: city) { (citiesArray) in
      self.Cities = citiesArray
      self.cityRequestSuccess?()
    } failure: { (error) in
      if let errorString = error as? String {
        print(errorString)
        self.cityRequestError?()
      }
    }
  }
  
}
