//
//  MTLcustomCell.h
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLcustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *tweetLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *followersLabel;
@property (nonatomic, weak) IBOutlet UILabel *rtLabel;
@property (nonatomic, weak) IBOutlet UILabel *nickLabel;
@property (nonatomic, weak) IBOutlet UILabel *staticFlwLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImg;
@property (nonatomic, weak) IBOutlet UIImageView *rtImg;

@end
