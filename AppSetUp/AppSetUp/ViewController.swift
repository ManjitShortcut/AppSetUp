//
//  ViewController.swift
//  AppSetUp
//
//  Created by Manjit on 20/11/2018.
//  Copyright © 2018 AppSetUp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getListValues(list: [1,2,3,4,5,6,7], withClosure:{(sum) in
            print(sum)
        });
        
        let value = colsureWithString("test","guest")
        print(value);
        
       
        
    }
    func getListValues(list:[Int],withClosure closure:(Int)->Void){
        for value in list{
            closure(value);
        }
    }
    
    func getReturnValueWithClosure( closure:(_ value:String)->String){
      let returnItems = closure("Manjit");
        print(returnItems);
    }
    
    let colsureWithString = {(value:String, name:String)->String in
        return  "Manjit" + value + name
    }

}

