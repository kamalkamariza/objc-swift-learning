//
//  APIViewController.m
//  SelfLearning
//
//  Created by kamal on 15/05/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "APIViewController.h"
#import <AFNetworking.h>

@interface APIViewController ()
{
    NSData *image1;
}
@end

@implementation APIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"API";
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"GET" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(100, 100, 80, 20);
    [button addTarget:self action:@selector(get:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"POST" forState:UIControlStateNormal];
    [button2 sizeToFit];
    button2.frame = CGRectMake(100, 200, 80, 20);
    [button2 addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    image1 = UIImageJPEGRepresentation([UIImage imageNamed:@"a"],0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)get:(id)sender{
    
}

-(IBAction)post:(id)sender{
    NSURL *url = [NSURL URLWithString:@"https://api.imgur.com/3/image"];
    NSDictionary *params = @{};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:url.absoluteString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:image1 name:@"1" fileName:@"1.jpg" mimeType:@"image/jpeg"];
    } error:nil];

    [request setValue:@"Client-ID 51954340d7fd962" forHTTPHeaderField:@"Authorization"];
    [request addValue:@"imaje/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager uploadTaskWithRequest:request fromData:image1 progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"Progress %@", uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"response %@", response);
        NSLog(@"response object %@", responseObject);
        NSLog(@"error %@", error);
    }];
    [uploadTask resume];
    
//    NSString *username = [TSAccountManager username];
//    NSData *basicAuthCredentials = [[NSString stringWithFormat:@"%@:%@", username, [TSStorageManager serverAuthToken]] dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
//    [request setValue:[NSString stringWithFormat:@"Basic %@", base64AuthCredentials] forHTTPHeaderField:@"Authorization"];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"Client-ID 1164304b9720392" forHTTPHeaderField:@"Authorization"];
    
//    request.HTTPBody = image1;
    
//    [manager POST:url.absoluteString
//       parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:image1
//                                    name:@"1"
//                                fileName:@"1.jpg" mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"Progress %@", uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"task %@", task);
//        NSLog(@"response object %@", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"task %@", task);
//        NSLog(@"error %@", error);
//    }];
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if(data){
//            NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSLog(@"Data %@", json);
//        }
//
//        if(response){
//            NSLog(@"Response %@", response);
//        }
//
//        if(error){
//            NSLog(@"Error %@", error);
//        }
//    }] resume];
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
