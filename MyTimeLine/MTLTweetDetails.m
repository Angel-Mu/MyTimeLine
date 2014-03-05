//
//  MTLTweetDetails.m
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 24/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import "MTLTweetDetails.h"

@implementation MTLTweetDetails
@synthesize tweetLabel=_tweetLabel;
@synthesize nameLabel=_nameLabel;
@synthesize dateLabel=_dateLabel;
@synthesize nickLabel=_nickLabel;
@synthesize profileImg=_profileImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
