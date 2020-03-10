
# Mobile App iOS
Welcome to CFSDK repository. This repo hosts the Example App to get you started. 

# Cashfree SDK Integration Steps

## Step 1: Download Library

Download the `CFSDK.xcframework.zip` file from this repo and extract the `CFSDK.xcframework` folder.

## Step 2: Add Framework

1. Drag and drop `CFSDK.xcframework` folder directly onto the `Framework, Libraries and Embedded Binaries` section under the `General tab` of your iOS app project file.
2. Click the check box for `Copy items if needed`.
3. Click `Finish`.

Refer <a href="https://developer.apple.com/library/archive/technotes/tn2435/_index.html"> here </a> for more details


## Step 3: Generate Token (From Backend)
You will need to generate a token from your backend and pass it to app while initiating payments. For generating token you need to use our token generation API. Please take care that this API is called only from your <b><u>backend</u></b> as it uses **secretKey**. Thus this API should **never be called from App**.

### Request Description

<copybox>

  For production/live usage set the action attribute of the form to:
   `https://api.cashfree.com/api/v2/cftoken/order`

  For testing set the action attribute to:
   `https://test.cashfree.com/api/v2/cftoken/order`

</copybox>

You need to send orderId, orderCurrency and orderAmount as a JSON object to the API endpoint and in response a token will received. Please see  the description of request below.

```bash
curl -XPOST -H 'Content-Type: application/json' 
-H 'x-client-id: <YOUR_APP_ID>' 
-H 'x-client-secret: <YOUR_SECRET_KEY>' 
-d '{
  "orderId": "<ORDER_ID>",
  "orderAmount":<ORDER_AMOUNT>,
  "orderCurrency": "INR"
}' 'https://test.cashfree.com/api/v2/cftoken/order'
```
<br/>

### Request Example

Replace **YOUR_APP_ID** and **YOUR_SECRET_KEY** with actual values.
```bash
curl -XPOST -H 'Content-Type: application/json' -H 'x-client-id: YOUR_APP_ID' -H 'x-client-secret: YOUR_SECRET_KEY' -d '{
  "orderId": "Order0001",
  "orderAmount":1,
  "orderCurrency":"INR"
}' 'https://test.cashfree.com/api/v2/cftoken/order'
```
<br/>

### Response Example

```bash
{
"status": "OK",
"message": "Token generated",
"cftoken": "v79JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.s79BTM0AjNwUDN1EjOiAHelJCLiIlTJJiOik3YuVmcyV3QyVGZy9mIsEjOiQnb19WbBJXZkJ3biwiIxADMwIXZkJ3TiojIklkclRmcvJye.K3NKICVS5DcEzXm2VQUO_ZagtWMIKKXzYOqPZ4x0r2P_N3-PRu2mowm-8UXoyqAgsG"
}
```

The "cftoken" is the token that is used to authenticate your payment request that will be covered in the next step.
<br/>

  

## Step 4: Initiate Payment

- App passes the order info and the token to the SDK
- Customer is shown the payment screen where he completes the payment
- Once the payment is complete SDK verifies the payment
- App receives the response from SDK and handles it appropriately
  

### NOTE

- The order details passed during the token generation and the payment initiation should match. Otherwise you'll get a <b>"invalid order details"</b> error.

- Wrong appId and token will result in <b>"Unable to authenticate merchant"</b> error. The token generated for payment is valid for 5 mins within which the payment has to be initiated. Otherwise you'll get a <b>"Invalid token"</b> error.

# How to integrate
When integrating our iOS SDK, the invoking `UIViewController` should be embedded inside a `UINavigationController`. If your UIViewController is inside a `UITabBarController` you should embed the `UIViewController` inside a `UINavigationController`

  

## Step 1: Import the SDK

```swift
import  CFSDK
```

## Step 2: Input Params Dictionary

Once you generate the token from server. Create the input params dictionary (as per the payment mode) with the following values

### Web Checkout Integration

Initiate the payment in a webview. The customer will be taken to the payment page where they will have the option of paying through any payment option that is activated on their account. Once the payment is done the webview will close and the response will be delivered through the **Result Delegate**.

```swift

func  getPaymentParams() -> Dictionary<String, String> {
        return [
        "orderId": "Order100003",
        "tokenData" : "Wm9JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.Y90nIwETYzMWOxcjMygDZ1IiOiQHbhN3XiwyN3cjMwQTM3UTM6ICc4VmIsIiUOlkI6ISej5WZyJXdDJXZkJ3biwSM6ICduV3btFkclRmcvJCLiMDMwADMxIXZkJ3TiojIklkclRmcvJye.chqKQ6dsBcOPWt5nXyYdjcftSD_W1hwIJQ6lsWqNjo_s0-ug4fKsI8dPqO6KxQr_fq",
        "orderAmount": "1",
        "customerName": "Arjun",
        "orderNote": "Order Note",
        "orderCurrency": "INR",
        "customerPhone": "9012341234",
        "customerEmail": "sample@gmail.com",
        "notifyUrl": "https://test.gocashfree.com/notify"
        ]
}
```
  

