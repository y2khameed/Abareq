//
//  NewsInfo.h
//  iWS
//
//  Created by ALI AL-AWADH on 5/19/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsInfo : NSObject

@property (nonatomic, copy) NSString *newsID;
@property (nonatomic, copy) NSString *newsDate;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsbody;
@property (nonatomic, copy) NSString *newsImage;
@property (nonatomic, copy) NSString *isRead;


@end
