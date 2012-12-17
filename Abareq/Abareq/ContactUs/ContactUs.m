//
//  ContactUs.m
//  mHajj
//
//  Created by ALI AL-AWADH on 5/2/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "ContactUs.h"
#import "ContactUsCell.h"
#import "ContactUsDetails.h"
#import "MBProgressHUD.h"

static NSString *const ContactUsCellIdentifier = @"ContactUsCell";
static NSString *const ContactUsCellUIdentifier = @"ContactUsCellU";
static NSString *const NothingFoundCellIdentifier = @"NoContactUsMessagesFound";

@interface ContactUs ()
//@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ContactUs


//@synthesize tableView = _tableView;
@synthesize contactUsMessagesTable = _contactUsMessagesTable;
@synthesize lblResult;
@synthesize btnContactUsMsg;

@synthesize btnSend;
@synthesize lblBody;
@synthesize lblSubject;
@synthesize lblContactUsHeader;
@synthesize scrollView;
@synthesize txtMessageSubject;
@synthesize txtName;
@synthesize btnClose;
@synthesize viewNewMessage;
@synthesize txtViewBody;
@synthesize txtEmail;
@synthesize contactUsMessageCollection;
@synthesize readMessageCollection;

@synthesize txtSearch;
@synthesize requestNumber;
//to be used in push
@synthesize mID;
//to be used in push
@synthesize mType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{ 
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //first load is on send ContactUs
    //btnContactUs.enabled = FALSE;
    //requestNumber = 1;
    // Do any additional setup after loading the view from its nib.
    
    //define custome table cell
    UINib *cellNib = [UINib nibWithNibName:ContactUsCellIdentifier bundle:nil];
    [_contactUsMessagesTable registerNib:cellNib forCellReuseIdentifier:ContactUsCellIdentifier];
    
    cellNib = [UINib nibWithNibName:ContactUsCellUIdentifier bundle:nil];
    [_contactUsMessagesTable registerNib:cellNib forCellReuseIdentifier:ContactUsCellUIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [_contactUsMessagesTable registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    _contactUsMessagesTable.rowHeight = 80;

    contactUsMessageCollection = [[NSMutableArray alloc] init];
    
    readMessageCollection = [[NSMutableArray alloc] init];
    
    NSLog(@"localeIdentifier: %@", [[NSLocale preferredLanguages] objectAtIndex:0] );
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"]) {
        [txtName setTextAlignment:UITextAlignmentRight]; 
        [txtMessageSubject setTextAlignment:UITextAlignmentRight]; 
        [txtViewBody setTextAlignment:UITextAlignmentRight]; 
    }
    else if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ar"])
    {
        [txtName setTextAlignment:UITextAlignmentLeft];
        [txtMessageSubject setTextAlignment:UITextAlignmentLeft];
        [txtViewBody setTextAlignment:UITextAlignmentLeft];
    }
    
    [self getReadMessages];
    
    
    
}

- (void)viewDidUnload
{
    [self setTxtMessageSubject:nil];
    [self setScrollView:nil];
    [self setLblContactUsHeader:nil];
    [self setLblSubject:nil];
    [self setLblBody:nil];
    [self setBtnSend:nil];
    [self setBtnContactUsMsg:nil];
    [self setLblResult:nil];
    [self setContactUsMessagesTable:nil];
    [self setBtnClose:nil];
    [self setViewNewMessage:nil];
    [self setTxtViewBody:nil];
    [self setTxtEmail:nil];
    [self setTxtName:nil];
    [self setTxtSearch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[self contactUsMessageCollection] removeAllObjects];
}

-(void) viewWillAppear:(BOOL)animated 
{
}

bool conatactfirstLoad = TRUE;
- (void) viewDidAppear:(BOOL)animated
{
    if (conatactfirstLoad) 
    {
            // Start hud
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"جاري تحميل الرسائل...";

        
        conatactfirstLoad = FALSE;
        
        [self getContactUsMessages];
        
   
    }
}

-(void) viewWillDisappear:(BOOL)animated {
   }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return  NO;
}


