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
    
    let viewModel = WeatherScreenViewModel()
    var location: CLLocationCoordinate2D!
    var didFetchLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.delegate = self
        viewModel.webService = WebService()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        location = locationManager.location?.coordinate
        locationManager.delegate = self

    }
    
    private func setupViews() {
        mainTempLabel.text = viewModel.currentTemperature
        currentWeatherDescriptionLabel.text = viewModel.currentCondition()
     miniTempLabel.text = viewModel.minimumTemperature
        currentTempLabel.text = viewModel.currentTemperature
        maxTempLabel.text = viewModel.maximumTemperature
        backgroundImage.image = UIImage(named: viewModel.backgroundImageName())
        self.view.backgroundColor = viewModel.backgroundColor()
        focustWeatherTableView.reloadData()
    }
    
    func fetchWeatherData() {
        setupViews()
    }
    
    func errorFetchingWeatherInfo(error: NetworkError) {
        var errorMessage = ""
        
        switch error {
            
        case .customError(let customError):
            errorMessage = customError.localizedDescription
        default:
            errorMessage = error.localizedDescription
        }

        showRetryAlert(title: "Network error", message: errorMessage, vc: self) { [weak self] in
            if let self = self {
                self.viewModel.getWeatherInfo(location: self.location)
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
            viewModel.getWeatherInfo(location: self.location)
        }
    }
}
