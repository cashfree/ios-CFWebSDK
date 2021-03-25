//
//  ViewController.m
//  CFSDK-Sample-App-Objective-C
//
//  Created by Suhas G on 22/03/21.
//

#import "ViewController.h"
#import <CFSDK/CFSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)webPaymentTapped:(id)sender {
    CFPaymentService* cfPaymentService = [[CFPaymentService alloc] init];
    // Change the env to PROD while using PROD credentials
    [cfPaymentService doWebCheckoutPaymentWithParams:[self getInputParams] env:@"TEST" callback:self];
}

-(NSDictionary *) getInputParams {
    NSMutableDictionary<NSString *, NSString *> *params = [[NSMutableDictionary alloc] init];
    params[@"orderId"] = @"Order_ID";
    params[@"appId"] = @"<APP_ID>";
    params[@"tokenData"] = @"<CFTOKEN>"; // Generate the token from back-end by following the documentation and add the cfToken value here
    params[@"orderAmount"]= @"1";
    params[@"customerName"]= @"<Customer Name";
    params[@"orderNote"]= @"Order Note";
    params[@"orderCurrency"]= @"INR";
    params[@"customerPhone"]= @"Customer Number";
    params[@"customerEmail"]= @"Customer Email";
    params[@"notifyUrl"]= @"https://test.gocashfree.com/notify";
    return params;
}

- (IBAction)unifiedUPITapped:(id)sender {
    CFPaymentService* cfPaymentService = [[CFPaymentService alloc] init];
    [cfPaymentService doUPIPaymentWithParams:[self getInputParamsForUPI:nil] env:@"PROD" callback:self];
}

-(NSDictionary *) getInputParamsForUPI:(NSString *)appName {
    NSMutableDictionary<NSString *, NSString *> *params = [[NSMutableDictionary alloc] init];
    params[@"orderId"] = @"Order_ID";
    params[@"appId"] = @"<APP_ID>";
    params[@"tokenData"] = @"<CFTOKEN>"; // Generate the token from back-end by following the documentation and add the cfToken value here
    params[@"orderAmount"]= @"1";
    params[@"customerName"]= @"<Customer Name";
    params[@"orderNote"]= @"Order Note";
    params[@"orderCurrency"]= @"INR";
    params[@"customerPhone"]= @"Customer Number";
    params[@"customerEmail"]= @"Customer Email";
    params[@"notifyUrl"]= @"https://test.gocashfree.com/notify";
    return params;
}


- (void)onPaymentCompletion:(NSString *)resultString {
    NSLog(@"%@", resultString);
}

- (void)onPaymentCompletionWithMsg:(NSString * _Nonnull)msg {
    NSLog(@"%@", msg);
}

@end
