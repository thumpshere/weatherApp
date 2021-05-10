//
//  WeatherHelper.swift
//  weather
//
//  Created by Arpit on 09/05/21.
//

import UIKit
import Alamofire

class WeatherHelper: NSObject {
    
  class func showAlert (title: String, message: String, success successBlock: @escaping (() -> Void)) {

    let AppWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    guard let window = AppWindow else { return }
    // show the alert
    window.rootViewController?.present(alert, animated: true, completion: {
      successBlock()
    })
  }
  
  class func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()!.isReachable
  }
    
    
    class func getDateString(timestamp:Double) -> String{
        let date = Date(timeIntervalSince1970: timestamp)
           let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
           dateFormatter.timeZone = .current
           let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    class func getTimeString(timestamp:Int) -> String{
        let date = Date(timeIntervalSince1970: Double(timestamp))
           let dateFormatter = DateFormatter()
           dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
           dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
           dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "hh:mm a"
           let localDate = dateFormatter.string(from: date)
        return localDate

    }
    
    class func savetoUserDefaults(value:String, key:String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    class func getDataFromUserDefaults(key:String) -> String {
        return  UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    
    class func saveCityObjecttoUserDefaults(value:[String], key:String){
        let userDefaults = UserDefaults.standard
            userDefaults.set(value, forKey: key)
            userDefaults.synchronize()

    }
    
    class func getCityDataFromUserDefaults(key:String) -> [String] {
        let userDefaults = UserDefaults.standard
       
   
            if  let decodedCities = userDefaults.object(forKey: key) as? [String] {
            return decodedCities
  
        }
        
      
        return []
    }
    
}


extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
}
