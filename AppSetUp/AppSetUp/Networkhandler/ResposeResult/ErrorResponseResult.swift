//
//  ErrorResponseResult.swift
//  Bedside Control
//
//  Created by Manjit on 23/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit

struct ErrorResponseResult:Decodable {

    fileprivate var  status: String?
    fileprivate var  errorMessage:String?
    enum CodingKeys: String,CodingKey {
        case status = "status"
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let errorMessage = try values.decodeIfPresent(String.self, forKey: .message) {
            self.errorMessage = errorMessage;
        }
        if let statusInfo = try values.decodeIfPresent(String.self, forKey: .status) {
            self.status = statusInfo
        }
    }
}
