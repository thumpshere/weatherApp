//
//  StorageHelper.swift
//  weather
//
//  Created by Arpit on 08/05/21.
//

import UIKit
import Cache

class StorageHelper: NSObject {
  static let sharedInstance = StorageHelper()
  
  let storage = try? Storage<String,String>(
    diskConfig: DiskConfig(name: Constants.dataStoreId),
    memoryConfig: MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10),
    transformer: TransformerFactory.forCodable(ofType: String.self)
  )
  
  func getDataFromCache(keyString: String) -> String {
    
    let cachedData = (try? storage?.object(forKey: keyString)) ?? ""
    return cachedData
  }
  
  func saveDataToCache (data: String, keyString: String) {
    do {
      try storage?.setObject(data, forKey: keyString)
    } catch {
      print(error)
    }
  }
  
  func deleteDataFromCache(keyString: String) {
    do {
      try storage?.removeObject(forKey: keyString)
    } catch {
      
    }
  }
}