### Request Parameters

| Parameter | Required | Description |
|-------------------------------------|-----------|----------------------------------------------------|
| <code>appId</code> | Yes | Your app id |
| <code>orderId</code> | Yes | Order/Invoice Id |
| <code>orderAmount</code> | Yes | Bill amount of the order |
| <code>orderNote</code> | No | A help text to make customers know more about the order |
| <code>customerName</code> | No | Name of the customer |
| <code>customerPhone</code> | Yes | Phone number of customer |
| <code>customerEmail</code> | Yes | Email id of the customer |
| <code>notifyUrl</code> | No | Notification URL for server-server communication. Useful when user’s connection drops after completing payment. |
| <code>paymentModes</code> | No | Allowed payment modes for this order. Available values: cc, dc, nb, paypal, upi, wallet. <strong>Leave it blank if you want to display all modes</strong> |

### Seamless Integration

Seamless integration can be used when there is a requirement for a more customised payment flow. In seamless integration you can implement the payment page yourself and then use our SDK to authorise the payment. Once the payment details are collected the OTP/2FA page will open in a webview. After the payment is confirmed the webview closes and you will get a callback.

Please note that seamless integration tends to be longer because the payment page UI needs to be implemented by you. We recommend that you do normal web checkout integration unless you are certain that seamless integration is required.

The following section describes the additional parameters for each of the payment methods that needs to be passed in addition to the parameters mentioned in the web checkout section.

#### Credit/Debit Card

Add the following parameters to params dictionary for initiating a seamless card transaction.

```swift
[
  "paymentOption": "card",
  "card_number": cardNumberTextbox.text ?? "",
  "card_holder": cardHolderTextbox.text ?? "",
  "card_expiryMonth": expiryMonthTextbox.text ?? "",
  "card_expiryYear": expiryYearTextbox.text ?? "",
  "card_cvv": cvvCodeTextbox.text ?? ""
]
```
  
#### Net Banking

Add the following parameters to params dictionary as illustrated before invoking doPayment() for initiating a seamless net banking transaction.

```swift
[
    "paymentOption": "nb",
    "paymentCode": "3333"  // Bank codes https://docs.cashfree.com/docs/resources/#net-banking
]
```

All valid Bank Code could can be seen [here](https://docs.cashfree.com/docs/resources/#net-banking).


#### Wallet

Add the following parameters to params dictionary as illustrated before invoking doPayment() for initiating a seamless wallet transaction.

```swift
[
    "paymentOption": "wallet",
    "paymentCode": "4001"  // Wallet codes https://docs.cashfree.com/docs/resources/#wallet
]
```

All valid Wallet Codes could can be seen [here](https://docs.cashfree.com/docs/resources/#wallet).


#### UPI

Add the following parameters to params dictionary as illustrated before invoking doPayment() for initiating a seamless UPI transaction.

```swift
[
    "paymentOption": "upi",
    "upi_vpa": "testsuccess@gocash"
]
```
  

#### Paypal

Add the following parameter to params dictionary as illustrated before invoking doPayment() for initiating a seamless Paypal transaction.

```swift
[
    "paymentOption": "paypal"
]
```

### NOTE
- <aside  class='notice'> The order details sent from the server should match the values sent from the app to SDK otherwise you'll see this error <b>"Invalid order data"</b></aside>

  

## Step 3 : Create CFViewController

Create an object of CFViewController from the SDK and push it to the NavigationController. Set the `env`(env can be either be <b>TEST or PROD</b>) and `appId`

<aside  class="notice">You can find your <b>appId</b> and <b>secret key</b> from the merchant dashboard <a  href="https://merchant.cashfree.com/merchant/pg#api-key">linked here </a></aside>
  
```swift
let cashfreeVC = CFViewController(params: getPaymentParams(), appId: self.appId, env: self.environment, callBack: self)
self.navigationController?.pushViewController(cashfreeVC, animated: true)
```

  

## Step 4 : Result Delegate

Once the payment is done, you’ll get a response in your ResultDelegate implementation

```swift
extension  ViewController: ResultDelegate {
    func  onPaymentCompletion(msg: String) {
        print("Result Delegate : onPaymentCompletion")
        print(msg)
        // Handle the result here
    }
}
```

