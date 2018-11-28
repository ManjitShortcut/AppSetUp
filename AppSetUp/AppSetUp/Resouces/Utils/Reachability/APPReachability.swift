//
//  BMPReachability.swift
//  BMPuls
//
//  Created by Manjit on 2/28/18.
//  Copyright © 2018 DNB. All rights reserved.
//

import UIKit

class APPReachability: NSObject {
    static let sharedInstance = APPReachability();
     override init() {
        super.init();
    }
    func checkInternet()->Bool{
        return true;
//        let interNet = Reachability.init(hostName: APIURLConfiguration.APIDomainURL);
//        let netWorkStatus:NetworkStatus = interNet!.currentReachabilityStatus();
//        switch netWorkStatus {
//        case NotReachable:
//            return false;
//        default:
//            return  true;
//        }
    }
}
