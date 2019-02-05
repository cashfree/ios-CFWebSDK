//
//  ViewController.swift
//  ExampleApp
//
//  Created by Basil M Kuriakose on 27/12/17.
//  Copyright © 2017 Cashfree. All rights reserved.
//

import UIKit
import iosCashfreeSdk

class ViewController: UIViewController {
    
    // MARK: Step 1 - Set Variables (MUST NOT BE EMPTY)
    let source_config = "iossdk" //MUST be "iossdk"
    let environment = "TEST"
    let appId = "YOUR-APP-ID"
    let color1Hex = "#6a5594ff"
    let merchantName = "YOUR-MERCHANT-NAME"
    let notifyUrl = "YOUR-HTTPS-NOTIFY-URL"
    
    let orderId = "mobile-test1001"
    let orderAmount = "52"
    let customerEmail = "ionictester@email.com"
    let customerPhone = "9876543210"
    let orderNote = "This is a test note"
    let customerName = "John Doe"
    
    let paymentReady = "Tt9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.dz9JSMhJTMyITYyY2N1MWNiojI0xWYz9lIsgTMyEzNykDN1EjOiAHelJCLiIlTJJiOik3YuVmcyV3QyVGZy9mIsIiM1IiOiQnb19WbBJXZkJ3biwiIxADMxQ3clRXLlxWai9WbiojIklkclRmcvJye.sURzYR3umo8MjVyNJjNrROkh-zlOm5JEmOqf7H2biTY0l7Q3TiwZxT7V4CjtMhsy7-"
    
    // WEBVIEW CHECKOUT you can provide paymentModes to show on cashfree payment page. Eg: cc, dc, nb, paypal etc
    let paymentModes = ""
    
    // Below are required in SEAMLESS PRO Integration
    // Available values: card, nb, wallet, upi
    let paymentOption = "card"
    
    // Required if using paymentOption nb or wallet. Eg: "3333" for nb Test Bank. "4001" or "4002" for Wallet.
    let paymentCode = ""
    
    // Required if using paymentOption upi. "testsuccess@gocash"
    let upiVpa = ""
    
    // Required if you need to use googlepay use "gpay". The number provided in customerPhone will receive googlepay request.
    let upiMode = ""
    
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
    
    // Example IBAction for WEBVIEW CHECKOUT pay button
    @IBAction func payButton(_ sender: Any) {
        // Use below code If you need WEBVIEW CHECKOUT
        let CF = CFViewController()
        if paymentReady != "" {
            CF.createOrder(orderId: orderId, orderAmount: orderAmount, customerEmail: customerEmail, customerPhone: customerPhone, paymentReady: paymentReady, orderNote: orderNote, customerName: customerName, notifyUrl: notifyUrl, paymentModes: paymentModes)
            
            self.navigationController?.pushViewController(CF, animated: true)
        } else {
            print("paymentReady is empty")
        }
    }
    
    // Example IBAction for SEAMLESS PRO pay button
    @IBAction func SeamlessProBtn(_ sender: Any) {
        // Use this only if you have SEAMLESS PRO enabled at Cashfree
        let CF = SeamlessProVC()
        let paymentParams = [
            "orderId": orderId,
            "orderAmount": orderAmount,
            "customerName": customerName,
            "orderNote": orderNote,
            "customerPhone": customerPhone,
            "customerEmail": customerEmail,
            "paymentOption": paymentOption,
            "notifyUrl": notifyUrl,
            "source": source_config,
            //If you don't pass the below key:values then it will not be sent in the request.
            "card_number": "",
            "card_holder": "",
            "card_expiryMonth": "",
            "card_expiryYear": "",
            "card_cvv": "",
            "paymentCode": paymentCode,
            "upi_vpa": upiVpa,
            "upiMode": upiMode,
            "paymentReady": paymentReady
        ]
        
        CF.createOrderParams(paymentParams: paymentParams)
        self.navigationController?.pushViewController(CF, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use below code If you need WebView Checkout
        let CF = CFViewController();
        
        // Use below SeamlessProVC ONLY if you have SEAMLESS PRO enabled at Cashfree
//        let CF = SeamlessProVC();
        
        CF.setConfig(env: environment, appId: appId)
    }
    
    // MARK: Step 5 - Below function is used for Tab Bar Controller contains the result after payment is completed by the user.
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
