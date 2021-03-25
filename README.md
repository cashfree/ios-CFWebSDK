# Cashfree iOS SDK (CFSDK)

CFSDK is an iOS Payment SDK created by Cashfree. This SDK can be used to integrate Cashfree Payment Gateway directly into your iOS Application. CFSDK has been designed to offload the complexity of handling and integrating payments in your application.

## Installation using Pod
1. Open the project in the terminal and type `pod init`
2. Open the generated pod file in a text editor and add the following line.
```
pod 'CFSDK', '3.0.0
```
3. Go back to the terminal and type `pod install`
4. Close the project and open the ".XCworkspace"

### Swift
```
import CFSDK 
```

### Objective-C
```
#import <CFSDK/CFSDK.h>
```

## Manual Installation and Setup
This is a sample iOS application demonstrating and utilizing Cashfree's iOS SDK, [CFSDK](https://cocoapods.org/pods/CFSDK).

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
NOTE:- In case if the project says "Unable to find module", follow the following steps:

1. Extract the CFSDK.xcframework from the zip file.
2. Remove the XCFramework in the project and Drag and Drop the extracted XCFramework.
3. Select "Copy Items If Needed" and select the target app and click on "Finish".
4. Run the app.
```

## Integration Documentation

Please click [here](https://dev.cashfree.com/payment-gateway/integrations/mobile-integration/ios) to access our SDK Integration Documentation