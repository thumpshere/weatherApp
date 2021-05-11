
# weatherApp
This app is created using [OpenWeatherMap](https://openweathermap.org/) APIs.
This allows you to 

- search and display efficient weather data in a clean readable format.

- Bookmark your favorite cities.

- Store data offline for last searched City

![screenshot](https://user-images.githubusercontent.com/10941262/117795612-f9f8a980-b26b-11eb-81c7-e8550ce1b930.png)

# How to use

- Clone the repository

- Register on [OpenWeatherMap](https://openweathermap.org/)and get an API key.

- Open terminal on your mac and go to project folder.

- Run pod install (if you dont have cocoapods installed Please refer to - [CocoaPods](https://cocoapods.org/) )

- Open weather.xcworkspace file.

- Open file weather/Common/Constants/Constants.swift

- Replace appToken with apikey mentioned on [OpenWeatherMap API keys](https://home.openweathermap.org/api_keys).

- Run the App.

# Third Party Libraries used

- [Alamofire](https://github.com/Alamofire/Alamofire) For Nteworking
- [Cache](https://github.com/hyperoslo/Cache) - For storage
- [Reachability Swift](https://github.com/ashleymills/Reachability.swift) - For Network Connection Availability
- [SDWebimage](https://github.com/SDWebImage/SDWebImage) - For Image Caching
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - For JSON parsing

