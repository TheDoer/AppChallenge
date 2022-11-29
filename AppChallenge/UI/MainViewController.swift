//
//  ViewController.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 23/11/2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
   
    
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
        Bind()
        bindCurrent()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      input.send(.viewDidAppear)
    }
    
    private func  bindCurrent() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] event in
                switch event {
                    case .fetchCurrentWeatherDidSucceed(let current):
                        self?.tempLabel.text = "\(Double(current.main?.temp ?? 0).rounded(toPlaces: 0))°"
                        self?.currentTempDescription.text = current.weather?[0].main
                        
                        self?.miniTempLabel.text = "\(Double(current.main?.tempMin ?? 0 ?? 0).rounded(toPlaces: 0))°"
                        self?.currentTempLabel.text = "\(Double(current.main?.temp ?? 0).rounded(toPlaces: 0))°"
                        self?.maxTempLabel.text = "\(Double(current.main?.tempMax ?? 0).rounded(toPlaces: 0))°"
                        
                        
                    case .fetchCurrentWeatherDidFail(error: let error):
                        self?.tempLabel.text = error.localizedDescription
                }
            }.store(in: &subscriptions)
        
    }
    
    
    
    
    func fetchFocustWeatherData() {
        viewModel.getFocustWeather()
    }
    
    
    
    
    private func Bind() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherFocustTableViewCell.identifier, for: indexPath) as! WeatherFocustTableViewCell
        cell.focustWeatherSetUp(list: focustItem)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

