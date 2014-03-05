//
//  MTLCounterDetail.m
//  MyTimeLine
//
//  Created by Desarrollo Morelosoft on 24/02/14.
//  Copyright (c) 2014 Desarrollo Morelosoft. All rights reserved.
//

#import "MTLCounterDetail.h"

@implementation MTLCounterDetail

@synthesize staticFav=_staticFav;
@synthesize staticRT=_staticRT;
@synthesize rtLabel=_rtLabel;
@synthesize favLabel=_favLabel;

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