#pragma mark - Buttin Actions
- (IBAction)btnBackClicked:(id)sender 
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

//Add new Contact US Message
- (IBAction)btnSendMessageClicked:(id)sender 
{
    if ([txtEmail.text length] >0 && [txtMessageSubject.text length]>0 && [txtName.text length]>0 && [txtViewBody.text length] >0) {
        // Start hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"جاري إرسال الرسالة...";
        
        UIDevice *device = [UIDevice currentDevice];
        NSString *uniqueIdentifier = [device uniqueIdentifier];
        //For testing simulator use my device ID 
        if ([[device model] isEqualToString:@"iPhone Simulator"] ) {
            uniqueIdentifier = @"73967c9358810459bfe0f1a900581b0993e487be";
        }
        //NSDate *now = [[NSDate alloc] init];
        //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // NSString *dateString = [dateFormatter stringFromDate:now];
        
        NSURL *url = [NSURL URLWithString:URL_ADD_MESSAGE];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:uniqueIdentifier forKey:@"deviceId"];
        [request setPostValue:[txtMessageSubject text] forKey:@"title"];
        [request setPostValue:[txtViewBody text] forKey:@"message"];
        [request setPostValue:[txtEmail text] forKey:@"email"];
        [request setPostValue:[txtName text] forKey:@"name"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"يجب تعبئة جميع الحقول"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"إغلاق"];
        [alert show];
    }
    
    
}

//Load Contact Us Messages From Server
- (void) getContactUsMessages
{
    [contactUsMessageCollection removeAllObjects];
    requestNumber = 2;
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    
    //For testing simulator use my device ID 
    if ([[device model] isEqualToString:@"iPhone Simulator"] ) {
        uniqueIdentifier = @"73967c9358810459bfe0f1a900581b0993e487be";
    }
    
    NSURL *url = [NSURL URLWithString:URL_GET_MESSAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:uniqueIdentifier forKey:@"deviceId"];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (IBAction)showMsgClick:(id)sender {
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل الرسائل...";
    /*
    txtMessageBody.hidden = TRUE;
    txtMessageSubject.hidden = TRUE;
    lblBody.hidden = TRUE;
    lblContactUsHeader.hidden = TRUE;
    lblSubject.hidden = TRUE;
    btnSend.hidden = TRUE;
    btnContactUs.enabled = TRUE;
    btnContactUsMsg.enabled = FALSE;
    lblResult.hidden = FALSE;
    _contactUsMessagesTable.hidden = FALSE;
     */
    
    [self getContactUsMessages];
    }

//- (IBAction)btnContactUsClicked:(id)sender {
    
    /*
    txtMessageBody.hidden = FALSE;
    txtMessageSubject.hidden = FALSE;
    lblBody.hidden = FALSE;
    lblContactUsHeader.hidden = FALSE;
    lblSubject.hidden = FALSE;
    btnSend.hidden = FALSE;
    btnContactUs.enabled = FALSE;
    btnContactUsMsg.enabled = TRUE;
    lblResult.hidden = TRUE;
    _contactUsMessagesTable.hidden = TRUE;
     */
    
  //  btnClose.hidden = FALSE;
   // viewNewMessage.hidden = FALSE;
    
    //requestNumber = 1;
//}


- (IBAction)btnNewMessageClicked:(id)sender {
    btnClose.hidden = FALSE;
    viewNewMessage.hidden = FALSE;
    
    requestNumber = 1;

}

- (IBAction)btnCloseClicked:(id)sender 
{
    
    btnClose.hidden = TRUE;
    viewNewMessage.hidden = TRUE;
    
    requestNumber = 2;
}

- (IBAction)btnRefreshClicked:(id)sender 
{
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل الرسائل...";
    
        [self getReadMessages];
        [self getContactUsMessages];

}

- (IBAction)btnHideKeyboardClicked:(id)sender 
{
    [txtViewBody resignFirstResponder];
    [txtMessageSubject resignFirstResponder];
}

- (IBAction)btnContactUsClicked:(id)sender {
        
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل الرسائل...";
    [self getReadMessages];
    [self getContactUsMessages];
}

- (IBAction)btnSearchClicked:(id)sender 
{
    if (txtSearch.hidden) 
    {
        [txtSearch setHidden:FALSE];
        [txtSearch becomeFirstResponder];
    }
    else
    {
        [txtSearch setHidden:TRUE];
        [txtSearch resignFirstResponder];
        
        
        [contactUsMessageCollection removeAllObjects];
        if ([txtSearch.text length]>2) 
        {
            [self getContactUsMessagesFromSQL:txtSearch.text];
        }
        else
        {
            [self getContactUsMessagesFromSQL];
        }
        
        [_contactUsMessagesTable reloadData];
        
    }   
}

#pragma mark - SQL Operations
- (void) saveMessages{
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    tSQL = @"DELETE FROM contactusMessages";
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
    NSLog(@"DELETING:  %@", tSQL);
    
    tSQL = @"";
    
    ContactUsMessage *currentContactUs;
    
    
    for (int i =0; i< [contactUsMessageCollection count]; i++) {
        currentContactUs = [contactUsMessageCollection objectAtIndex:i];
        
        tSQL = [ tSQL stringByAppendingFormat:@"Insert Into contactusMessages (replayText, _id, tittle, message, date) values ('%@','%@', '%@', '%@', '%@')",[currentContactUs reply],[currentContactUs contactUsID], [currentContactUs title], [currentContactUs message], [currentContactUs date]];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"Inserting:  %@", tSQL);
        
        tSQL = @"";
    }
    
}

