//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, WeatherDelegate {
    
    @IBOutlet weak var focustWeatherTableView: UITableView!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var miniTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
   
    let locationManager = CLLocationManager()
    
    let viewModel = CurrentWeatherViewModel()
    var location: CLLocationCoordinate2D!
    var didFetchLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.delegate = self
        setUpLocation()
    }
    
    func setUpLocation(){
        showSpinner()
        viewModel.networkService = NetworkService()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        location = locationManager.location?.coordinate
        locationManager.delegate = self
    }
    
    private func setupViews() {
        mainTempLabel.text = viewModel.currentTemp
        currentWeatherDescriptionLabel.text = viewModel.default()
        miniTempLabel.text = viewModel.miniTemp
        currentTempLabel.text = viewModel.currentTemp
        maxTempLabel.text = viewModel.maxTemp
        backgroundImage.image = UIImage(named: viewModel.backgroundImageName())
        let timeStmp = generateCurrentTimeStamp()
        lastUpdatedLabel.text = "last updated: \(timeStmp)"
        self.view.backgroundColor = viewModel.backgroundColor()
        focustWeatherTableView.reloadData()
    }
    
    func fetchWeatherData() {
        setupViews()
    }
    
    func errorFetchingWeatherData(error: AppError) {
        removeSpinner()
        var errorMessage = ""
        
        switch error {
            
        case .customError(let customError):
            errorMessage = customError.localizedDescription
        default:
            errorMessage = error.localizedDescription
        }

        showRetryAlert(title: "Network error", message: errorMessage, vc: self) { [weak self] in
            if let self = self {
                self.viewModel.getWeatherData(location: self.location)
            }
        }
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherFocustTableViewCell") as! WeatherFocustTableViewCell
        cell.focustWeatherSetUp(list: viewModel.forecastWeatherAtIndex(indexPath.row))
        return cell
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didFetchLocation {
            self.didFetchLocation = true
            self.location = locations[0].coordinate
            viewModel.getWeatherData(location: self.location)
        }
    }
}
