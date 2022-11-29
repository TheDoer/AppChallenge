//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
   
    @IBOutlet weak var backgroundWeatherImageView: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var currentTempDescription: UILabel!
    
    @IBOutlet weak var miniTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    
    var viewModel = MainViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    private let input: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    @IBOutlet weak var focustTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        fetchFocustWeatherData()
        bindFocust()
        bindCurrent()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      input.send(.viewDidAppear)
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
                        self?.currentTempDescription.text = current.weather?[0].main

                        self?.miniTempLabel.text = "\(Double(current.main?.temp_min ?? 0 ).rounded(toPlaces: 0))°"
                        self?.currentTempLabel.text = "\(Double(current.main?.temp ?? 0).rounded(toPlaces: 0))°"
                        self?.maxTempLabel.text = "\(Double(current.main?.temp_max ?? 0).rounded(toPlaces: 0))°"
                        
                        self?.setBackgroundImage(weather: current.weather?[0].main)
                        
                    case .fetchCurrentWeatherDidFail(error: let error):
                        self?.removeSpinner()
                        //show and error dialog here to show the error
                        self?.tempLabel.text = error.localizedDescription
                }
            }.store(in: &subscriptions)
    }
 
    func fetchFocustWeatherData() {
        viewModel.getFocustWeather()
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
            case "Clouds":
                backgroundWeatherImageView.image = UIImage(named: "forest_cloudy")
            case  "Rain":
               backgroundWeatherImageView.image = UIImage(named: "forest_rainy")
                
             default:
                backgroundWeatherImageView.image = UIImage(named: "forest_rainy")
            
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
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

