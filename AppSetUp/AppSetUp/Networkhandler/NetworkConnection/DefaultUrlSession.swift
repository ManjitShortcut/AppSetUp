//
//  DefaultUrlSession.swift
//  Bedside Control
//
//  Created by Manjit on 23/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit

class DefaultUrlSession {
    
    var urlSession:URLSession{
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData;
        let urlSession  = URLSession(configuration: configuration);
        return urlSession;
    }
    static let sharedInstance = DefaultUrlSession();
}
