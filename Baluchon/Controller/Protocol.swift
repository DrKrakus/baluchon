//
//  Protocol.swift
//  Baluchon
//
//  Created by Jerome Krakus on 20/03/2019.
//  Copyright © 2019 Jerome Krakus. All rights reserved.
//

import Foundation

// Protocol for receive currency choice
protocol IsAbleToReceiveData: NSObjectProtocol {
    func pass(_ data: String)
}
