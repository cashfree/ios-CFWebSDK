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
    let environment = "TEST"
    let url = "https://test.gocashfree.com/checksum.php"
    let appId = "275432e3853bd165afbf5272"
    let color1Hex = "#6a5594ff"
    let merchantName = "Jyoti Gas"
    let notifyUrl = "https://test.gocashfree.com/notify"
    
    let orderId = "Z" + String(arc4random())
    let orderAmount = "12000.00"
    let customerEmail = "ionictester@email.com"
    let customerPhone = "9876543210"
    let orderNote = "This is a test note"
    let customerName = "Firstname Lastname"
    
    // Available values: cc, dc, nb, paypal, wallet. Leave it blank if you want to display all modes
    let paymentOption = ""
    
    var paymentReady = "" //MUST be ""
    var source_config = "iossdk" //MUST be "iossdk"
    
    
    @IBAction func payButton(_ sender: Any) {
        
        
        let CF = CFViewController()
        
        if paymentReady != "" {
            CF.createOrder(orderId: orderId, orderAmount: orderAmount, customerEmail: customerEmail, customerPhone: customerPhone, paymentReady: paymentReady, orderNote: orderNote, customerName: customerName, notifyUrl: notifyUrl, paymentOption: paymentOption)
            
            self.navigationController?.pushViewController(CF, animated: true)
        } else {
            print(paymentReady)
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
        
        CF.setConfig(env: "TEST", appId: appId, url: url, color1Hex: color1Hex)
        
        CF.initPayment(paymentParams: paymentParams, completion: {output in
            self.paymentReady = (output)
        })
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

