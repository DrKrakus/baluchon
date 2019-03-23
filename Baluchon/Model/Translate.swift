//
//  Translate.swift
//  Baluchon
//
//  Created by Jerome Krakus on 23/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

struct TranslateModel: Codable {
    let data: DataClass!
}

struct DataClass: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}

struct Translate {
    static var shared = Translate()
    private init() {}

    var quote = ""
    var translatedQuote = ""
}
