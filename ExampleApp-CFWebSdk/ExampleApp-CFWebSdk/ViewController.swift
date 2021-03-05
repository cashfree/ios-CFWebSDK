//
//  ViewController.swift
//  ExampleApp
//
//  Created by Basil M Kuriakose on 27/12/17.
//  Copyright © 2017 Cashfree. All rights reserved.
//

import UIKit
import CFSDK

class ViewController: UIViewController {
    
    // Note : This sample project has the simulator SDK. Please download the device SDK from our Docs for running on phones. 
    
    // MARK:
    let environment = "TEST"
    // appId from your merchant dashboard.
    let appId = "<<APP_ID>>"
    // List of Installed UPI Apps
    var upiApps:[[String: String]]?
    
    // Example IBAction for normal WEBVIEW CHECKOUT pay button
    @IBAction func payButton(_ sender: Any) {
        // Use below code If you need WEBVIEW CHECKOUT
        CFPaymentService().doWebCheckoutPayment(
            params: getPaymentParams(),
            env: self.environment,
            callback: self)
    }
    
    // Example IBAction for SEAMLESS pay button
    @IBAction func SeamlessProBtn(_ sender: Any) {
        CFPaymentService().doWebCheckoutPayment(
            params: getSeamlessInputParams(),
                env: self.environment,
            callback: self)
        
    }
    
    // Example IBAction for SEAMLESS pay button
    @IBAction func gpayBtn(_ sender: Any) {
        
        // We recommend that you first get the list of Installed UPI apps using the method mentioned below
        let appName = (self.upiApps?.filter{ $0["displayName"] == "GOOGLEPAY" })?.first?["id"] ?? ""
        
        CFPaymentService().doUPIPayment(
            params: getUPIInputParams(appName: appName),
                env: self.environment,
            callback: self)
        
    }
    
    // Example IBAction for SEAMLESS pay button
    @IBAction func phonePeBtn(_ sender: Any) {
        
        // We recommend that you first get the list of Installed UPI apps using the method mentioned below
        let appName = (self.upiApps?.filter{ $0["displayName"] == "PHONEPE" })?.first?["id"] ?? ""
        
        CFPaymentService().doUPIPayment(
            params: getUPIInputParams(appName: appName),
                env: self.environment,
            callback: self)
        
    }
    
    
    // Example IBAction for SEAMLESS pay button
    @IBAction func PaytmBtn(_ sender: Any) {
        
        // We recommend that you first get the list of Installed UPI apps using the method mentioned below
        let appName = (self.upiApps?.filter{ $0["displayName"] == "PAYTM" })?.first?["id"] ?? ""
        
        CFPaymentService().doUPIPayment(
            params: getUPIInputParams(appName: appName),
                env: self.environment,
            callback: self)
        
    }
    
    // Example IBAction to get the list of installed UPI Apps
    @IBAction func getUpiAppsTapped(_ sender: Any) {
        self.upiApps = CFPaymentService().getUPIApps()
    }
    
    
    // Example IBAction for UNIFIED UPI Intent
    @IBAction func unifiedUPIIntentTapped(_ sender: Any) {
        CFPaymentService().doUPIPayment(params: getUPIInputParams(appName: nil), env: self.environment, callback: self)
    }
    
    private func getUPIInputParams(appName: String?)-> Dictionary<String, Any> {
        var paymentParams = getPaymentParams()
        if appName != nil {
            paymentParams["appName"] = appName
        }
        return paymentParams
    }
    
    private func getSeamlessInputParams()-> Dictionary<String, Any> {
        
        
        //Only pass values for one payment mode. If payment mode related info is not sent in the input params the normal web checkout flow will happen where the user selects from a list of payment modes.
        
        // CARD PAYMENT
        //        let cardParams = [
        //            "paymentOption": "card",
        //            "card_number": cardNumberTextbox.text ?? "",
        //            "card_holder": cardHolderTextbox.text ?? "",
        //            "card_expiryMonth": expiryMonthTextbox.text ?? "",
        //            "card_expiryYear": expiryYearTextbox.text ?? "",
        //            "card_cvv": cvvCodeTextbox.text ?? ""
        //        ]
        
        // NET BANKING
                let netBankingParams = [
                    "paymentOption": "nb",
                    "paymentCode": "3333" // Bank code https://docs.cashfree.com/docs/resources/#net-banking
                ]
        
        // WALLET
        //        let walletParams = [
        //            "paymentOption": "wallet",
        //            "paymentCode": "4001" // Bank code https://docs.cashfree.com/docs/resources/#wallet
        //        ]
        
        // UPI
        //        let upiParams = [
        //            "paymentOption": "upi",
        //            "upi_vpa": "testsuccess@gocash"
        //        ]
        
        // PAYPAL
        //        let paypalParams = [
        //            "paymentOption": "paypal"
        //        ]
                let paymentParams = getPaymentParams().merging(netBankingParams) { (_, current) in current }
                return paymentParams
        }
    
    
    func getPaymentParams() -> Dictionary<String, Any> {
        return [
            "orderId": "Order121",
            "appId": self.appId,
            "tokenData" : "<<TOKEN_DATA>>",
            "orderAmount": "1",
            "customerName": "Customer Name",
            "orderNote": "Order Note",
            "orderCurrency": "INR",
            "customerPhone": "9012341234",
            "customerEmail": "sample@gmail.com",
            "notifyUrl": "https://test.gocashfree.com/notify"
        ]
    }
    
}

extension ViewController : ResultDelegate {
    

    // This is Struct for the result (See viewDidAppear)
    struct Result : Codable {
        let orderId: String
        let referenceId: String
        let orderAmount: String
        let txStatus: String
        let txMsg: String
        let txTime: String
        let paymentMode: String
        let signature: String
        
        enum CodingKeys : String, CodingKey {
            case orderId
            case referenceId
            case orderAmount
            case txStatus
            case txMsg
            case txTime
            case paymentMode
            case signature
        }
    }
    // End of Struct for the result
    
    func onPaymentCompletion(msg: String) {
        print("JSON value : \(msg)")
        let inputJSON = "\(msg)"
        let inputData = inputJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        if inputJSON != "" {
            do {
                let result2 = try decoder.decode(Result.self, from: inputData)
                print(result2.orderId)
                print(result2)
            } catch {
                // handle exception
                print("BDEBUG: Error Occured while retrieving transaction response")
            }
        } else {
            print("BDEBUG: transactionResult is empty")
        }
    }
    

}
