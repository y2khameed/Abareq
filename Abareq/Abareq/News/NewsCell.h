//
//  NewsCell.h
//  iWS
//
//  Created by ALI AL-AWADH on 5/19/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsBody;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *newsIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *newsDate;

@end
