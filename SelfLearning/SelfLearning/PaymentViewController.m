//
//  PaymentViewController.m
//  SelfLearning
//
//  Created by kamal on 18/09/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "PaymentViewController.h"
#import <PassKit/PassKit.h>
#import <BraintreeUI.h>
#import <BraintreeCore.h>
#import <BraintreeDropIn.h>

static NSArray *NetworkArray = nil;

NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiI0MjQ0OTY5YmFkMTNmMTdmZTk1ZjFiNGE5ZGZkMDQwOTAzNTgyMGJiNjFjZDkyNDgwNTc3M2FiMGRkN2UyNzQ5fGNyZWF0ZWRfYXQ9MjAxOC0wOS0xOFQwNjo0OTozMy42NTk4MTU5NTErMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgifSwiY2hhbGxlbmdlcyI6W10sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy8zNDhwazljZ2YzYmd5dzJiL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";

@interface PaymentViewController () <PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NetworkArray = @[PKPaymentNetworkVisa,PKPaymentNetworkMasterCard,PKPaymentNetworkAmex,PKPaymentNetworkDiscover];
    
    self.navigationItem.title = @"Payment";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Apple Pay" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(100, 100, 80, 20);
    [button addTarget:self action:@selector(applePay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"Braintree Pay" forState:UIControlStateNormal];
    [button1 sizeToFit];
    button1.frame = CGRectMake(100, 250, 80, 20);
    [button1 addTarget:self action:@selector(brainTreePay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
//    button.hidden = [PKPaymentAuthorizationViewController canMakePayments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)applePay:(id)sender{
    PKPaymentRequest *request = [[PKPaymentRequest alloc]init];
    request.supportedNetworks = NetworkArray;
    request.merchantIdentifier = @"com.Kamal.SelfLearning";
    request.merchantCapabilities = PKMerchantCapabilityDebit;
    request.countryCode = @"MY";
    request.currencyCode = @"MYR";
    request.requiredShippingContactFields = [NSSet setWithObjects:PKContactFieldName,PKContactFieldPhoneNumber,PKContactFieldEmailAddress, nil];
    NSDecimalNumber *item1Price = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:51.00f] decimalValue]];
    NSDecimalNumber *item2Price = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:20.00f] decimalValue]];

    request.paymentSummaryItems = @[
                                    [PKPaymentSummaryItem summaryItemWithLabel:@"Phone" amount:item1Price],
                                    [PKPaymentSummaryItem summaryItemWithLabel:@"Casing" amount:item2Price],
                                    [PKPaymentSummaryItem summaryItemWithLabel:@"TOTAL" amount:[item1Price decimalNumberByAdding:item2Price]]
                                    ];
    
    PKPaymentAuthorizationViewController *controller = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)brainTreePay:(id)sender{
    BTDropInRequest *request = [[BTDropInRequest alloc]init];
    BTDropInController *dropInVC = [[BTDropInController alloc]initWithAuthorization:clientToken request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error");
        } else if(result.isCancelled){
            NSLog(@"Cancelled");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Resume");
        }
    }];
    [self presentViewController:dropInVC animated:YES completion:nil];
}

# pragma mark - Delegate

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSLog(@"Authorized");
    NSLog(@"%@", [payment.token description]);
    completion(PKPaymentAuthorizationStatusSuccess);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
