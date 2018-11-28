//
//  BMPStroageHandler.swift
//  BMPuls
//
//  Created by Manjit on 11/27/17.
//  Copyright © 2017 DNB. All rights reserved.
//

import UIKit


enum StorageType:String{
    case StorageType_DataBase = "DataBase"
    case StorageType_UserDefault = "UserDefault"
    case StorageType_KeyChain = "KeyChain"
}

protocol StroageHandlerInputProtocol {
    
    func storeDataInUserDeviceWithStoargeType(_ stroageType:StorageType ,withStroageValue value:String,withStroageKey key:String);
    func resetDataInUserDeviceWithStroageType(_ stroageType:StorageType ,withStroageValue value:String,withStroageKey key:String)
}

protocol StroagehanderOutPutProtocol {
    func getDataInUserDeviceWithStoargeType<T>(_ stroageType: StorageType, forStroageKey key: String)->T?
}

class StorageHandler: NSObject {

    static let sharedInstance = StorageHandler()

    fileprivate func savaDataToUserDefaultForValue( _ value:String, withKey key:String){
        UserDefaults.standard.set(value, forKey: key) //setObject
        UserDefaults.standard.synchronize()
    }
    fileprivate func savaDataToKeyChainForValue( _ value:String, withKey key:String)
	{
        let keychain = KeychainItemWrapper(identifier: key, accessGroup:nil);
		keychain?.setObject(value, forKey: kSecAttrAccount)
		keychain?.setObject(kSecAttrAccessibleWhenUnlockedThisDeviceOnly, forKey: kSecAttrAccessible)
    }
    fileprivate func saveDataToDataBaseForQuery(_ query:String, withDatabaseName name:String){
    }
    fileprivate func fetchDataFromFromKeyChain<T>(keyName:String)->T?
    {
        let keychain = KeychainItemWrapper(identifier: keyName, accessGroup:nil);
		if let value  = keychain?.object(forKey: kSecAttrAccount){
			return value as? T;
		}
		else{
			return nil
		}
	
    }
    fileprivate func fetchDataFormUserDefault<T>(keyName:String)->T?
    {
        if let value  = UserDefaults.standard.value(forKey: keyName){
            return value as? T;
        }
        else{
            return nil
        }
    }
    fileprivate func resetDataBase(_ value:String,forkey key:String){
    }
    fileprivate func resetKeyChainValue(_ value:String,forkey key:String){
        let keychain = KeychainItemWrapper(identifier: key, accessGroup:nil);
        keychain?.resetKeychainItem();
    }
    fileprivate func resetUserDefault(_ value:String,forkey key:String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
extension StorageHandler:StroageHandlerInputProtocol{
    
    func storeDataInUserDeviceWithStoargeType(_ stroageType: StorageType, withStroageValue value: String, withStroageKey key: String) {
        switch stroageType {
        case .StorageType_DataBase:
            self.saveDataToDataBaseForQuery(value, withDatabaseName: key);
        case .StorageType_UserDefault:
            self.savaDataToUserDefaultForValue(value, withKey: key);
        case .StorageType_KeyChain:
            self.savaDataToKeyChainForValue(value, withKey: key);
        }
    }
    func resetDataInUserDeviceWithStroageType(_ stroageType:StorageType ,withStroageValue value:String,withStroageKey key:String){
        switch stroageType {
        case .StorageType_DataBase:
            self.resetDataBase(value, forkey:key);
        case .StorageType_UserDefault:
            self.resetUserDefault(value, forkey:key);
        case .StorageType_KeyChain:
            self.resetKeyChainValue(value, forkey:key);

        }
    }
}
extension StorageHandler:StroagehanderOutPutProtocol {
    
    func getDataInUserDeviceWithStoargeType<T>(_ stroageType: StorageType, forStroageKey key: String)->T? {
        switch stroageType {
        case .StorageType_UserDefault:
            if let userInfo :T =  self.fetchDataFormUserDefault(keyName: key)
             {
                return userInfo;
             }
            else{
                return nil;
            }
        case .StorageType_KeyChain:
            
        if let result:T = self.fetchDataFromFromKeyChain(keyName: key)
           {
            return result;
           }
           else{
            return nil;

           }
            
        default:
            return nil
        }
        
    }
    
}
