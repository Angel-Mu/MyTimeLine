//
//  MTLSesions.h
//  MyTimeLine
//
//  Created by Angel Malavar on 03/03/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import "MTLMasterViewController.h"

@interface MTLSesions : UITableViewController

    @property (strong, nonatomic) IBOutlet UITableView *sesionsTable;
    @property (strong, nonatomic) NSArray *dataSource;

@end
