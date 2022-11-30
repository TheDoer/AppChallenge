//
//  AppChallengeTests.swift
//  AppChallengeTests
//
//  Created by Adonis Rumbwere on 30/11/2022.
//

import XCTest
@testable import AppChallenge

final class CurrentWeatherViewModelTests: XCTestCase {
    
    private var sut:ForecastItemViewModel!
    private var forecastWeatherItem: ForecastWeatherItem!
    
    override func setUpWithError() throws {
        let weather = Weather(id: 4, main: "Sunny", description: "", icon: "")
        let main = Main(temp: 31.1, tempMin: 27.7, tempMax: 34.6)
        let date = Date(timeIntervalSince1970: 1679781066)
        forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        sut = ForecastItemViewModel(forecastWeatherItem)
    }
    
    func testDay_ShouldReturnCorrectDay() {
        XCTAssertEqual(sut.day, "Tuesday")
    }
    
    func testTemperature_ShouldReturnCorrectString() {
        XCTAssertEqual(sut.temperature, "56°")
    }
    
    func testConditionImageName_ShouldReturnCorrectName() {
        XCTAssertEqual(sut.switchImage(), "forest_sunny")
    }

}
