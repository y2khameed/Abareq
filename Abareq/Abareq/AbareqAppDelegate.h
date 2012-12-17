//
//  AbareqAppDelegate.h
//  Abareq
//
//  Created by ALI AL-AWADH on 8/26/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AbareqViewController;

@interface AbareqAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) AbareqViewController *viewController;

@property (strong, nonatomic) UINavigationController * navController;

@property (nonatomic, retain) NSString * token;

- (NSString *) getCurrentNotificationStatus;

- (void) saveDeviceToken: (NSString *) udid token:(NSString *)mToken;
@end
