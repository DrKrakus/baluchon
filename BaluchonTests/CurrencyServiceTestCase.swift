//
//  CurrencyServiceTestCase.swift
//  BaluchonTests
//
//  Created by Jerome Krakus on 09/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

@testable import Baluchon
import XCTest

class CurrencyServiceTestCase: XCTestCase {

    func testGetCurrencyShouldPostFailedCallbackIfError() {
        // Given
        let currencyService = CurrencyService(
            currencySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getCurrency { (success) in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrencyShouldPostFailedCallbackIfNoData() {
        // Given
        let currencyService = CurrencyService(
            currencySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getCurrency { (success) in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrencyShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let currencyService = CurrencyService(
            currencySession: URLSessionFake(
                data: FakeResponseData.currencyCorrectData,
                response: FakeResponseData.reponseKO,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getCurrency { (success) in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrencyShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let currencyService = CurrencyService(
            currencySession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getCurrency { (success) in
            // Then
            XCTAssertFalse(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrencyShouldPostSuccesCallbackIfCorrectDataAndNoError() {
        // Given
        let currencyService = CurrencyService(
            currencySession: URLSessionFake(
                data: FakeResponseData.currencyCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currencyService.getCurrency { (success) in
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
