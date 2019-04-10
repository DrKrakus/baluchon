//
//  WeatherServiceTestCase.swift
//  BaluchonTests
//
//  Created by Jerome Krakus on 10/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

@testable import Baluchon
import XCTest

class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostFailedCallbackIfError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: nil, response: nil, error: FakeResponseData.error),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: nil, response: nil, error: nil),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseKO,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNYWeatherError() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNoNYWeatherData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectNYWeatherData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfNYWeatherIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: FakeResponseData.weatherNYCorrectData,
                response: FakeResponseData.reponseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weatherDetails)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostSuccessCallbackIfWeatherAndNYWeatherAreOK() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil),
            weatherNYSession: URLSessionFake(
                data: FakeResponseData.weatherNYCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        weatherService.getWeather { (success, weatherDetails) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weatherDetails)

            let parisID = weatherDetails!["selectedCity"]!.id
            let newYorkID = weatherDetails!["newYork"]!.id

            XCTAssertEqual(parisID, 2968815)
            XCTAssertEqual(newYorkID, 5128638)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
