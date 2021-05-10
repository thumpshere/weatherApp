//
//  CityData.swift
//  Created on May 8, 2021

import Foundation
import SwiftyJSON


class CityData : NSObject, NSCoding{

    var country : String!
    var lat : Float!
    var lon : Float!
    var name : String!

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        country = json["country"].stringValue
        lat = json["lat"].floatValue
        lon = json["lon"].floatValue
        name = json["name"].stringValue
	}
    
    init(fromName Cityname: String!, countryID: String){
        country = countryID
        name = Cityname
    }

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
        if country != nil{
        	dictionary["country"] = country
        }
        if lat != nil{
        	dictionary["lat"] = lat
        }
        if lon != nil{
        	dictionary["lon"] = lon
        }
        if name != nil{
        	dictionary["name"] = name
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
		country = aDecoder.decodeObject(forKey: "country") as? String
		lat = aDecoder.decodeObject(forKey: "lat") as? Float
		lon = aDecoder.decodeObject(forKey: "lon") as? Float
		name = aDecoder.decodeObject(forKey: "name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lon != nil{
			aCoder.encode(lon, forKey: "lon")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