- (void) getReadMessages
{
    [readMessageCollection removeAllObjects];
   char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@"select * FROM contactUsRead"];
    
    
    sqlite3_stmt * theStat;
    
    //tSQL = [tSQL stringByAppendingFormat: @"select * FROM contactUsRead where _id = '%@'", contactUsId];;
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [readMessageCollection addObject:[dbConnt fetchString:theStat ColID:0]];
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        [readMessageCollection addObject:[dbConnt fetchString:theStat ColID:0]];
        
    }  
}

- (void) saveReadMessage: (NSString *) contactUsId
{
    NSLog(@"ContactUs ID %@", contactUsId);
    
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    tSQL = [tSQL stringByAppendingFormat: @"select * FROM contactUsRead where _id = '%@'", contactUsId];;
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    if (sqlite3_step(theStat) != SQLITE_ROW)
    {
    
    tSQL = @"";
    
        
        tSQL = [ tSQL stringByAppendingFormat:@"Insert Into contactUsRead ( _id ) values ('%@')", contactUsId];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"Inserting:  %@", tSQL);
        
        tSQL = @"";
    }
}

- (void) getContactUsMessagesFromSQL
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@"Select * From contactusMessages order by _id DESC"];    
    //sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %i", secID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    ContactUsMessage *messageInstance = [[ContactUsMessage alloc] init];
    
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [messageInstance setContactUsID:[dbConnt fetchString:theStat ColID:1]];
        [messageInstance setDate:[dbConnt fetchString:theStat ColID:4]];
        [messageInstance setTitle:[dbConnt fetchString:theStat ColID:2]];
        [messageInstance setReply:[dbConnt fetchString:theStat ColID:0]];
        [messageInstance setMessage:[dbConnt fetchString:theStat ColID:3]];
        
        if ([readMessageCollection indexOfObject:[dbConnt fetchString:theStat ColID:1]] == NSNotFound) {
            [messageInstance setIsRead:@"0"];
        }
        else
        {
            [messageInstance setIsRead:@"1"];
        }
        
        [contactUsMessageCollection addObject:messageInstance];
        NSLog(@"ID %@ reply %@ Message %@ Date %@",[messageInstance contactUsID], [messageInstance reply], [messageInstance message], [messageInstance date]);
        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        messageInstance = [[ContactUsMessage alloc] init];
        
        [messageInstance setContactUsID:[dbConnt fetchString:theStat ColID:1]];
        [messageInstance setDate:[dbConnt fetchString:theStat ColID:4]];
        [messageInstance setTitle:[dbConnt fetchString:theStat ColID:2]];
        [messageInstance setReply:[dbConnt fetchString:theStat ColID:0]];
        [messageInstance setMessage:[dbConnt fetchString:theStat ColID:3]];
        
        if ([readMessageCollection indexOfObject:[dbConnt fetchString:theStat ColID:1]] == NSNotFound) {
            [messageInstance setIsRead:@"0"];
        }
        else
        {
            [messageInstance setIsRead:@"1"];
        }
        
        [contactUsMessageCollection addObject:messageInstance];
        
        NSLog(@"ID %@ reply %@ Message %@ Date %@",[messageInstance contactUsID], [messageInstance reply], [messageInstance message], [messageInstance date]);
        
    }   
}

