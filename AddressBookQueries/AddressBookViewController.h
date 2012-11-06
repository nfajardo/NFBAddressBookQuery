//
//  AddressBookViewController.h
//  AddressBookQueries
//
//  Created by Nelson Fajardo on 6/11/12.
//  Copyright (c) 2012 Belmont Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellHeight             44

enum {
    NSAdressBookFilterMails,
    NSAdressBookFilterPhones,
    NSAdressBookFilterAll,

};
typedef NSUInteger NSAdressBookFilterType;


@interface AddressBookViewController : UIViewController
{
    NSMutableArray *contacts ;
    NSAdressBookFilterType filterType;
}

@property(nonatomic,retain) IBOutlet UITableView *table;

@end
