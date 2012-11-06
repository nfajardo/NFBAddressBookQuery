//
//  FirstViewController.m
//  AddressBookQueries
//
//  Created by Nelson Fajardo on 6/11/12.
//  Copyright (c) 2012 Belmont Studio. All rights reserved.
//

#import "AddressBookViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddressBookViewController ()

@end

@implementation AddressBookViewController
@synthesize table;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Address Book", @"General");
        self.tabBarItem.image = [UIImage imageNamed:@"address"];
        contacts = [[NSMutableArray alloc] init];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    filterType = NSAdressBookFilterMails;
    [self getAllContactsInAddressBoook];


 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getAllContactsInAddressBoook
{
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        // Do whatever you want here.
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
        CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
        
        for ( int i = 0; i < nPeople; i++ )
        {
            ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
            [contacts addObject:ref];
            
        }
    }
    

}
#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contacts count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *mail = nil;
    NSString *name = ( NSString*)ABRecordCopyValue([contacts objectAtIndex:indexPath.row],kABPersonFirstNameProperty);
    NSString *lastname = ( NSString*)ABRecordCopyValue([contacts objectAtIndex:indexPath.row],kABPersonLastNameProperty);
    ABMultiValueRef mails = (NSString*)ABRecordCopyValue([contacts objectAtIndex:indexPath.row], kABPersonEmailProperty);
    if (ABMultiValueGetCount(mails) > 0) {
        mail = (NSString*) ABMultiValueCopyValueAtIndex(mails, 0);
    } else {
        mail = @"[None]";
    }
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue([contacts objectAtIndex:indexPath.row], kABPersonPhoneProperty);
    
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (NSString*) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",name,(lastname==nil)?@"":lastname];
    if(filterType==NSAdressBookFilterMails)
        cell.detailTextLabel.text = mail;
    else if(filterType==NSAdressBookFilterPhones)
        cell.detailTextLabel.text = phone;
    else if(filterType==NSAdressBookFilterAll)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",mail,phone] ;
    
    return cell;
}
#pragma mark - Segment Action
-(IBAction)segmentChangeValue:(id)sender
{
    UISegmentedControl *control = sender;
    
    if([control selectedSegmentIndex]==0)
    {
        filterType = NSAdressBookFilterMails;
    }
    else if([control selectedSegmentIndex]==1)
    {
        filterType = NSAdressBookFilterPhones;
    }
    else
    {
        filterType = NSAdressBookFilterAll;
    }
    
    [table reloadData];

}



@end
