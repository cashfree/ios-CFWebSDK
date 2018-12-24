//
//  ViewController.swift
//  ExampleApp-CFWebSdk
//
//  Created by Basil M Kuriakose on 10/10/18.
//  Copyright © 2018 Cashfree. All rights reserved.
//

import UIKit
import CFWebSdk

class ViewController: UIViewController {
    
    // This is Struct for the result
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
    
    // MARK: CONFIG
    let environment = "TEST" // "PROD" when you are ready to go live.
    let appId = "YOUR_APP_ID" // Find it on Cashfree Merchant dashboard
    let color1Hex = "#6a5594ff" // Color Hexcode with alpha
    let merchantName = "YOUR_MERCHANT_NAME"
    let notifyUrl = "YOUR_NOTIFY_URL"
    
    let orderId = "Z199-0004"
    let orderAmount = "120.00"
    let customerEmail = "tester@email.com"
    let customerPhone = "9876543210"
    let orderNote = "This is a test note"
    let customerName = "Firstname Lastname"
    
    // Available values: cc, dc, nb, paypal, wallet. Leave it blank if you want to display all modes
    let paymentOption = ""
    
    var paymentReady = "CFTOKEN_VALUE"
    var source_config = "iossdk" // MUST be "iossdk"
    
    
    @IBAction func payButton(_ sender: Any) {
        
        let CF = CFViewController()
        
        if paymentReady != "" {
            CF.createOrder(orderId: orderId, orderAmount: orderAmount, customerEmail: customerEmail, customerPhone: customerPhone, paymentReady: paymentReady, orderNote: orderNote, customerName: customerName, notifyUrl: notifyUrl, paymentOption: paymentOption)
            
            self.navigationController?.pushViewController(CF, animated: true)
        } else {
            print("paymentReady is empty")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let paymentParams = [
            "appId": appId,
            "orderId": orderId,
            "orderAmount": orderAmount,
            "customerName": customerName,
            "orderNote": orderNote,
            "customerPhone": customerPhone,
            "customerEmail": customerEmail,
            "paymentModes": paymentOption,
            "notifyUrl": notifyUrl,
            "source": source_config
        ]
        
        let CF = CFViewController();
        
        CF.setConfig(env: "TEST", appId: appId, color1Hex: color1Hex)
    }

    override func viewDidAppear(_ animated: Bool) {
        let paymentVC = CFViewController()
        
        let transactionResult = paymentVC.getResult()
        let inputJSON = "\(transactionResult)"
        
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
