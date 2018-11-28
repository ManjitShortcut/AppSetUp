//
//  ResponseResult.swift
//  Bedside Control
//
//  Created by Manjit on 23/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit

protocol ResponseResultOutPutProtocol {
    
    func isConnectionSuccess()->Bool
    func getResponseResult<T>()->T?
    func getErrorStatusCode()->String
    func getErrorStatusMessage()->String
}
enum WebServiceResponseStatus:Int{
    case WebServiceResponseStatus_Success
    case WebServiceResponseStatus_failure
}

struct ResponseResult<T> {
    
    fileprivate  let  result:T?
    fileprivate let errorResult:ErrorResponseResult?
    fileprivate let webserviceStatus:WebServiceResponseStatus?

    // init with success result and sucess status code
    init(successResult:T?, withWebServiceResponseStatus responseStatus:WebServiceResponseStatus){
        self.result = successResult;
        self.webserviceStatus = responseStatus;
        self.errorResult = nil;
    }
    // web service with error result  and error response code
    init(errorResult:ErrorResponseResult?,withWebserviceResponseStatus responseStatus:WebServiceResponseStatus){
        self.result = nil;
        self.webserviceStatus = responseStatus;
        self.errorResult = errorResult;
    }
}

extension ResponseResult:ResponseResultOutPutProtocol{
    func isConnectionSuccess() -> Bool {
        if let connectionStatus = self.webserviceStatus,let _ = self.result {
            switch connectionStatus
            {
            case .WebServiceResponseStatus_Success:
                return true;
            default :
                return false;
            }
        }
        return false;
    }
    func getErrorStatusCode()->String{
        return ""
    }
    func getErrorStatusMessage()->String{
        return ""
    }
    func getResponseResult<T>() -> T? {
        return result as? T;
    }
    
    
    
}