- (void) getContactUsMessagesFromSQL:(NSString *)searchKey
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@"Select * From contactusMessages where (tittle like '%%%@%%' or message like '%%%@%%' or replayText like '%%%@%%') order by _id DESC", searchKey,searchKey,searchKey];    
    //sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %i", secID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    ContactUsMessage *messageInstance = [[ContactUsMessage alloc] init];
    
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [messageInstance setContactUsID:[dbConnt fetchString:theStat ColID:1]];
        [messageInstance setDate:[dbConnt fetchString:theStat ColID:4]];
        [messageInstance setTitle:[dbConnt fetchString:theStat ColID:2]];
        [messageInstance setReply:[dbConnt fetchString:theStat ColID:0]];
        [messageInstance setMessage:[dbConnt fetchString:theStat ColID:3]];
        
        if ([readMessageCollection indexOfObject:[dbConnt fetchString:theStat ColID:1]] == NSNotFound) {
            [messageInstance setIsRead:@"0"];
        }
        else
        {
            [messageInstance setIsRead:@"1"];
        }
        
        [contactUsMessageCollection addObject:messageInstance];
        NSLog(@"ID %@ reply %@ Message %@ Date %@",[messageInstance contactUsID], [messageInstance reply], [messageInstance message], [messageInstance date]);
        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        messageInstance = [[ContactUsMessage alloc] init];
        
        [messageInstance setContactUsID:[dbConnt fetchString:theStat ColID:1]];
        [messageInstance setDate:[dbConnt fetchString:theStat ColID:4]];
        [messageInstance setTitle:[dbConnt fetchString:theStat ColID:2]];
        [messageInstance setReply:[dbConnt fetchString:theStat ColID:0]];
        [messageInstance setMessage:[dbConnt fetchString:theStat ColID:3]];
        
        if ([readMessageCollection indexOfObject:[dbConnt fetchString:theStat ColID:1]] == NSNotFound) {
            [messageInstance setIsRead:@"0"];
        }
        else
        {
            [messageInstance setIsRead:@"1"];
        }
        
        [contactUsMessageCollection addObject:messageInstance];
        
        NSLog(@"ID %@ reply %@ Message %@ Date %@",[messageInstance contactUsID], [messageInstance reply], [messageInstance message], [messageInstance date]);
        
    }

}


#pragma mark - HTTP request

