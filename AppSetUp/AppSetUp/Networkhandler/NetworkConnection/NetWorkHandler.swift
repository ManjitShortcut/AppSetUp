//
//  NetWorkHandler.swift
//  Bedside Control
//
//  Created by Manjit on 26/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit



let  timeInterVal:Int = 5 // default time interval
struct NetWorkHandler {
}


extension NetWorkHandler:WebserviceAcessProtocol{
    
    // execute mock api when application is 
    func executeRestMOCKAPI(url: String?, httpMethod: String, requestHeaders: [String : String]?, postBody: Data?, withQueryParameter queryParameter: [String : String]?, withCompletionHandler completionHandler: @escaping NetWorkWebserviceResponseBlock) {

    }
    func executeRestAPI(url: String?, httpMethod: String, requestHeaders: [String : String]?, postBody: Data?, withQueryParameter queryParameter: [String : String]?, withCompletionHandler completionHandler: @escaping NetWorkWebserviceResponseBlock) {
        if let urlRequest = self.getUrlRequestForUrl(url, withQueryParameters: queryParameter, withHttpsMethod: httpMethod, withRequestHeadrs: requestHeaders, withPostdata: postBody){
            let task = DefaultUrlSession.sharedInstance.urlSession.dataTask(with: urlRequest) { (responseData, response, responseError) in
                print("receive time",Date.init().description);
                DispatchQueue.main.async {
                    if let errorInfo = responseError{
                        completionHandler(response as? HTTPURLResponse, nil, errorInfo)
                    }
                    else{
                        completionHandler(response as? HTTPURLResponse, responseData, nil)
                    }
                }
            }
            task.resume();
        }
        else{
            completionHandler(nil, nil, nil)
        }
    }
    func executeAPIDownLoadFile(url: String?, withCompletionHandler completionHandler: @escaping NetWorkdownLoadFileResponseBlock) {
        
    }
    fileprivate func getUrlRequestForUrl(_ url:String?,withQueryParameters queryParameters:[String : String]?  ,withHttpsMethod httpmethod:String, withRequestHeadrs headersParameter:[String : String]?,withPostdata postData:Data?)->URLRequest?{
        if let requestUrlString = url, let urlComponets = URLComponents(string: requestUrlString) {
            if let url = urlComponets.url{
                var apiRequest = URLRequest(url: url);
                apiRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData;
                apiRequest.httpMethod = httpmethod;
                if let headerParametersList = headersParameter{
                    apiRequest.allHTTPHeaderFields = headerParametersList;
                }
                if let body = postData{
                    apiRequest.httpBody = body;
                }
                return apiRequest;
            }
            else{
                return nil
            }
        }
        return nil;
    }

}

