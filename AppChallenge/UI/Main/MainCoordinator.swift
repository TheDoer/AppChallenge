//
//  MainCoordinator.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
    var mainViewModel = MainViewModel()
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let frameworkBundle = Bundle(identifier: "co.zw.AppChallenge")
        let storyboard = UIStoryboard(name: "Main", bundle: frameworkBundle)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController?
        mainViewModel.mainCoordinator = self
        vc?.viewModel = mainViewModel
        rootViewController.pushViewController(vc!, animated: true)
    }
}
