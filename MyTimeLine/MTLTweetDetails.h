//
//  MTLTweetDetails.h
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 24/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLTweetDetails : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tweetLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImg;

@end