- (void)requestFinished:(ASIHTTPRequest *)request {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //Send New Contact Us Message
    //if (requestNumber ==1) 
    if([[request url] isEqual:[NSURL URLWithString:URL_ADD_MESSAGE]])
    {
  
        NSLog(@"No Error");
          
            // Hide keyword
        [txtMessageSubject resignFirstResponder];
        [txtEmail resignFirstResponder];
        [txtName resignFirstResponder];
        [txtViewBody resignFirstResponder];
        
            
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"تم إرسال الرسالة بنجاح: %@", [txtMessageSubject text]]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"إغلاق"];
        [alert show];
        
        // Clear text field
        [txtMessageSubject setText:@""];
       // [txtMessageBody setText:@""];
        [viewNewMessage setHidden:TRUE];
        [btnClose setHidden:TRUE];
    }
    //Get All Contact Us Messages
    //else if(requestNumber ==2)
    else if([[request url] isEqual:[NSURL URLWithString:URL_GET_MESSAGE]])
    {
        
        NSData *jsonData = [request responseData];
        
        NSError *jsonParseErro = nil;
        
        ContactUsMessage *contactUsMessage;
        if (jsonData == nil) {
            NSLog(@"ERROR");
        }
        else
        {
            if ([contactUsMessageCollection count] != 0) {
                [contactUsMessageCollection removeAllObjects];
            }
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
            
            for (int i=0; i< [jsonArray count]; i++) 
            {
                
                NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
                
                for (id key in jsonDic) {
                    NSLog(@"key: %@, value: %@", key, [jsonDic objectForKey:key]);
                } 
                contactUsMessage = [[ContactUsMessage alloc] init];
                
                [contactUsMessage setContactUsID:[jsonDic objectForKey:@"id"]];
                [contactUsMessage setTitle:[jsonDic objectForKey:@"title"]];
                [contactUsMessage setDate:[jsonDic objectForKey:@"date"]];
                [contactUsMessage setMessage:[jsonDic objectForKey:@"message"]];
                [contactUsMessage setReply:[jsonDic objectForKey:@"replayText"]];
                
                if ([readMessageCollection indexOfObject:[jsonDic objectForKey:@"id"]] == NSNotFound) {
                    [contactUsMessage setIsRead:@"0"];
                }
                else
                {
                    [contactUsMessage setIsRead:@"1"];
                }
                
                [contactUsMessageCollection addObject:contactUsMessage];   
            }   
            // save comments to SQL
            [self saveMessages];
            //display comments
            [self displayMessages];
            
            //from Push Notification
            if ([mID length]>0) {
                for (int i=0; i < [contactUsMessageCollection count]; i++) 
                {
                    @try {
                        ContactUsMessage *contactInst = [contactUsMessageCollection objectAtIndex:i];
                        
                        if ([[contactInst contactUsID] isEqualToString:mID])
                        {
                            //NSString * rString = [[NSString alloc] initWithFormat:@""];
                            NSString * rString = [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"background-color:black;font-size: 18px;text-align:justify;color:white;\"><p dir=\"rtl\"><strong>%@</strong></p><p dir=\"rtl\">%@</p><p dir=\"rtl\">%@</p><hr/><p dir=\"rtl\"><strong>الرد</strong></p><p dir=\"rtl\">%@</p></body></html>", [contactInst title], [contactInst date] ,  [contactInst message] , [contactInst reply] ];
                            NSLog(@"HTML: %@", rString);
                            
                            
                            ContactUsDetails *controller = [[ContactUsDetails alloc] initWithNibName:@"ContactUsDetails" bundle:nil];
                            controller.htmlCode = rString;
                            //[self presentViewController:controller animated:YES completion:nil];
                            
                            // [self.view addSubview:controller.view];
                            // [self addChildViewController:controller];
                            //[controller didMoveToParentViewController:self];
                            
                            [controller presentInParentViewController:self];
                            [self saveReadMessage:[contactInst contactUsID]];
                            [readMessageCollection addObject:[contactInst contactUsID]];
                            [[contactUsMessageCollection objectAtIndex:i]  setIsRead:@"1"];
                            [_contactUsMessagesTable reloadData];
                            
                            mID = NULL;
                            break;
                        }
                       
                    }
                    @catch (NSException *e) 
                    {
                        UIAlertView *alert = [[UIAlertView alloc] init];
                        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:015"]];
                        [alert setMessage:@""];
                        [alert setDelegate:self];
                        [alert addButtonWithTitle:@"حسناً"];
                        [alert show];
                        
                    }

                    
                }
            }
        }
        NSLog(@"No Error");
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    
    //if (requestNumber == 2) 
    if([[request url] isEqual:[NSURL URLWithString:URL_GET_MESSAGE]])
    {
        @try {
           
            [self getContactUsMessagesFromSQL];            
            [_contactUsMessagesTable reloadData ];
            
           
        }
        @catch (NSException *e) 
        {
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:004"]];
            [alert setMessage:@""];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"حسناً"];
            [alert show];        
        }
    }
   // else if (requestNumber == 1)
    else if([[request url] isEqual:[NSURL URLWithString:URL_ADD_MESSAGE]])
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"فشلت عملية الإرسال: %@", [txtMessageSubject text]]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"إغلاق"];
        [alert show];   
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //getMessagesFromSQL();
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
            [textField resignFirstResponder];
    
    return YES;
}


