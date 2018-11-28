//
//  APIConfiguration.swift
//  Bedside Control
//
//  Created by Manjit on 23/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//


let LabCraftBaseUrl = "http://labcraft-api.azurewebsites.net"

let patienUrl = "/api/patient"
let productListUrl = "/api/product"
let apiAuthUrl = "/api/auth"
let apiEmployeeValidatorUrl = "/api/auth"


class APIConfiguration {
    
   static func getPatientUrl()->String{
        return LabCraftBaseUrl+patienUrl;
    }
    static func getProductListUrl()->String{
        return LabCraftBaseUrl+productListUrl;
    }
    static func getApiAuthUrl()->String{
        return LabCraftBaseUrl+apiAuthUrl;
    }
    static func getEmployeeValidatorUrl()->String{
        return LabCraftBaseUrl+apiEmployeeValidatorUrl;
    }
}
