//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel!
    var subscriptions = Set<AnyCancellable>()
    @IBOutlet weak var focustTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentWeatherData()
        fetchFocustWeatherData()
        viewModelBindings()
    }
    
    func fetchCurrentWeatherData() {
        viewModel.getCurrentWeather()
    }
    
    func fetchFocustWeatherData() {
        viewModel.getFocustWeatheer()
    }
    
    func viewModelBindings() {
        viewModel
            .focustWeather
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (_) in
                self.focustTableView.reloadData()
                
            }.store(in: &subscriptions)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.focustWeather.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let focustItem = viewModel.focustWeather.value[indexPath.row]
        //print("Date: \(focustItem.dt)")
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFocustTableViewCell.identifier, for: indexPath) as! WeatherFocustTableViewCell
        cell.focustWeatherSetUp(list: focustItem)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}

