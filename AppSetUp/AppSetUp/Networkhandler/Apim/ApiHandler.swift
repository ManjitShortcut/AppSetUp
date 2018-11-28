//
//  ApiHandeler.swift
//  Bedside Control
//
//  Created by Manjit on 22/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit


enum WebServiceConnectionType:Int{
    case WebServiceConnectionType_Default
    case WebServiceConnectionType_None
}
class APIM<R : ProtocolRequestObject, T : Decodable> : NSObject {
    
    enum  HttpMethod: String {
        case Post = "POST"
        case Get = "GET"
        case Delete = "DELETE"
        case Put = "PUT"
        case Patch = "PATCH"
        case none = ""
    }
    private var _urlString : String?;
    private var _requestObject : Data?;
    private var _method : APIM.HttpMethod;
    private var _queryParameter : [String : String]?;
    private var _headers : [String:String]?;
    private var webServiceConnectionType:WebServiceConnectionType? // if you want some special operation on spefic web service then use this connectioin type

    override init() {
        _urlString = nil;
        _requestObject = nil;
        _method = .none;
        _queryParameter = nil;
        _headers = nil;
        super.init();
    }
    private lazy var jsonHeaders:Dictionary<String, String> = {
        var headers = Dictionary<String, String>()
        headers.updateValue("application/json", forKey: "Content-Type")
        headers.updateValue("application/json", forKey: "Accept")
        return headers;
    }()

    func setDefaultHeaderParameter()->[String:String]?{
        return nil;
    }
    
    
    private var _requestData : Data?;
    private var _completion : ((_ sender : APIM, _ response : ResponseResult<T>) -> Void)?;
    
    /*
     init with url and Methods
     use this method only when there is not change header parameter.
     */
    public convenience init(url:String, method:HttpMethod, request:R?) {
        self.init();
        self.configureApiInformationWithUrl(url, withHttpsMethods: method, withUpdateHeaders: nil, withNewHeaders:self.jsonHeaders, withQueryParameter: nil, withRequestInfo: request)
    }
    /*
     init with url and Methods and
     Use this method only when there is new headers use not default one.
     if you want to modified default headers then create your own method and use it
     */
//    public convenience init(url:String,method:HttpMethod,request:R?, withNewHeader newHeaders:[String:String]?){
//        self.init();
//        if  let defaultHauders = self.setDefaultHeaderParameter()  {
//            var headers = defaultHauders
//            if let newHeaderValue = newHeaders
//            {
//                headers.update(other: newHeaderValue);
//                self.configureApiInformationWithUrl(url, withHttpsMethods: method, withUpdateHeaders: nil, withNewHeaders: headers, withQueryParameter: nil, withRequestInfo: request)
//            }
//        }
//    }
    /*
     init with url and Methods and
     Use this method only when user want to pass some extra header parameter.
     */
    public convenience init(url:String,method:HttpMethod,request:R?,updateHeaders:[String:String]){
        self.init();
        self.configureApiInformationWithUrl(url, withHttpsMethods: method, withUpdateHeaders: updateHeaders, withNewHeaders:self.jsonHeaders, withQueryParameter: nil, withRequestInfo: request)
    }
    /*
     Init with url and query parameters
     Use this method if url has some query parameter to update
     */
    public convenience init(url:String,method:HttpMethod,request:R?,queryParameter:[String:String]){
        self.init();
        self.configureApiInformationWithUrl(url, withHttpsMethods: method, withUpdateHeaders: nil, withNewHeaders:self.jsonHeaders, withQueryParameter: queryParameter, withRequestInfo: request)
    }
    /*
     Init with url and query parameters
     Use this method if url has some query parameter  and update headrs
     */
    public convenience init(url:String,method:HttpMethod,request:R?,updateHeaders:[String:String], queryParameter:[String:String]){
        self.init();
        self.configureApiInformationWithUrl(url, withHttpsMethods: method, withUpdateHeaders: updateHeaders, withNewHeaders:nil, withQueryParameter: queryParameter, withRequestInfo: request)
    }
    /*
     Configute api information
     */
    fileprivate func configureApiInformationWithUrl(_ url:String,withHttpsMethods method:HttpMethod ,withUpdateHeaders updateHeaders:[String:String]?, withNewHeaders newHeaders:[String:String]?, withQueryParameter queryParameter:[String:String]?,withRequestInfo request:R?){
        _urlString = url;
        _method = method;
        _headers = jsonHeaders;

       
        if let newHeadersInfo = newHeaders {
            _headers = newHeadersInfo;
        }
        if let queryParameterInfo = queryParameter {
            _queryParameter = queryParameterInfo;
        }
        
        if let requestInfo = request {
            _requestObject = requestInfo.generateRequestObject();
        }
    }
    
