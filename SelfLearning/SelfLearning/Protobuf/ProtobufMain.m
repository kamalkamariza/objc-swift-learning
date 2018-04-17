//
//  ProtobufMain.m
//  SelfLearning
//
//  Created by weeclicks on 17/04/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "ProtobufMain.h"
#import "Profiles.pbobjc.h"

@interface ProtobufMain ()
{
    int i;
    Contacts *contact;
    Chat *chat;
}
@end

@implementation ProtobufMain

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Protobuf";
    self.view.backgroundColor = [UIColor whiteColor];
    i = 0;
    
    [self initBtns];
    
    contact = [[Contacts alloc]init];
    chat = [[Chat alloc]init];

}

-(void)initBtns{
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [getBtn setTitle:@"Get Object" forState:UIControlStateNormal];
    [getBtn sizeToFit];
    getBtn.frame = CGRectMake(100, 200, 80, 20);
    [getBtn addTarget:self action:@selector(getObject:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [setBtn setTitle:@"Set Object" forState:UIControlStateNormal];
    [setBtn sizeToFit];
    setBtn.frame = CGRectMake(100, 400, 80, 20);
    [setBtn addTarget:self action:@selector(setObject:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
    
    UIButton *getAll = [UIButton buttonWithType:UIButtonTypeSystem];
    [getAll setTitle:@"Get All" forState:UIControlStateNormal];
    [getAll sizeToFit];
    getAll.frame = CGRectMake(100, 600, 80, 20);
    [getAll addTarget:self action:@selector(getAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAll];
}

-(IBAction)setObject:(id)sender{
    Person *a = [[Person alloc]init];
    Text *aText = [[Text alloc]init];
    
    NSLog(@"Set");
    
    switch (i) {
        case 0:
        {
            NSLog(@"i %d", i);
            a.name = @"Kamal";
            a.phoneNumber = @"123";
            aText.message = @"Hi There";
            i++;
            contact.peopleArray[i] = a;
            chat.messagesArray[i] = aText;
            break;
        }
            
        case 1:
        {
            NSLog(@" i %d", i);
            a.name = @"Ahmad";
            a.phoneNumber = @"456";
            aText.message = @"Heyy";
            i++;
            contact.peopleArray[i] = a;
            chat.messagesArray[i] = aText;
            break;
        }
            
        case 2:
        {
            NSLog(@"i %d", i);
            a.name = @"Mam";
            a.phoneNumber = @"789";
            aText.message = @"How you doin";
            i=0;
            contact.peopleArray[i] = a;
            chat.messagesArray[i] = aText;
            break;
        }
            
        default:
            break;
    }
}

-(IBAction)getObject:(id)sender{
    NSLog(@"Get");
}

-(IBAction)getAll:(id)sender{
    
    NSLog(@"Get All");
    NSLog(@"%lu %lu", (unsigned long)contact.peopleArray_Count, (unsigned long)chat.messagesArray_Count);
    
    for(int i =0; i<contact.peopleArray_Count;i++){
//        if(contact.peopleArray[i].hasName){
            NSLog(@"person %d %@",i,contact.peopleArray[i]);
            NSLog(@"message %d %@",i, chat.messagesArray[i]);

//        } else{
//            NSLog(@"Empty");
//        }
        
        
    }
    
//    for(int j=0; j<chat.messagesArray_Count; j++){
//        //            if(chat.messagesArray[j].hasMessage){
//        NSLog(@"message %d %@",j, chat.messagesArray[j]);
//        //            } else {
//        //                NSLog(@"No Message");
//        //            }
//
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
