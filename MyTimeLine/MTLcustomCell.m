//
//  MTLcustomCell.m
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 21/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import "MTLcustomCell.h"

@implementation MTLcustomCell

@synthesize tweetLabel=_tweetLabel;
@synthesize nameLabel=_nameLabel;
@synthesize followersLabel=_followersLabel;
@synthesize rtLabel=_rtLabel;
@synthesize nickLabel=_nickLabel;
@synthesize staticFlwLabel=_staticFlwLabel;
@synthesize profileImg=_profileImg;
@synthesize rtImg=_rtImg;

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
