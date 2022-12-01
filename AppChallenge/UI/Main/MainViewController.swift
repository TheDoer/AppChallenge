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
        currentweatherBind()
        focustWeatherBind()
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
        switch event {
        case .fetchCurrentDidSucceed(let current):
                self?.mainTempLabel.text = Double((current.main?.temp ?? 0)).toStringWithZeroDecimalPlaces()
                self?.currentTempLabel.text = Double((current.main?.temp ?? 0)).toStringWithZeroDecimalPlaces()
                self?.miniTempLabel.text = Double((current.main?.temp_min ?? 0)).toStringWithZeroDecimalPlaces()
                self?.maxTempLabel.text = Double((current.main?.temp_max ?? 0)).toStringWithZeroDecimalPlaces()
                let timeStmp = generateCurrentTimeStamp()
                self?.lastUpdatedLabel.text = "last updated: \(timeStmp)"
                self?.currentWeatherDescriptionLabel.text = current.weather?[0].main?.uppercased()
                self?.view.backgroundColor = UIColor(rgb: self?.mainViewModel.backgroundColorHexValue() ?? 0x47AB2F )
                self?.backgroundImage.image = UIImage(named: self?.mainViewModel.backgroundImageName() ?? "forest_rainy")
            case .fetchCurrentDidFail(_): break
                
        }
      }.store(in: &subscriptions)

    }
    
    func focustWeatherBind() {
        mainViewModel
            .focustWeatherItems
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (_) in
                //reload tableview
                //stop spinner
        }.store(in: &subscriptions)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.focustWeatherItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFocustTableViewCell.identifier, for: indexPath) as? WeatherFocustTableViewCell {
            //cell.focustWeatherSetUp(list: mainViewModel.focustWeatherItems.value[indexPath.row])
        }
        return UITableViewCell()
        
    }
    
}



