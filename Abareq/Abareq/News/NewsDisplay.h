//
//  NewsDisplay.h
//  iWS
//
//  Created by ALI AL-AWADH on 5/30/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsComments.h"

@interface NewsDisplay : UIViewController
{
    NSString * TheSQL;
    NSString * TheString;
    NSString * nID;
    NSString * sID;
    IBOutlet UIWebView * txtView;
}
@property (weak, nonatomic) IBOutlet UIButton *btnBanner;

@property (nonatomic, retain) NSString * TheSQL;
@property (nonatomic, retain) NSString * TheString;
@property   (nonatomic, retain) NSString * nID;
@property   (nonatomic, retain) NSString * sID;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bannerImage;

- (IBAction) butCloseClick:(id) sender;

- (IBAction) butSize01Click:(id) sender;

- (IBAction)btnShowCommentsClicked:(id)sender;
- (IBAction)btnFullURLClicked:(id)sender;

- (IBAction)btnNextClicked:(id)sender;
- (IBAction)btnPrevClicked:(id)sender;
- (IBAction)btnCopyClicked:(id)sender;
- (IBAction)btnDeleteClicked:(id)sender;


- (void) saveReadNews: (NSString *) newsId;
- (void) getBanners;

@end
