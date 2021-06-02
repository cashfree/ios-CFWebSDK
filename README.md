# Cashfree iOS SDK (CFSDK)

CFSDK is an iOS Payment SDK created by Cashfree. This SDK can be used to integrate Cashfree Payment Gateway directly into your iOS Application. CFSDK has been designed to offload the complexity of handling and integrating payments in your application.


## Manual Installation and Setup

Below are the latest iOS SDK download links:\
```ENABLE_BITCODE``` should be set to ```YES```

| XCode Version | Swift Version | Supported Architectures | Framework Download Link                                                                      |
|---------------|---------------|-------------------------|----------------------------------------------------------------------------------------------|
| 10.3          | 4.2           | arm, armv7, arm64       | [Download Phone SDK](https://drive.google.com/open?id=1AYA1VpRj91rL3FgjOEVxj-U_9uWZEKPu)     |
| 10.3          | 4.2           | x86_64, i386            | [Download Simulator SDK](https://drive.google.com/open?id=1CvRQLAM_0jXLwZwAGkncUQAYDF55ZK_6) |
| 11.+          | 5+            | All                     | [Download SDK](https://drive.google.com/drive/folders/1mbNKZaD4s27vhUZwZN9ZPBnCjc6PXZgs?usp=sharing)       |
| 12.+          | 5+            | All                     | [Download SDK](https://github.com/cashfree/ios-CFWebSDK/blob/master/CFSDK.xcframework.zip)   |

### Set up your Project
#### Add Cashfree SDK
1. Drag and drop the contents of zip file onto your Xcode project navigator. Select the checkbox for ```Copy items if needed```. Click ```Finish```
2. Then click the + button on ```Embedded Binaries``` under the ```General tab``` of your iOS app project file.
3. Select ```CFSDK.xcframework```.
4. Click ```Finish```.

**Click [here](https://developer.apple.com/library/archive/technotes/tn2435/_index.html) for more information.**

### This is a sample iOS application demonstrating and utilizing Cashfree's iOS SDK

1. Clone the github project using zip file download or using
```
git clone https://github.com/cashfree/ios-CFWebSDK.git
```
2. Open the ExampleCFWebSDK app using XCode.

3. Change the variable **appID** to your respective appId that is generated in the Cashfree's merchant dashboard.

4. Generate the orderToken by following the integration documentation mentioned below.

5. Add the generated token in the **"tokenData"** key.

6. Set the respective environment **"TEST"** or **"PROD"** and run the project.

```
NOTE:- In case if the project says "Unable to find module", follow the steps:

1. Extract the CFSDK.xcframework from the zip file.
2. Remove the XCFramework in the project and Drag and Drop the extracted XCFramework.
3. Select "Copy Items If Needed" and select the target app and click on "Finish".
4. Run the app.
```

# Integration Documentation

To integrate Cashfree iOS SDK with your iOS application,

1. [Create an account with Cashfree and get the API keys](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-1-create-account-and-get-api-keys)
2. [Integrate the Cashfree SDK into your application](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-2-integrate-sdk)
3. [Generate Token (From Backend)](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-3-generate-token-from-backend)
4. [Initiate payment](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-4-initiate-payment) - Invoke a payment API from the Cashfree SDK with the token generated when the customer initiates payment for an order from your application. Cashfree SDK displays appropriate screens to the customer for the payment.
5. [Receive and handle response](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-5-receive-and-handle-response) - Cashfree SDK returns the payment result for the order which should be handled in your application.
6. [Verify response](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-6-verify-response) - We recommend you to verify the payment response using webhooks and by checking the signature value returned in the payment response.

#### Step 1: Create Account and Get API Keys

1. Go to [Cashfree website](https://merchant.cashfree.com/) and create an account. Click [here](https://dev.cashfree.com/get-started/merchant-account#account-activation) for detailed steps on how to create and activate your account.
2. Log in to your Merchant Dashboard using the same credentials.
3. Click **Payment Gateway** section **View Dashboard** click **Credentials**. For security purposes, you need to enter your password for verification.
4. Copy the app ID and the secret key. These values are required to create the order token from your server. Order tokens are used to authenticate the API calls made from Cashfree iOS SDK.


#### Step 2: Generate Token (From Backend)
The ```cftoken ``` is used to authenticate the payment requests made from SDK. It has to be generated for every payment attempt made for an order. Pass this token to the SDK while initiating the payment for that order. For generating a cftoken you need to use our token generation API.

#### Request Description to Generate Token

**Production**: set the URL to **https://api.cashfree.com/api/v2/cftoken/order**\
**Testing**: set the URL to **https://test.cashfree.com/api/v2/cftoken/order**

You need to send ```orderId```, ```orderCurrency``` and ```orderAmount``` as a JSON object to the API endpoint and in response you will receive a token. Please see the description of the request below.

#### Token Request Description:
```
curl -XPOST -H 'Content-Type: application/json' 
-H 'x-client-id: ' 
-H 'x-client-secret: ' 
-d '{
  "orderId": "",
  "orderAmount":,
  "orderCurrency": "INR"
}' 'https://test.cashfree.com/api/v2/cftoken/order'
```

**Token Request Example:** Replace ```YOUR_APP_ID``` and ```YOUR_SECRET_KEY``` with actual values.

```
curl -XPOST -H 'Content-Type: application/json' -H 'x-client-id: 2754xxxxxxxxxxf5272' -H 'x-client-secret: 2279ccxxxxxxxxxxxxx409517' -d '{
  "orderId": "Order0001",
  "orderAmount":1,
  "orderCurrency":"INR"
}' 'https://test.cashfree.com/api/v2/cftoken/order'
```

#### Token Response Example:
```
{
"status": "OK",
"message": "Token generated",
"cftoken": "v79JCXXXXXXXXXXXXN1EjOiAHelJCLiXXXXXXXXXXXZiclRmcvJye.K3NKICVS5DcEzXm2VQUO_ZagtWMIKKXzYOqPZ4x0r2P_N3-PRu2mowm-8UXoyqAgsG"
}
```

The “cftoken” attribute is the token that needs to be used to secure your request.\
**This API should be called from your server (backend) only, and never from your iOS application as it uses the secretKey.**

#### Step 3: Initiate Payment
After generating the order token, the payment gets initiated when the payment APIs are called (doWebCheckoutPayment, doUPIPayment, doGPayPayment, doAmazonPayment).
For payment, your application passes the order info and the cftoken to the SDK. The relevant payment screen is displayed to the customer where they enter the required information and make the payment. After the payment is complete the customers are redirected to the iOS application and response is received in the  ```ResultDelegate``` implementation.

**The order details passed during the token generation and the payment initiation should match. Else, you will get an `Invalid order details` error.
Wrong appId and token will result in `Unable to authenticate merchant` error. The token generated for payment is valid for 5 minutes within which the payment has to be initiated. Else, you will get an `Invalid token` error.**

#### Step 4: Receive and Handle Response
Once the payment is done, you will get a response in ResultDelegate implementation.
```
extension ViewController: ResultDelegate {
    func onPaymentCompletion(msg: String) {
        print("Result Delegate : onPaymentCompletion")
        print(msg)
        // Handle the result here
    }
}
```

#### Step 6: Verify Response
We recommend you to verify the payment response using webhooks. You can also verify the response by checking the signature in the payment response.

### Sample Application
Click [here](https://github.com/cashfree/ios-CFWebSDK) to view the sample application.

### Checkout
Checkout is the standard flow for Cashfree iOS SDK. In this flow, SDK loads a webview which renders the Cashfree's payment page. Customers can fill in details here and complete payment.\
There are two types of Web Checkout methods. You can select the required method based on your business need.

**Update Info.plist file in your project**\
Add the following code to info.plist file.
```
<key>LSApplicationCategoryType</key>
<string></string>
<key>LSApplicationQueriesSchemes</key>
<array>
<string>phonepe</string>
<string>tez</string>
<string>paytm</string>
<string>bhim</string>
</array>
```

1. **Normal** - Customer selects the payment mode and enters the payment details within the Cashfree's web payment page to complete the payment.
2. **Seamless** - Customer selects the payment mode and enters payment details in your application. These details are then passed on to the Cashfree SDK. Webview is launched only for the two-factor authentication.

When integrating our iOS SDK, the invoking `UIViewController` should have been embedded inside a `UINavigationController`. If your `UIViewController` is inside a `UITabBarController` you should embed the `UIViewController` inside a `UINavigationController`

#### Step 1: Import the SDK
```
import CFSDK
```

#### Step 2: Input Params Dictionary
Once you [generate the token](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-3-generate-token-from-backend) from server, create the input params dictionary with the following values.

**The order details sent from the server should match the values sent from the app to SDK otherwise you'll see this error "Invalid order data".**

```
func getPaymentParams() -> Dictionary<String, Any> {
    return [
        "appId": "<<YOUR_APP_ID>>",
        "orderId": "Order100003",
        "tokenData" : "<<GENERATED_TOKEN>>",
        "orderAmount": "1",
        "customerName": "Customer name",
        "orderNote": "Order Note",
        "orderCurrency": "INR",
        "customerPhone": "9012341234",
        "customerEmail": "sample@gmail.com",
        "notifyUrl": "https://test.gocashfree.com/notify"
    ]
}
```

#### Step 3: Call Payment Function
Create an object of CFPaymentService from the SDK and call the `doWebCheckoutPaymentfunction` with the `env` and `ResultDelegatecallback`. `env` can be either be TEST or PROD.Click [here](https://dev.cashfree.com/payment-gateway/integrations#api-keys) to know how to get the App ID and Secret Key. 

```
CFPaymentService().doWebCheckoutPayment(
                        params: params,
                        env: Constants.environment,
                        callback: self)
```

#### Step 4: Result Delegate
Once the payment is done, you will get a response in your ResultDelegate implementation.
```
extension ViewController: ResultDelegate {
    func onPaymentCompletion(msg: String) {
        print("Result Delegate : onPaymentCompletion")
        print(msg)
        // Handle the result here
    }
}
```

### Seamless Checkout
In a Seamless payment flow, the customer enters all details on merchant app checkout view itself. Once the customer has entered all details related to the payment mode, the request opens in a webview showing the service provider (Example, OTP page in case of card payment).\
The integration steps for seamless mode is almost the same as the checkout flow except the input params passed will have extra parameters according to the payment mode selected.\
Pass the params in the below snippet in addition to the other input params specified [here](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#step-2-input-params-dictionary).

#### Card Payment
Add the following parameters to the params map before invoking doWebCheckoutPayment() method to initiate a seamless card transaction.

```
let cardParams = [
    "paymentOption": "card",
    "card_number": "4434260000000008", //Replace Card number
    "card_holder": "John Doe", // Card Holder name
    "card_expiryMonth": "05", // Card Expiry Month in MM
    "card_expiryYear": "2021", // Card Expiry Year in YYYY
    "card_cvv": "123" // Card CVV
]
```

#### UPI Payment
Add the following parameters to the params map before invoking doWebCheckoutPayment() method to initiate a seamless UPI transaction.
```
let upiParams = [
    "paymentOption": "upi",
    "upi_vpa": "testsuccess@gocash"
]
```

#### Wallet Payment
Add the following parameters to the params map before invoking doWebCheckoutPayment() method to initiate a seamless wallet transaction. All valid wallet codes are available [here](https://dev.cashfree.com/payment-gateway/payments/wallets).

```
let walletParams = [
    "paymentOption": "wallet",
    "paymentCode": "4001" // Wallet code https://docs.cashfree.com/docs/resources/#wallet
]
```

#### Netbanking Payment
Add the following parameters to the params map before invoking doWebCheckoutPayment() method to initiate a seamless net banking transaction. All valid bank codes are available [here](https://dev.cashfree.com/payment-gateway/payments/netbanking).
```
let netBankingParams = [
    "paymentOption": "nb",
    "paymentCode": "3333" // Bank code https://docs.cashfree.com/docs/resources/#net-banking
]
```

#### Paypal Payment
Add the following parameters to the params map before invoking doWebCheckoutPayment() method to initiate a seamless Paypal transaction.
```
let paypalParams = [
    "paymentOption": "paypal"
]
```

### UPI Intent
UPI Intent for iOS supports Googlepay, PhonePe, and Paytm currently.\
Steps to integrate,
1. **Update Info.plist file in your project**\
Add the following code to info.plist file.
```
<key>LSApplicationCategoryType</key>
<string></string>
<key>LSApplicationQueriesSchemes</key>
<array>
<string>phonepe</string>
<string>tez</string>
<string>paytm</string>
<string>bhim</string>
</array>
```
2. **Compose order details and pass to Cashfree PG SDK**\
Using the last 2 API responses compose dictionary<String, Any>.
```
var orderParms = [
   "orderId": "<YOUR_ORDER_ID>",
   "tokenData" : "<cfToken>",
   "orderAmount": "<ORDER_AMOUNT>",
   "orderCurrency":"<ORDER_AMOUNT_CURRENCY>",
   "customerName": "Example",
   "orderNote": "First Order",
   "customerPhone": "1111111111",
   "appId": "<YOUR_APP_ID>",
   "customerEmail": "example@gmail.com",
   "notifyUrl": "https://test.gocashfree.com/notify", //optional
   ]
```
Pass this object to Cashfree SDK with appName and environment. Once the function is called, Cashfree iOS SDK will show the list of supported apps. Once the user selects the app, they will be redirected to the selected app to make the payment. After completing the payment your customers must navigate back to your application.
```
CFPaymentService().doUPIPayment(params : orderParams,  env: "TEST", callback: self)
```
3. **Get result from Cashfree PG SDK**\
Cashfree SDK will launch either PhonePe or Google Pay based on the option selected by the user. Once the payment is completed in the 3rd party UPI payment app and the user switches back to the app, the SDK will verify the payment and return the result through the ResultDelegate.
```
extension ViewController: ResultDelegate 
{
    func onPaymentCompletion(msg: String) 
    {
        print("Result Delegate : onPaymentCompletion \(msg)")
        // Handle the result here
    }
}
```

**The response will be a stringified JSON syntax**
```
{"txStatus": "PENDING", "message": null}
```
You can verify the payment after successfully completing the above steps.

## Direct App Integration
### AmazonPay
Steps to integrate
1. **Create token using order token API mentioned above**
2. **Compose order details and pass to Cashfree PG SDK**\
Using the last 2 API responses compose dictionary<String, Any>.
```
var orderParms = [
   "orderId": <YOUR_ORDER_ID>,
   "tokenData" : <cfToken>,
   "orderAmount": <ORDER_AMOUNT>,
   "orderCurrency":<ORDER_AMOUNT_CURRENCY>,
   "customerName": "Example",
   "orderNote": "First Order",
   "customerPhone": "1111111111",
   "appId": <YOUR_APP_ID>,
   "customerEmail": "example@gmail.com",
   "notifyUrl": "https://test.gocashfree.com/notify"
]
```
Now pass this object to Cashfree SDK with appName and environment.
```
CFPaymentService().doAmazonPayPayment(params : orderParams,  env: "TEST", callback: self)
```
| Params | Possible Values |
|--------|-----------------|
| env    | TEST or PROD    |
3. **Get result from Cashfree PG SDK**\
Cashfree SDK will launch either PhonePe or Google Pay based on the option selected by the user. Once the payment is completed in the SFSafariViewController and the user clicks on done, the SDK will verify the payment and pass the result through the ResultDelegate.
```
extension ViewController: ResultDelegate {
    func onPaymentCompletion(msg: String) {
        print("Result Delegate : onPaymentCompletion \(msg)")
        // Handle the result here
    }
}
```
The response will be a stringified JSON of syntax `{"txStatus": "PENDING", "message": null}`
## Request Parameters
These are the parameters that are available to you when you are making a request for payment on Cashfree iOS SDK.

| Parameter     | Required | Description                                                                                                                                                                                                                                 |
|---------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| appId         | Yes      | Your app id                                                                                                                                                                                                                                 |
| orderId       | Yes      | Order/Invoice Id                                                                                                                                                                                                                            |
| orderAmount   | Yes      | Bill amount of the order                                                                                                                                                                                                                    |
| orderCurrency | No       | Currency for the order. INR if left empty. See the [Currency Codes](https://dev.cashfree.com/payment-gateway/payments/currencies-supported) below for a list of available currencies. Contact care@gocashfree.com to enable new currencies. |
| orderNote     | No       | A help text to make customers know more about the order                                                                                                                                                                                     |
| customerName  | Yes      | Name of the customer                                                                                                                                                                                                                        |
| customerPhone | Yes      | Customer Phone Number                                                                                                                                                                                                                       |
| customerEmail | Yes      | Customer Email Id                                                                                                                                                                                                                           |
| notifyUrl     | No       | Notification URL for server-server communication. Useful when the user’s connection drops while.                                                                                                                                            |
| paymentModes  | No       | Allowed payment modes for this order. Available values: cc, dc, nb, paypal, wallet. Leave it blank if you want to display all modes                                                                                                         |

## Response Parameters
These parameters are returned to the functions you implement using paymentVC.getResult(). transactionResult contains the details of the transaction. Always verify the signature in the response as described in the response verification section (mentioned below).

| Parameter   | Description                                                                                                                                                                                                |
|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| orderId     | Order id for which transaction has been processed. Ex: GZ-212                                                                                                                                              |
| orderAmount | Amount of the order. Ex: 256.00                                                                                                                                                                            |
| referenceId | Cashfree generated unique transaction Id. Ex: 140388038803                                                                                                                                                 |
| txStatus    | Payment status for that order. Values can be: SUCCESS, FLAGGED, PENDING, FAILED, CANCELLED. For UPI Intent the status can be: PENDING, INCOMPLETE, FAILED, FLAGGED, USER_DROPPED, SUCCESS, CANCELLED, VOID |
| paymentMode | Payment mode used by customer to make the payment. Ex: DEBIT_CARD, MobiKwik, etc                                                                                                                           |
| txMsg       | Message related to the transaction. Will have the reason if payment failed                                                                                                                                 |
| txTime      | Time of the transaction                                                                                                                                                                                    |
| signature   | Signature generated to verify the authenticity of the transaction as explained  [here](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#response-verification)                 |

> - There can be scenarios where the SDK is not able to verify the payment within a short period of time. The status of such orders will be PENDING.\
> - If the Webview closes immediately after it is opened then it could be because of some issues with the input that is passed to the SDK. Check the inputs passed and if you still need further help reach out to us at techsupport@cashfree.com.\
> - If you are getting INCOMPLETE as the transaction status please reach out to your account manager or techsupport@cashfree.com. To know more about the transaction statuses, click [here](https://dev.cashfree.com/payment-gateway/transaction-lifecycle).

## Webhook Notification
Do not go live without integrating webhook notification.\

We send a notification from our backend to your backend whenever an order payment is processed successfully to your notifyUrl. This is useful in cases such as when the user internet connection breaks after payment. This will allow you to reconcile all the successful orders on your end. The notification will be sent to notifyUrl which is specified at order creation. The parameters sent in the notification are described [here](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios#response-parameters).\

To specify notifyUrl just add it alongside other parameters (orderId, orderAmount etc.).

> Notifications are usually instant but rarely can take a minute to hit your server. Make sure that your url supports https. Notifications are sent only in the case of successful payments.\
Sometimes you may receive the same notification two or more times. It is recommended to ensure that your implementation of the webhook is idempotent.\
Ensure that you verify the signature in the webhook response.

## Response Verification
Verify the response signature to check the authenticity of the transaction response. Do not go live without verifying the signature.\

In every response, we add a digital signature to establish the authenticity of the message. We require you to verify this received signature at your end. This will verify if the response has not been tampered with.\

This verification has to be done on your backend server as it will involve secretKey which should never be exposed on the client-side. Please use the appropriate code example from below depending on your backend language.

## Running your App
The CFSDK Dynamic Framework works on iOS 10 and above.
 
Click [here](https://dev.cashfree.com/payment-gateway/integrations#api-keys) to know how to view or generate the API keys for Production and Test Environment.

## Test Credentials
| Parameter      | Required | Description      |
|----------------|----------|------------------|
| `Card Number`  | Yes      | 4111111111111111 |
| `Card Holder`  | Yes      | Test             |
| `Expiry Month` | Yes      | 10               |
| `Expiry Year`  | Yes      | 22               |
| `CVV/CVC`      | Yes      | 123              |

