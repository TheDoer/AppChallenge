//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import Combine
import CoreLocation

class MainViewController: UIViewController {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var focustTableView: UITableView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var miniTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    private let mainViewModel = MainViewModel()
    private let input: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    var location: CLLocationCoordinate2D!
    var didFetchLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentLocation()
    }
    
   private func getCurrentLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      input.send(.viewDidAppear)
    }
    
    private func currentweatherBind() {
      let output = mainViewModel.transform(input: input.eraseToAnyPublisher())
      output
        .receive(on: DispatchQueue.main)
        .sink { [weak self] event in
            guard let self = self else {return}
        switch event {
        case .fetchCurrentDidSucceed(let current):
                self.cityName.text = current.name?.uppercased()
                self.mainTempLabel.text = "\(Double((current.main?.temp ?? 0)).toStringWithZeroDecimalPlaces())°"
                self.currentTempLabel.text = "\(Double((current.main?.temp ?? 0)).toStringWithZeroDecimalPlaces())°"
                self.miniTempLabel.text = "\(Double((current.main?.temp_min ?? 0)).toStringWithZeroDecimalPlaces())°"
                self.maxTempLabel.text = "\(Double((current.main?.temp_max ?? 0)).toStringWithZeroDecimalPlaces())°"
                let timeStmp = generateCurrentTimeStamp()
                self.lastUpdatedLabel.text = "last updated: \(timeStmp)"
                self.currentWeatherDescriptionLabel.text = current.weather?[0].main?.uppercased()
                self.view.backgroundColor = UIColor(rgb: self.mainViewModel.backgroundColorHexValue(conditionName: current.weather?[0].main ?? "") )
                self.backgroundImage.image = UIImage(named: self.mainViewModel.backgroundImageName(conditionName: current.weather?[0].main ?? "") )
                
            case .fetchCurrentDidFail(_): break
                //Send error via alert
        }
      }.store(in: &subscriptions)

    }
    
    func loadingBindings() {
        mainViewModel.showLoading.sink { [unowned self] (_) in
            DispatchQueue.main.async {
                let isLoading = self.mainViewModel.showLoading.value
                if isLoading {
                    self.showSpinner()
                } else {
                    self.removeSpinner()
                }
            }
        }.store(in: &subscriptions)
    }
    
    func focustWeatherBind() {
        mainViewModel
            .focustWeatherItems
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (_) in
                self.focustTableView.reloadData()
                self.focustTableView.isHidden = false
                self.focustTableView.reloadData()
                self.focustTableView.beginUpdates()
                self.focustTableView.endUpdates()
        }.store(in: &subscriptions)
    }
    
    func getFocustData() {
        mainViewModel.handleFocustWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFocustData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.focustWeatherItems.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFocustTableViewCell.identifier, for: indexPath) as? WeatherFocustTableViewCell {
            cell.focustWeatherSetUp(list: mainViewModel.focustWeatherItems.value[indexPath.row])
            return cell
        }
        return UITableViewCell()
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
          
        Location.shared.lat = locValue.latitude
        Location.shared.lon = locValue.longitude
        
        currentweatherBind()
        focustWeatherBind()
        loadingBindings()
    }
    
}