- (void) displayMessages{
    [_contactUsMessagesTable reloadData];
}

#pragma mark - Tabel View

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (contactUsMessageCollection == nil) {
        return 0;
    }
    else if([contactUsMessageCollection count] == 0)
    {
        return 1;
    }
    else
    {
        return [contactUsMessageCollection count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        NSString * rString =@"";
        
        
        rString = [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"background-color:black;font-size: 18px;text-align:justify;color:white;\"><p dir=\"rtl\"><strong>%@</strong></p><p dir=\"rtl\">%@</p><p dir=\"rtl\">%@</p><hr/><p dir=\"rtl\"><strong>الرد</strong></p><p dir=\"rtl\">%@</p></body></html>", [[contactUsMessageCollection objectAtIndex:indexPath.row] title], [[contactUsMessageCollection objectAtIndex:indexPath.row] date] ,  [[contactUsMessageCollection objectAtIndex:indexPath.row] message] , [[contactUsMessageCollection objectAtIndex:indexPath.row] reply] ];
        
        NSLog(@"HTML: %@", rString);
        
        
        ContactUsDetails *controller = [[ContactUsDetails alloc] initWithNibName:@"ContactUsDetails" bundle:nil];
        controller.htmlCode = rString;
        //[self presentViewController:controller animated:YES completion:nil];
        
       // [self.view addSubview:controller.view];
       // [self addChildViewController:controller];
        //[controller didMoveToParentViewController:self];
        
            [controller presentInParentViewController:self];
        
        [self saveReadMessage:[[contactUsMessageCollection objectAtIndex:indexPath.row] contactUsID]];
        
        [readMessageCollection addObject:[[contactUsMessageCollection objectAtIndex:indexPath.row] contactUsID]];
        [[contactUsMessageCollection objectAtIndex:indexPath.row]  setIsRead:@"1"];
        [_contactUsMessagesTable reloadData];
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:015"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
        
    }
     
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int NextItemID;
    NextItemID = indexPath.row;
    
    @try {
        
        if ([contactUsMessageCollection count] == 0) {
            return [_contactUsMessagesTable  dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
        }
        else
        {
            ContactUsCell * cell ;
            ContactUsMessage *searchResult = [contactUsMessageCollection objectAtIndex:indexPath.row];
                        
            if ([[searchResult isRead] isEqualToString:@"0"]) 
            {
                cell =(ContactUsCell *) [tableView dequeueReusableCellWithIdentifier:ContactUsCellUIdentifier];
            }
            else
            {
                cell =(ContactUsCell *) [tableView dequeueReusableCellWithIdentifier:ContactUsCellIdentifier];
            }
            
            
            cell.messageTitle.text = searchResult.date;
            cell.messageReply.text = searchResult.title;

            
            return cell;
             
        }
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:011"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];        
    }
    return nil;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([contactUsMessageCollection count] == 0) {
        return nil;
    }
    else
    {
        return indexPath;
    }
}


#pragma mark - TextFiled show\hide
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtViewBody resignFirstResponder];
    [txtMessageSubject resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtName resignFirstResponder];
}

///////////////////////////
//show hoide keyboard
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
/// end


//---when a TextField view begins editing---
-(void) textFieldDidBeginEditing:(UITextField *)textFieldView {  
    CGRect textFieldRect =
    [self.view.window convertRect:textFieldView.bounds fromView:textFieldView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

//---when a TextField view is done editing---
-(void) textFieldDidEndEditing:(UITextField *) textFieldView {  
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


//---when a TextField view begins editing---
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    CGRect textFieldRect =
    [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
