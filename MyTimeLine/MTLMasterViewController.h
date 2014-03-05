//
//  MTLMasterViewController.h
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#include <QuartzCore/QuartzCore.h>
#include "MTLTweetCell.h"
#import "SVProgressHUD.h"

@interface MTLMasterViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong,nonatomic) ACAccount *twitterAccount;
- (IBAction)postMessage:(id)sender;

@end
