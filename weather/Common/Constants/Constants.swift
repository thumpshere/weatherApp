//
//  Constants.swift
//  weather
//
//  Created by Arpit on 08/05/21.
//

import Foundation
import UIKit


struct Constants {
  static let emptyCachedDataNotificationKey = "emptyCachedData"
  static let cachedObjectKey = "CachedObject"
  static let cachedFavoritesObjectKey = "favoritesObject"
  static let dataStoreId =  "apiData"
  static let dataEmptyFromServer =  "emptyDataFromServer"
  static let appToken = "58d09635fa695377b40b52e9655ee494"
  static let dataTypeMetric = "metric"
  static let degreeCelsius = "°C"
  static let imageExtension = "@2x.png"
  static let symbolPercent = "%"
  static let symbolHpa = "hPa"
  
}

struct ScreenDimensions {
  static let screenWidth = UIScreen.main.bounds.width
  static let screenHeight = UIScreen.main.bounds.height
}

struct ParameterKeys {
  static let keyToken = "appid"
  static let keyLimit = "limit"
  static let keyAmpersand = "&"
  static let keyUnits = "units"
  static let keyEquals = "="
}

struct UserDefaultKeys {
  static let city = "city"
  static let favorites = "fav"
  
}

struct BaseURLs {
  static let url = "http://api.openweathermap.org/"
  static let Imagesurl = "http://openweathermap.org/"
}

struct PathURLs {
  static let weatherDataPath = "data/2.5/weather?q="
  static let citySearchPath = "geo/1.0/direct?q="
  static let imagePath = "img/wn/"
}

struct CellIdentifiers {
  static let resultCell = "resultCell"
}

struct UIViewConstants {
  static let scrollContentSize: CGFloat = 750.0
  
}
