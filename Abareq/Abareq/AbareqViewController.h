//
//  AbareqViewController.h
//  Abareq
//
//  Created by ALI AL-AWADH on 8/26/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface AbareqViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bannerImage;
@property (nonatomic, assign) BOOL reLoad;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnEnableNotification;



- (IBAction)btnAboutClicked:(id)sender;
- (IBAction)btnAboutUsClicked:(id)sender;
- (IBAction)btnSettingsClicked:(id)sender;

- (IBAction)btnContactUsClicked:(id)sender;
- (IBAction)btnEnableNotificationClicked:(id)sender;

- (IBAction)btn1Clicked:(id)sender;
- (IBAction)btn2Clicked:(id)sender;
- (IBAction)btn3Clicked:(id)sender;
- (IBAction)btn4Clicked:(id)sender;
- (IBAction)btn5Clicked:(id)sender;
- (IBAction)btn6Clicked:(id)sender;
- (IBAction)btn7Clicked:(id)sender;
- (IBAction)btn8Clicked:(id)sender;
- (IBAction)btn9Clicked:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn1Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn2Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn3Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn4Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn5Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn6Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn7Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn8Lbl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *btn9Lbl;

- (IBAction)btnEmailUs:(id)sender;
- (void) SaveFileFromURL:(NSString *) theURL ResultFileName: (NSString *) rFile;
- (void) getBanners;
- (void) getAllNews;
- (void) getDeletedNews;
- (void) updateCountLabels;

- (void) updateStuff;

- (void) updateLabels;

- (NSString *) getCurrentNotificationStatus;

- (NSString *) getDeviceToke;
@end
