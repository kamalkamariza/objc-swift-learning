//
//  YapdbVC.m
//  SelfLearning
//
//  Created by weeclicks on 10/04/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "YapdbVC.h"
#import <YapDatabase.h>

NSString *const testKey1 = @"Key1";
NSString *const testKey2 = @"Key2";
NSString *const testKey3 = @"Key3";

NSString *const collection1 = @"Collection1";
NSString *const collection2 = @"Collection2";
NSString *const collection3 = @"Collection3";


@interface YapdbVC ()
{
    YapDatabase *db;
    YapDatabaseConnection *conn;
    UITextField *tf;
    UITextField *tf2;
    UITextField *tf3;

}
@end

@implementation YapdbVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Yapdatabase";
    [self initButtons];
    [self initDb];
    
    
}

-(void) initDb{
    db = [[YapDatabase alloc]initWithPath:@"/Users/weeclicks/Documents/Kamal/YapDb/db"];
    conn = [db newConnection];
}

-(void)initButtons{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Set Object" forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(100, 500, 80, 20);
    [button addTarget:self action:@selector(setObject:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Get Object" forState:UIControlStateNormal];
    [button2 sizeToFit];
    button2.frame = CGRectMake(100, 600, 80, 20);
    [button2 addTarget:self action:@selector(getObject:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    tf = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, 250, 100)];
    tf.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tf];
    
    tf2 = [[UITextField alloc]initWithFrame:CGRectMake(30, 200, 250, 100)];
    tf2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tf2];
    
    tf3 = [[UITextField alloc]initWithFrame:CGRectMake(30, 300, 250, 100)];
    tf3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tf3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)setObject:(id)sender{
    [conn readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction setObject:@"Hello" forKey:testKey1 inCollection:collection1];
        [transaction setObject:@"Im" forKey:testKey2 inCollection:collection2];
        [transaction setObject:@"Kamal" forKey:testKey3 inCollection:collection3];

    }];
    NSLog(@"Set");
}

-(IBAction)getObject:(id)sender{
    __block NSMutableString *temp = [[NSMutableString alloc]init];
    __block NSMutableString *temp2 = [[NSMutableString alloc]init];
    __block NSMutableString *temp3 = [[NSMutableString alloc]init];

    [conn readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        temp = [transaction objectForKey:testKey1 inCollection:collection1];
        temp2 = [transaction objectForKey:testKey2 inCollection:collection2];
        temp3 = [transaction objectForKey:testKey3 inCollection:collection3];
        tf.text = temp;
        tf2.text = temp2;
        tf3.text = temp3;

    }];
    NSLog(@"Get");
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
