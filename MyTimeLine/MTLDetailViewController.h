//
//  MTLDetailViewController.h
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MTLCounterDetail.h"
#import "MTLImgContainer.h"
#import "MTLTweetDetails.h"

@interface MTLDetailViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *tweet;
@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) IBOutlet UITableView *tweetTableView;


@end
