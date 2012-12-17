//
//  ContactUsMessage.h
//  mHajj
//
//  Created by ALI AL-AWADH on 5/7/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactUsMessage : NSObject

@property   (nonatomic, copy) NSString *contactUsID;
@property   (nonatomic, copy) NSString *title; 
@property   (nonatomic, copy) NSString *message;
@property   (nonatomic, copy) NSString *date;
@property   (nonatomic, copy) NSString *reply;

@property    (nonatomic, copy) NSString *isRead;

@end
