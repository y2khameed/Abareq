//
//  NewsComments.m
//  mHajj
//
//  Created by ALI AL-AWADH on 4/28/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "NewsComments.h"
#import "MBProgressHUD.h"


@implementation NewsComments

@synthesize nTittle;
@synthesize nID;

@synthesize commentsText;

@synthesize JsonCode;

@synthesize CommentsCollection;

@synthesize requestNumber;


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
    
    CommentsCollection = [[NSMutableArray alloc] init];
    
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"Hameed nID is :: %@", nID);
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل التعليقات...";
        [CommentsCollection removeAllObjects];

    //read Comments
    requestNumber = 1;
    NSURL *url = [NSURL URLWithString:URL_GET_COMMENTS];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request setPostValue:nTittle forKey:@"nTittle"];
    [request setPostValue:nID forKey:@"nID"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)viewDidUnload
{
    [self setJsonCode:nil];
    [self setCommentsText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [CommentsCollection removeAllObjects];
    [commentsView loadHTMLString:@"" baseURL:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - HTTP
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    // Parse Data
    NSData *jsonData = [request responseData];
    
    NSError *jsonParseErro = nil;
    
    CommentsDetails *comments;
    if (jsonData == nil) {
        NSLog(@"ERROR");
    }
    else
    {
        
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
        //request Number 1 (receive Comments)///////////////////
        if (requestNumber == 1)
        {
           
        for (int i=0; i< [jsonArray count]; i++) 
        {
            
        NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
        comments = [[CommentsDetails alloc] init];
        
            [comments setCommID:[jsonDic objectForKey:@"commID"]];
            [comments setCommenterName:[jsonDic objectForKey:@"commenterName"]];
            [comments setCommenterCountry:[jsonDic objectForKey:@"commenterCountry"]];
            [comments setCommenterEmail:[jsonDic objectForKey:@"commenterEmail"]];
            [comments setShow_mail:[jsonDic objectForKey:@"show_mail"]];
            [comments setComenterIP:[jsonDic objectForKey:@"commenterIP"]];
            [comments setCommenterText:[jsonDic objectForKey:@"commenterText"]];
            [comments setCommentstimestamp:[jsonDic objectForKey:@"timestamp"]];
            [comments setMoudleID:[jsonDic objectForKey:@"moudleID"]];
            [comments setPartID:[jsonDic objectForKey:@"partID"]];
            [comments setActive:[jsonDic objectForKey:@"active"]];
            [comments setResponseAdmin:[jsonDic objectForKey:@"responseAdmin"]];
            [CommentsCollection addObject:comments];
            
            
        }
        //display comments
            [self displayComments];
       // save comments to SQL
            [self saveComments];
            [MBProgressHUD hideHUDForView:self.view animated:YES]; 
            
        }
        // request number 2 send comments
        else if(requestNumber == 2)
        {
            NSLog(@"No Error");
            
             // Hide keyword
             [commentsText resignFirstResponder];
             
             // Clear text field
             commentsText.text = @"";
            [MBProgressHUD hideHUDForView:self.view animated:YES]; 
            [self viewDidAppear:TRUE];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    
    if (requestNumber ==1) 
    {
        [self getCommentsFromSql];
        [self displayComments];
    }
    //send Comments
    else if (requestNumber == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"عماية الإرسال اشلة"]];
        [alert setMessage:@"فشلت عملية إرسال العتعليق"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - ButtonActions
- (IBAction)btnHideCommentsClicked:(id)sender {
    [CommentsCollection removeAllObjects];
    
    [commentsView loadHTMLString:@"" baseURL:nil];

    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)btnAddComments:(id)sender {
    
    [commentsText resignFirstResponder];
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري إرسال التعليق...";

    requestNumber =2;
    // Get device unique ID
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    if ([[device model] isEqualToString:@"iPhone Simulator"] ) {
        uniqueIdentifier = @"73967c9358810459bfe0f1a900581b0993e487be";
    }
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    
    NSLog(@"Date is %@", dateString);
    
    //[[[NSDate  date] descriptionWithCalendarFormat:@"%H:%M:%S %Z" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]] UTF8String];
    
    NSURL *url = [NSURL URLWithString:URL_ADD_COMMENT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL    :url];
    [request setPostValue:uniqueIdentifier forKey:@"deviceid"];
    NSLog(@"::  %@",uniqueIdentifier);
    [request setPostValue:[commentsText text] forKey:@"commText"];
    //[request setPostValue:nTittle forKey:@"nTittle"];
    [request setPostValue:nID forKey:@"nID"];
    NSLog(@"::: %@",nID);
    [request setPostValue:dateString forKey:@"commTime"];
   // NSLog([now description]);
    [request setDelegate:self];
    [request startAsynchronous];

    
    
}

- (void) displayComments{
    NSString * rString = [[NSString alloc] initWithFormat:@"<html><body style=\"background-color:transparent;\" dir=\"rtl\">"];
    
    
    for (int i=0; i< [CommentsCollection count]; i++) 
    {
        NSString * photoURL = [URL_USER_PHOTO stringByAppendingFormat:[[CommentsCollection objectAtIndex:i] comenterIP]];
        
        
        photoURL = [photoURL stringByAppendingFormat:@".jpg"];
        NSLog(@"user photo %@", photoURL);
        
       // rString = [rString stringByAppendingFormat:@"<p align=\"right\"><img border=\"0\" src=\"%@\" style=\"border:1px solid #ffffff;box-shadow: 1px 1px 2px #b0b0b0;\" /></p>",photoURL];
        
        rString = [rString stringByAppendingFormat:@"<span style=\"font-size: 13px;text-align:right;color:#7a0000;\">%@</span>", [[CommentsCollection objectAtIndex:i] commenterName]];
        
        rString = [rString stringByAppendingFormat:@"<span style=\"font-size: 10px;text-align:left;color:#000000;margin-right:15;\">%@</span>", [[CommentsCollection objectAtIndex:i] commentstimestamp]];
        rString = [rString stringByAppendingFormat:@"<p style=\"font-size: 18px;text-align:justify;\">%@</p>", [[CommentsCollection objectAtIndex:i] commenterText]];
        
        rString = [rString stringByAppendingFormat:@"<hr>"];
    }
    
    rString = [rString stringByAppendingFormat:@"</body></html>"];
    
    [commentsView loadHTMLString:rString baseURL:nil];
    }

#pragma mark - SQL
- (void) saveComments{
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    
    //tSQL = [ tSQL stringByAppendingFormat:@"DELETE FROM comments where nTittle = '%@'", nTittle];
    tSQL = [ tSQL stringByAppendingFormat:@"DELETE FROM comments where nID = '%@'", nID];
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
    NSLog(@"DELETING:  %@", tSQL);
    
    tSQL = @"";


    //NSString *insertSQL = @"Insert Into comments values ('deviceID', 1, 'title', 'hammed', 'test', '2-2-2012')";
    
    CommentsDetails *currentComments;
    
    for (int i =0; i< [CommentsCollection count]; i++) {
        currentComments = [CommentsCollection objectAtIndex:i];
                
        tSQL = [ tSQL stringByAppendingFormat:@"Insert Into comments (commDeviceID, _id, nID, commenterName, commentText, commTime) values ('%@', '%@', '%@', '%@', '%@', '%@')",[currentComments comenterIP], [currentComments commID], nID, [currentComments commenterName],[currentComments commenterText], [currentComments commentstimestamp]];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"Inserting:  %@", tSQL);
        
        tSQL = @"";
    }
}

- (void) getCommentsFromSql{
 
    
    NSString * sqlStat = [[NSString alloc] initWithFormat:@""];    
    sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM comments where nID = '%@'", nID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    CommentsDetails *currentComments = [[CommentsDetails alloc] init];
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [currentComments setComenterIP:[dbConnt fetchString:theStat ColID:0]];
        [currentComments setCommID:[dbConnt fetchString:theStat ColID:1]];
        // nTittle is not selected 3
        [currentComments setCommenterName:[dbConnt fetchString:theStat ColID:3]];
        [currentComments setCommenterText:[dbConnt fetchString:theStat ColID:4]];
        [currentComments setCommentstimestamp:[dbConnt fetchString:theStat ColID:5]];  
         
         [CommentsCollection addObject:currentComments];
        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        currentComments = [[CommentsDetails alloc] init];
        [currentComments setComenterIP:[dbConnt fetchString:theStat ColID:1]];
        [currentComments setCommID:[dbConnt fetchString:theStat ColID:2]];
        // nTittle is not selected 3
        [currentComments setCommenterName:[dbConnt fetchString:theStat ColID:4]];
        [currentComments setCommenterText:[dbConnt fetchString:theStat ColID:5]];
        [currentComments setCommentstimestamp:[dbConnt fetchString:theStat ColID:6]];
         [CommentsCollection addObject:currentComments];
        
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TextFiled show\hide
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
