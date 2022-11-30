//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import Combine
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var focustWeatherTableView: UITableView!
    @IBOutlet weak var largeCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var currentConditionLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var smallCurrentTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var currentTempDescription: UILabel!
    
    @IBOutlet weak var miniTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    
    
    //Location
    var currentLocation: CLLocation?
    
    var viewModel = MainViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    private let input: PassthroughSubject<MainViewModel.InputCurrent, Never> = .init()
    
    @IBOutlet weak var focustTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        bindFocust()
        bindCurrent()
        getFocustWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      input.send(.viewDidAppear)
        setUpLocation()
    }
    
    let locationManager = CLLocationManager()
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.startUpdatingLocation()
            requestWeatherForLocation()
            }
        }

    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else  {
            return
        }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
       
        
        Location.sharedInstance.latitude = lat
        Location.sharedInstance.longitude = lon
        
        print("Coord: \(Location.sharedInstance.latitude) | \(Location.sharedInstance.longitude)")
        
        print(" URL: \(Config.BaseURL)/weather?lat=\(Location.sharedInstance.latitude)&lon=\(Location.sharedInstance.longitude)&appid=\(Config.APIKey)&units=\(Config.Units)")
        
    }
    
    func getFocustWeather() {
        viewModel.getFocustWeather()
    }
    
    private func  bindCurrent() {
        self.showSpinner()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] event in
                switch event {
                    case .fetchCurrentWeatherDidSucceed(let current):
                        self?.removeSpinner()
                        self?.tempLabel.text = "\(Double(current.main?.temp ?? 0).rounded(toPlaces: 0))°"
                        self?.currentTempDescription.text = (current.weather?[0].main)?.uppercased()

                        self?.miniTempLabel.text = "\(Double(current.main?.temp_min ?? 0 ).rounded(toPlaces: 0))°"
                        self?.currentTempLabel.text = "\(Double(current.main?.temp ?? 0).rounded(toPlaces: 0))°"
                        self?.maxTempLabel.text = "\(Double(current.main?.temp_max ?? 0).rounded(toPlaces: 0))°"
                        let timeStmp = generateCurrentTimeStamp()
                        self?.lastUpdatedLabel.text = "Last updated: \(timeStmp)"
                        
                        self?.setBackgroundImage(weather: current.weather?[0].main)
                        
                    case .fetchCurrentWeatherDidFail(error: let error):
                        self?.removeSpinner()
                        
                        let alert = UIAlertController(title: "Error", message: "Something went wrong.", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.destructive, handler: { action in
                            self?.bindCurrent()
                        }))
                        
                        self?.present(alert, animated: true, completion: nil)
                }
            }.store(in: &subscriptions)
    }
    
    private func bindFocust() {
        viewModel
            .focustWeather
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (_) in
                self.focustTableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    func setBackgroundImage(weather: String?) {
        switch weather {
            case "Sunny":
                backgroundWeatherImageView.image = UIImage(named: "forest_sunny")
                self.minMaxView.backgroundColor = AppTheme.backgroundColorSunny
                self.view.backgroundColor = AppTheme.backgroundColorSunny
                
            case "Clouds":
                backgroundWeatherImageView.image = UIImage(named: "forest_cloudy")
                self.minMaxView.backgroundColor = AppTheme.backgroundColorCloudy
                self.view.backgroundColor = AppTheme.backgroundColorCloudy

            case  "Rain":
               backgroundWeatherImageView.image = UIImage(named: "forest_rainy")
                self.minMaxView.backgroundColor = AppTheme.backgroundColorRainy
                self.view.backgroundColor = AppTheme.backgroundColorRainy
              
             default:
                backgroundWeatherImageView.image = UIImage(named: "forest_rainy")
                self.minMaxView.backgroundColor = AppTheme.backgroundColorRainy
                self.view.backgroundColor = AppTheme.backgroundColorRainy
            
        }
        
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.focustWeather.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let focustItem = viewModel.focustWeather.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFocustTableViewCell.identifier, for: indexPath) as! WeatherFocustTableViewCell
        cell.focustWeatherSetUp(list: focustItem)
        
        let currentWeatherStatus = focustItem.weather?[0].main?.lowercased()
        
        guard let currentWeatherStatus = currentWeatherStatus else {
            return UITableViewCell()
        }
    
        
        if currentWeatherStatus.contains("Sunny") {
            cell.contentView.backgroundColor = AppTheme.backgroundColorSunny
        } else if currentWeatherStatus.contains("Clouds") {
            cell.contentView.backgroundColor = AppTheme.backgroundColorCloudy
        } else if currentWeatherStatus.contains("Rain") {
            cell.contentView.backgroundColor = AppTheme.backgroundColorRainy
        } else {
            cell.contentView.backgroundColor = AppTheme.backgroundColorSunny
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

