//
//  SettingView.h
//  Abareq
//
//  Created by ALI AL-AWADH on 9/9/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblEnable;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblDisable;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnEnableNotification;


- (IBAction)btnEnableNotificationClicked:(id)sender;
- (IBAction)btnBackClicked:(id)sender;

- (void) updateLabels;

- (NSString *) getCurrentNotificationStatus;

- (NSString *) getDeviceToke;

@end