    // execute the default webservice all for api getway.This web service is reponsible for connectiong APi get way via Mobile hub frame work.
    public func executeApi( completion: @escaping (_ sender : APIM, _ response : ResponseResult<T>) -> Void) {
        self.webServiceConnectionType = .WebServiceConnectionType_Default;
        _completion = completion;
        let networkHandler:WebserviceAcessProtocol = NetWorkHandler();
        print("SEND time:",Date());
        networkHandler.executeRestAPI(url: _urlString, httpMethod: _method.rawValue, requestHeaders: _headers, postBody:_requestObject, withQueryParameter: self._queryParameter, withCompletionHandler: processHttpsResponseResult);

    }
    
    // this is the special web service call for profile image because in profile image web service we need not parse the ant data m we have to save this data nad converted it into utf8 string.
    // This connection is through aws api getway.
    
    public func executeForImage(completion: @escaping (_ sender : APIM, _ response : ResponseResult<T>) -> Void) {
        self.webServiceConnectionType = .WebServiceConnectionType_Default;
        _completion = completion;
        let networkHandler:WebserviceAcessProtocol = NetWorkHandler();
        networkHandler.executeRestAPI(url: _urlString, httpMethod: _method.rawValue, requestHeaders:nil, postBody:_requestObject, withQueryParameter: self._queryParameter, withCompletionHandler: processHttpsResponseResult);
    }
    // web service response form api call
    private func processHttpsResponseResult(_ httpsResponse:HTTPURLResponse?,_ reponseData:Data?,_ errorInfo:Error?) {
        if let httpsResponse = httpsResponse,let responseResultData = reponseData{
            switch httpsResponse.statusCode{
              case 200:
                self.handleSuccessResponseWithResponseData(responseResultData)
              default:
                self.handlerErrorWithResponseData(responseResultData)
                break;
            }
        }
        else{
            self.handlerErrorWithResponseData(nil);
        }
    }
    /*
     Handler success sinario form web service
     */
    
    // handle success sinario for respose data
    fileprivate func handleSuccessResponseWithResponseData(_ responseData:Data?){
        
        if let response = responseData {
             let datastring = NSString(data: response, encoding: String.Encoding.utf8.rawValue)
            print(datastring!)
            let decoder = JSONDecoder();
            do {
                let responseObj = try decoder.decode(T.self, from: response);
                let response:ResponseResult = ResponseResult(successResult: responseObj, withWebServiceResponseStatus: .WebServiceResponseStatus_Success);
               completeRequest(response: response);
            }
            catch {
                self.handleDefaultEror();
            }
        }
        else{
            self.handleDefaultEror();
        }
    }
    // handle default error like network error and parser error and respose data is not preset error
    fileprivate func handleDefaultEror(){
        let response = ResponseResult<T>(errorResult: nil, withWebserviceResponseStatus:.WebServiceResponseStatus_failure);
        completeRequest(response: response);
    }
    fileprivate func handlerErrorWithResponseData(_ reponseData:Data?){
        if let response = reponseData {
            let decoder = JSONDecoder();
            do {
              let errorInfo = try decoder.decode(ErrorResponseResult.self, from: response);
              let response:ResponseResult = ResponseResult<T>(errorResult: errorInfo, withWebserviceResponseStatus: .WebServiceResponseStatus_failure)
               completeRequest(response: response);
            }
            catch{
                self.handleDefaultEror();
            }
        }
        else{
            self.handleDefaultEror();
        }
    }
    // fetch webservice connection type
    fileprivate func getWebServiceType()->WebServiceConnectionType{
        if let connect = self.webServiceConnectionType{
            return connect;
        }
        return .WebServiceConnectionType_Default;
    }
    // call back to remote manager after getting response
    private func completeRequest(response : ResponseResult<T>) {
        if let completionHandler = _completion {
            completionHandler(self, response);
        }
    }
}





