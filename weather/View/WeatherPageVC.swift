//
//  ViewController.swift
//  weather
//
//  Created by Arpit on 07/05/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import Cache
import SDWebImage
import Reachability

class WeatherPageVC: UIViewController {
  
  @IBOutlet var btnFavorite: UIButton!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  @IBOutlet var resultTableHeightConstraint: NSLayoutConstraint!
  @IBOutlet var tblSearchResults: UITableView!
  @IBOutlet var lblTemperature: UILabel!
  @IBOutlet var searchtext: UISearchBar!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var lblDescription: UILabel!
  @IBOutlet var lblHighTemp: UILabel!
  @IBOutlet var lblLowTemp: UILabel!
  @IBOutlet var lblFeelsLike: UILabel!
  @IBOutlet var lblAirPressure: UILabel!
  @IBOutlet var lblHumidity: UILabel!
  @IBOutlet var lblSunrise: UILabel!
  @IBOutlet var lblSunset: UILabel!
  @IBOutlet var lblDate: UILabel!
  @IBOutlet var lblCity: UILabel!
  
  
  let viewModel = weatherViewModel()
  var Cities = [CityData]()
  let reachability = try! Reachability()
  var Favorites = [String]()
  var weatherInfo:weatherData?
  var isFavTable = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.handleCallBacksFromViewModel()
    searchtext.delegate = self
    self.addNetworkNotifier()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    createUI()
  }
  
  
  
  // MARK: UI  CONFIGURATION METHODS
  func createUI () {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.navigationController?.isNavigationBarHidden = false
    self.navigationController?.title = AppStrings.AppName
    self.tblSearchResults.register(ResultCell.self, forCellReuseIdentifier: CellIdentifiers.resultCell)
    self.scrollView.contentSize = CGSize(width: ScreenDimensions.screenWidth, height: UIViewConstants.scrollContentSize)
    self.Favorites = WeatherHelper.getCityDataFromUserDefaults(key: UserDefaultKeys.favorites)
  }
  
  func updateWeatherDataUI(weatherinfo:weatherData) {
    self.weatherInfo = weatherinfo
    self.lblTemperature.text = "\(weatherinfo.main.temp ?? 0)" + Constants.degreeCelsius
    WeatherHelper.savetoUserDefaults(value: weatherinfo.name, key: UserDefaultKeys.city)
    self.lblCity.text = weatherinfo.name
    self.checkIfFavoriteAlreadyExists()
    self.lblHighTemp.text = AppStrings.MaxTemp + "\(weatherinfo.main.tempMax ?? 0)" + Constants.degreeCelsius
    self.lblLowTemp.text = AppStrings.MinTemp + "\(weatherinfo.main.tempMin ?? 0)" + Constants.degreeCelsius
    self.lblFeelsLike.text = AppStrings.feelsLike + "\(weatherinfo.main.feelsLike ?? 0)" + Constants.degreeCelsius
    let weatherMain = weatherinfo.weather[0]
    self.lblDescription.text = weatherMain.descriptionField.capitalized
    let weatherIcon = weatherMain.icon ?? ""
    let imageUrl = BaseURLs.Imagesurl + PathURLs.imagePath + weatherIcon + Constants.imageExtension
    self.imageView.sd_setImage(with: URL(string: imageUrl))
    self.lblSunrise.text = AppStrings.sunrise + AppStrings.appendedStringAt + WeatherHelper.getTimeString(timestamp: weatherinfo.sys.sunrise)
    self.lblSunset.text = AppStrings.sunset + AppStrings.appendedStringAt + WeatherHelper.getTimeString(timestamp: weatherinfo.sys.sunset)
    self.lblDate.text =  WeatherHelper.getDateString(timestamp: weatherinfo.dt)
    self.lblHumidity.text = AppStrings.Humidity + AppStrings.appendedStringAt + "\(weatherinfo.main.humidity ?? 0)" + Constants.symbolPercent
    self.lblAirPressure.text = AppStrings.Pressure + AppStrings.appendedStringAt + "\(weatherinfo.main.pressure ?? 0)" + Constants.symbolHpa
  }
  
  func reloadTable() {
    if self.viewModel.Cities.count == 0 {
      WeatherHelper.showAlert(title: AppStrings.errorHeading, message: AppStrings.invalidCityName) { }
    }
    self.Cities = self.viewModel.Cities
    DispatchQueue.main.async {
      self.tblSearchResults.reloadData()
      self.showTable()
    }
  }
  
  func stopActivityIndicator(){
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
    }
  }
  func startSearchField(){
    DispatchQueue.main.async {
      self.searchtext.becomeFirstResponder()
    }
  }
  
  
  // MARK:Network Notifiers METHODS
  @objc func reachabilityChanged(note: Notification) {
    let isConnected = WeatherHelper.isConnectedToInternet()
    if (!isConnected) {
      self.viewModel.getDatafromStorage()
    }else {
      self.viewModel.callWeatherDataAPI(city: "")
    }
  }
  
  func addNetworkNotifier(){
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
    do{
      try reachability.startNotifier()
    }catch{
    }
  }
  
  // MARK:Favorites Logic METHODS
  @IBAction func favoriteButtonClicked(_ sender: Any) {
    let city = weatherInfo?.name ?? ""
    var append = false
    if (self.btnFavorite.isSelected){
      self.btnFavorite.isSelected = false
    }else {
      self.btnFavorite.isSelected = true
      append = true
    }
    saveFavoritesToUserDefaults(city: city,shouldAppend: append)
  }
  
  func checkIfFavoriteAlreadyExists(){
    let city = weatherInfo?.name ?? ""
    if self.Favorites.contains(city) {
      self.btnFavorite.isSelected = true
    }else {
      self.btnFavorite.isSelected = false
    }
  }
  
  func saveFavoritesToUserDefaults(city:String,shouldAppend:Bool) {
    self.Favorites = self.viewModel.saveFavoritesToUserDefaults(city: city, shouldAppend: shouldAppend, favoritesArray: self.Favorites)
  }
  
  // MARK: ViewModel Callback Handler
  func handleCallBacksFromViewModel() {
    
    self.viewModel.dataLoadingSuccess = {[weak self] () -> Void in
      let weatherInfo = self?.viewModel.weatherModel
      self?.updateWeatherDataUI(weatherinfo: weatherInfo!)
      self?.stopActivityIndicator()
    }
    
    self.viewModel.dataFetchFromCacheSuccess = {[weak self] () -> Void in
      let weatherInfo = self?.viewModel.weatherModel
      self?.updateWeatherDataUI(weatherinfo: weatherInfo!)
      self?.stopActivityIndicator()
    }
    
    self.viewModel.dataEmpty = { [weak self] () -> Void in
      self?.startSearchField()
      self?.stopActivityIndicator()
    }
    
    self.viewModel.cityRequestSuccess = {[weak self] () -> Void in
      self?.stopActivityIndicator()
      self?.reloadTable()
    }
    
    self.viewModel.cityRequestError = {[weak self] () -> Void in
      self?.stopActivityIndicator()
    }
    
  }
  
  func showTable () {
    self.resultTableHeightConstraint.constant = 700
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
  
  func HideTable(){
    self.resultTableHeightConstraint.constant = 0
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
  
}

extension WeatherPageVC:UISearchBarDelegate {
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    self.isFavTable = false
    self.HideTable()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.isFavTable = false
    print(searchBar.text ?? "")
    if searchBar.text == "" {
      WeatherHelper.showAlert(title: AppStrings.errorHeading, message: AppStrings.invalidCityName) { return }
    }
    self.activityIndicator.startAnimating()
    self.viewModel.callCitySearchAPI(city: searchBar.text ?? "")
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    self.isFavTable = false
    self.HideTable()
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    self.isFavTable = true
    self.searchtext.becomeFirstResponder()
    self.showTable()
    self.tblSearchResults.reloadData()
  }
}

extension WeatherPageVC:UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFavTable{
      return self.Favorites.count
    }else {
      return self.Cities.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let listCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.resultCell) as! ResultCell
    listCell.selectionStyle = .none
    if isFavTable{
      listCell.textLabel?.text = self.Favorites[indexPath.row]
    }else {
      let city = self.Cities[indexPath.row]
      listCell.textLabel?.text = city.name + "," + city.country
    }
    return listCell
  }
  
}

extension WeatherPageVC : UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var city = ""
    if isFavTable{
      city = self.Favorites[indexPath.row]
      self.isFavTable = false
    }else {
      city = self.Cities[indexPath.row].name ?? ""
    }
    self.activityIndicator.startAnimating()
    self.viewModel.callWeatherDataAPI(city: city)
    self.searchtext.endEditing(true)
    self.HideTable()
  }
}
