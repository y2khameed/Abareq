//
//  NewsComments.h
//  mHajj
//
//  Created by ALI AL-AWADH on 4/28/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVars.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
//#import "JSON.h"
#import "CommentsDetails.h"
#import "Constants.h"

@interface NewsComments : UIViewController
{
    NSString *nTittle;
    NSString *nID;
    
    IBOutlet UIWebView * commentsView;
}

@property (nonatomic, retain) NSString * nTittle;
@property (nonatomic, retain) NSString * nID;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *commentsText;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *JsonCode;


@property (nonatomic, retain) NSMutableArray * CommentsCollection;

// 1 : Get Comments
// 2 : Post New Comment

@property (nonatomic) int requestNumber;


- (IBAction)btnHideCommentsClicked:(id)sender;
- (IBAction)btnAddComments:(id)sender;

- (void) displayComments;
- (void) saveComments;
-(void) getCommentsFromSql;

@end
