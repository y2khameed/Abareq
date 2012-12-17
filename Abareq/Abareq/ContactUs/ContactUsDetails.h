//
//  ContactUsDetails.h
//  mHajj
//
//  Created by ALI AL-AWADH on 5/25/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsDetails : UIViewController
{
    NSString *htmlCode;
}

@property (unsafe_unretained, nonatomic) NSString *htmlCode;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewController;

@end
