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
    
    // MARK:
    let environment = "TEST"
    // appId from your merchant dashboard.
    let appId = "275432e3853bd165afbf5272"
    
    // Example IBAction for normal WEBVIEW CHECKOUT pay button
    @IBAction func payButton(_ sender: Any) {
        // Use below code If you need WEBVIEW CHECKOUT
        let cfViewController = CFViewController (
            params: getPaymentParams(),
            appId: self.appId,
            env: self.environment,
            callBack: self)
        self.navigationController?.pushViewController (cfViewController, animated: true);
    }
    
    // Example IBAction for SEAMLESS pay button
    @IBAction func SeamlessProBtn(_ sender: Any) {
        let CF = CFViewController(
            params: getSeamlessInputParams(),
                appId: self.appId,
                env: self.environment,
                callBack: self)
        self.navigationController?.pushViewController(CF, animated: true)
    }
    
    
    
    
    private func getSeamlessInputParams()-> Dictionary<String, String> {
        
        
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
    
    
    func getPaymentParams() -> Dictionary<String, String> {
        return [
            "orderId": "Order121",
            "tokenData" : "uS9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.2u0nI3QGOyM2M1gjM4EGZ1IiOiQHbhN3XiwSO1QzM5gzM3UTM6ICc4VmIsIiUOlkI6ISej5WZyJXdDJXZkJ3biwSM6ICduV3btFkclRmcvJCLiEjMxIXZkJ3TiojIklkclRmcvJye.9LQIerz3Ybl5SfRCcdqFVOdKTb4KO_5v5Hpxa5g2mWyN-p4PkFwt65wmZTrLxr4khI",
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
