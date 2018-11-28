//
//  PinCodeView.swift
//  Bedside Control
//
//  Created by Manjit on 28/11/2018.
//  Copyright © 2018 Sutha. All rights reserved.
//

import UIKit


let maximumPinLength = 4


protocol PinCodeViewOutDelegate:class{
    
    func getPinCodeValue(_ pinCode:String);
}

final class PinCodeView: UIView {

    @IBOutlet weak var pinCodeTextFiled: UITextField!
    @IBOutlet var pincodeListfield  : [UIImageView]!
    fileprivate lazy var textInPutString:String = ""
    weak var delegate:PinCodeViewOutDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.setUpPasscodeView();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    // set up passcode screen
    func setUpPasscodeView(){
        pinCodeTextFiled.addTarget(self, action: #selector(passcodePinChange(_:)),for:.editingChanged)
        pinCodeTextFiled.becomeFirstResponder();
        pinCodeTextFiled.text = "";
        self.setupPinview();
    }
    @objc func passcodePinChange(_ passcodeFiled:UITextField){
        textInPutString = passcodeFiled.text ?? "";
        self.setupPinview();
    }

    // design up pin view . and _ depending upon the textfiled text
    fileprivate func setupPinview(){
        if let textfiledText = self.pinCodeTextFiled.text{
            var intialCount = 0;
            for imageView in pincodeListfield{
                if intialCount < textfiledText.count{
                    imageView.isHighlighted = false;
                }
                else{
                    imageView.isHighlighted = true;
                }
                intialCount = (intialCount+1)
            }
            if (textfiledText.count == maximumPinLength){
                self.perform(#selector(setPasscodeValue(_:)), with:textfiledText , afterDelay: 0.3)
            }
        }
        else{
            pincodeListfield.forEach {
                $0.isHighlighted = true
            }
        }
    }
    // once textfiled legtn is equal to maximumPinLength then it will cal back respetive view
    @objc func setPasscodeValue(_ passcodeValue:String){
        if let thisDelegate = self.delegate{
            thisDelegate.getPinCodeValue(passcodeValue)
        }
    }
    
}

extension PinCodeView:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty{
            return true;
        }
        else{
            if string.isValidForNumber(){
                if string.isValidForNumber(){
                    return true;
                }
                else{
                    return false;
                }
            }
            else{
                return false;
            }
        }
    }
}


extension String
{
    // regex for check input type is number or not, if it is not number then it will not execute
    func isValidForNumber()->Bool{
        let expression = "^[0-9]" // mobile number eregx
        return checkExpresstionIsValidWithExpression(expression, withInputString: self)
    }
    private func checkExpresstionIsValidWithExpression(_ expression:String, withInputString inputString:String)->Bool{
        let regex = try! NSRegularExpression(pattern: expression, options: [])
        let matches = regex.matches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.count))
        if (matches.count>0){
            return true
        }
        else{
            return false
        }
    }

}

