//
//  TranslateServiceTestCase.swift
//  BaluchonTests
//
//  Created by Jerome Krakus on 10/04/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

@testable import Baluchon
import XCTest

class TranslateServiceTestCase: XCTestCase {

    func testGetTranslateShouldPostFailedCallbackIfError() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translateService.getTranslation { (succes, stringToDecode) in
            // Then
            XCTAssertFalse(succes)
            XCTAssertNil(stringToDecode)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfNoData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translateService.getTranslation { (success, stringToDecode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(stringToDecode)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.reponseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translateService.getTranslation { (success, stringToDecode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(stringToDecode)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translateService.getTranslation { (success, stringToDecode) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(stringToDecode)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslateShouldPostSuccessCallbackIfCorrectDataAndNoError() {
        // Given
        let translateService = TranslateService(
            translateSession: URLSessionFake(
                data: FakeResponseData.translateCorrectData,
                response: FakeResponseData.reponseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Waiting for queue change")
        translateService.getTranslation { (success, stringToDecode) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(stringToDecode)

            let string = "I&#39;m testing a translation"
            XCTAssertEqual(string, stringToDecode)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
