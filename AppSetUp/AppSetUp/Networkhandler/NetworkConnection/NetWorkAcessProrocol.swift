//
//  NetWorkAcessProrocol.swift
//  BMPuls
//
//  Created by Manjit on 12/8/17.
//  Copyright © 2017 DNB. All rights reserved.
//

import Foundation

typealias NetWorkWebserviceResponseBlock = (_ httpsResponse:HTTPURLResponse?,_ reponseData:Data?,_ errorInfo:Error?) ->Void
typealias NetWorkdownLoadFileResponseBlock = (_ httpsResponse:HTTPURLResponse?,_ reponseData:Data?,_ errorInfo:Error?) ->Void

protocol WebserviceAcessProtocol{

    // execute mock Api
    func executeRestMOCKAPI(url:String?,httpMethod:String,requestHeaders:[String:String]?,postBody:Data?,withQueryParameter queryParameter:[String:String]?,withCompletionHandler completionHandler:@escaping NetWorkWebserviceResponseBlock);
    
    // execute rest api
    func executeRestAPI(url:String?,httpMethod:String,requestHeaders:[String:String]?,postBody:Data? ,withQueryParameter queryParameter:[String:String]?,withCompletionHandler completionHandler:@escaping NetWorkWebserviceResponseBlock);
    
    func executeAPIDownLoadFile(url:String?,withCompletionHandler completionHandler:@escaping NetWorkdownLoadFileResponseBlock);
    

}



