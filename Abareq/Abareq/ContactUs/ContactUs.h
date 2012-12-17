//
//  ContactUs.h
//  mHajj
//
//  Created by ALI AL-AWADH on 5/2/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVars.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ContactUsMessage.h"
#import "Constants.h"

@interface ContactUs : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    //UITextField *txtMessageSubject;
    //UITextField *txtMessageBody;
    BOOL keyboardIsShown;
}
@property (strong, nonatomic) IBOutlet UITableView *contactUsMessagesTable;
// 1 : Send Message
// 2 : Get Messages
// 3 : Get Message Details 

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;
@property (nonatomic) int requestNumber;

@property (nonatomic, retain) NSMutableArray * contactUsMessageCollection;
@property (nonatomic, retain) NSMutableArray * readMessageCollection;

@property (strong, nonatomic) IBOutlet UILabel *lblResult;
@property (strong, nonatomic) IBOutlet UIButton *btnContactUsMsg;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UILabel *lblBody;
@property (strong, nonatomic) IBOutlet UILabel *lblSubject;
@property (strong, nonatomic) IBOutlet UILabel *lblContactUsHeader;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnSearchClicked:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtMessageSubject;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtName;


@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnClose;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *viewNewMessage;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *txtViewBody;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtEmail;


@property (nonatomic, copy) NSString * mID;
@property (nonatomic, copy) NSString * mType;

- (IBAction)btnBackClicked:(id)sender;
- (IBAction)btnSendMessageClicked:(id)sender;
//- (IBAction)HideKeyboard:(id)sender;
- (IBAction)showMsgClick:(id)sender;
//- (IBAction)btnContactUsClicked:(id)sender;
- (IBAction)btnCloseClicked:(id)sender;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)btnHideKeyboardClicked:(id)sender;
- (IBAction)btnNewMessageClicked:(id)sender;

- (void) displayMessages;
- (void) saveMessages;
- (void) getContactUsMessages;
- (void) getReadMessages;

- (void) getContactUsMessagesFromSQL;
- (void) getContactUsMessagesFromSQL:(NSString *)searchKey;


@end
