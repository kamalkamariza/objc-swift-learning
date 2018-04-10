//
//  ContactMainViewController.m
//  SelfLearning
//
//  Created by Ahmad Kamal on 01/04/2018.
//  Copyright © 2018 Kamal. All rights reserved.
//

#import "ContactMainViewController.h"
#import "ContactsTableViewController.h"
#import <AddressBook/AddressBook.h>

@interface ContactMainViewController ()

@end

@implementation ContactMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Contacts";
    
    //CN Contact
    UIButton *createbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [createbutton setTitle:@"Create Contacts" forState:UIControlStateNormal];
    [createbutton sizeToFit];
    createbutton.frame = CGRectMake(100, 100, 150, 20);
    [createbutton addTarget:self action:@selector(createContact:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createbutton];
    
    UIButton *getbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [getbutton setTitle:@"Get Contacts" forState:UIControlStateNormal];
    [getbutton sizeToFit];
    getbutton.frame = CGRectMake(100, 200, 100, 20);
    [getbutton addTarget:self action:@selector(getContacts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getbutton];
    
    //AddressBook Contact
    UIButton *abfContact = [UIButton buttonWithType:UIButtonTypeSystem];
    [abfContact setTitle:@"Create Contacts ABF" forState:UIControlStateNormal];
    [abfContact sizeToFit];
    abfContact.frame = CGRectMake(100, 300, 150, 20);
    [abfContact addTarget:self action:@selector(createABF:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:abfContact];
    
    UIButton *getABF = [UIButton buttonWithType:UIButtonTypeSystem];
    [getABF setTitle:@"Get Contacts ABF" forState:UIControlStateNormal];
    [getABF sizeToFit];
    getABF.frame = CGRectMake(100, 400, 150, 20);
    [getABF addTarget:self action:@selector(getABF:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getABF];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createABF:(id)sender{
    
}

-(IBAction)getABF:(id)sender{
    [self getPersonOutOfAddressBook];
}

-(IBAction)createContact:(id)sender{
//    CNContactStore *store = [[CNContactStore alloc] init];
//
//    // create contact
//
//    CNMutableContact *contact = [[CNMutableContact alloc] init];
//    contact.familyName = @"Smith";
//    contact.givenName = @"Jane";
//
//    CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:[CNPhoneNumber phoneNumberWithStringValue:@"301-555-1212"]];
//    contact.phoneNumbers = @[homePhone];
//
//    CNContactViewController *controller = [CNContactViewController viewControllerForUnknownContact:contact];
//    controller.contactStore = store;
//    controller.delegate = self;
//    controller.navigationItem.title = @"Edited Contacts";
//
//    [self.navigationController pushViewController:controller animated:TRUE];
    
    //2nd
//    CNContactStore *store = [[CNContactStore alloc] init];
//    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!granted) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // user didn't grant access;
//                // so, again, tell user here why app needs permissions in order  to do it's job;
//                // this is dispatched to the main queue because this request could be running on background thread
//            });
//            return;
//        }
//
//        // create contact
//
//        CNMutableContact *contact = [[CNMutableContact alloc] init];
//        contact.familyName = @"Doe";
//        contact.givenName = @"John Test";
//
//        CNLabeledValue *homePhone = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:[CNPhoneNumber phoneNumberWithStringValue:@"312-555-1212"]];
//        contact.phoneNumbers = @[homePhone];
//
//        CNSaveRequest *request = [[CNSaveRequest alloc] init];
//        [request addContact:contact toContainerWithIdentifier:nil];
//
//        // save it
//
//        NSError *saveError;
//        if (![store executeSaveRequest:request error:&saveError]) {
//            NSLog(@"error = %@", saveError);
//        }
//    }];
    
    CNContactViewController *addContactVC = [CNContactViewController viewControllerForNewContact:nil];
    addContactVC.delegate=self;
    UINavigationController *navController   = [[UINavigationController alloc] initWithRootViewController:addContactVC];
    [self presentViewController:navController animated:NO completion:nil];
    
//    ContactsTableViewController *destVC = [[ContactsTableViewController alloc]init];
//    [self.navigationController pushViewController:destVC animated:YES];
}

-(IBAction)getContacts:(id)sender{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                for (CNContact *contact in cnContacts) {
                    //store all the contacts as per your requirement
                    NSLog(@"Id %@",contact.identifier);//the contact id which you want
                    NSLog(@"Name %@",contact.givenName);
                }
            }
        }
    }];
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil) {
        NSLog(@"Succesful.");
        
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //3
        NSUInteger i = 0; for (i = 0; i < [allContacts count]; i++)
        {
//            Person *person = [[Person alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];

            //4
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,
                                                                                  kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            NSLog(@"%@", fullName);

//            person.firstName = firstName; person.lastName = lastName;
//            person.fullName = fullName;

            //email
            //5
//            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);

//            //6
//            NSUInteger j = 0;
//            for (j = 0; j < ABMultiValueGetCount(emails); j++) {
//                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
//                if (j == 0) {
//                    person.homeEmail = email;
//                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
//                }
//                else if (j==1) person.workEmail = email;
//            }
//
//            //7
//            [self.tableData addObject:person];
        }
        
        //8
        CFRelease(addressBook);
    } else {
        //9
        NSLog(@"Error reading Address Book");
    }
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
