//
//  ContactUsCell.m
//  iWS
//
//  Created by ALI AL-AWADH on 5/19/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "ContactUsCell.h"
#import "CustomCellBackground.h"

@implementation ContactUsCell
@synthesize messageTitle;
@synthesize messageReply;

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

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.backgroundView = [[CustomCellBackground alloc] init];
    self.selectedBackgroundView = [[CustomCellBackground alloc] init];
    ((CustomCellBackground *)self.selectedBackgroundView).selected = YES;
    self.frame = CGRectMake(5.0, 5.0, 200.0, 35.0);
    
    return self;
}

@end
