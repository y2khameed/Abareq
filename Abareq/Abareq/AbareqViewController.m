//
//  AbareqViewController.m
//  Abareq
//
//  Created by ALI AL-AWADH on 8/26/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "AbareqViewController.h"
#import "AboutViewContoller.h"
#import "NewsController.h"
#import "ContactUs.h"
#import "MBProgressHUD.h"
#import "BannerInfo.h"
#import "SettingView.h"
#import <QuartzCore/QuartzCore.h>


@implementation AbareqViewController
{
    NSMutableArray *bannersCollection;
    NSMutableArray *deletedNews;
}
@synthesize btn1Lbl;
@synthesize btn2Lbl;
@synthesize btn3Lbl;
@synthesize btn4Lbl;
@synthesize btn5Lbl;
@synthesize btn6Lbl;
@synthesize btn7Lbl;
@synthesize btn8Lbl;
@synthesize btn9Lbl;

@synthesize bannerImage;
@synthesize reLoad;
@synthesize btnEnableNotification;

NewsController *viewNewsController;
ContactUs *viewContactUs;
AboutViewContoller *viewAbout;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    bannersCollection = [[NSMutableArray alloc] init];
    deletedNews = [[NSMutableArray alloc] init];
    [self getDeletedNews];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateStuff)        
                                                 name:@"appDidBecomeActive" 
                                               object:nil];
    
    btn1Lbl.layer.cornerRadius = 5.0;
    btn1Lbl.layer.masksToBounds = YES;
    
    btn2Lbl.layer.cornerRadius = 5.0;
    btn2Lbl.layer.masksToBounds = YES;
    
    btn3Lbl.layer.cornerRadius = 5.0;
    btn3Lbl.layer.masksToBounds = YES;
    
    btn4Lbl.layer.cornerRadius = 5.0;
    btn4Lbl.layer.masksToBounds = YES;
    
    btn5Lbl.layer.cornerRadius = 5.0;
    btn5Lbl.layer.masksToBounds = YES;
    btn6Lbl.layer.cornerRadius = 5.0;
    btn6Lbl.layer.masksToBounds = YES;
    btn7Lbl.layer.cornerRadius = 5.0;
    btn7Lbl.layer.masksToBounds = YES;
    btn8Lbl.layer.cornerRadius = 5.0;
    btn8Lbl.layer.masksToBounds = YES;
    
    
    //Notification Button
   // [self updateLabels];
        
}

- (void)viewDidUnload
{
    [self setBannerImage:nil];
    [self setBtn1Lbl:nil];
    [self setBtn2Lbl:nil];
    [self setBtn3Lbl:nil];
    [self setBtn4Lbl:nil];
    [self setBtn5Lbl:nil];
    [self setBtn6Lbl:nil];
    [self setBtn7Lbl:nil];
    [self setBtn8Lbl:nil];
    [self setBtn9Lbl:nil];
    [self setBtnEnableNotification:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateCountLabels];
   
    
    if (reLoad) {
        // Start hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"جاري تحميل الأخبار...";
        
        [self getBanners];
        //[self getAllNews];
        reLoad = FALSE;
    }
     

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   // return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}



#pragma mark - Buttons Action
- (IBAction)btnAboutClicked:(id)sender {

//    AboutViewContoller *viewAbout = [[AboutViewContoller alloc] initWithNibName:@"AboutViewContoller" bundle:nil];
    if (viewAbout==nil) {
        viewAbout = [[AboutViewContoller alloc] initWithNibName:@"AboutViewContoller" bundle:nil];

    }
    
    viewAbout.viewFile = @"about_innoFlame";
    
    [self.navigationController pushViewController:viewAbout animated:TRUE];

}

- (IBAction)btnAboutUsClicked:(id)sender {
    
    //AboutViewContoller *viewAbout = [[AboutViewContoller alloc] initWithNibName:@"AboutViewContoller" bundle:nil];
    if (viewAbout==nil) {
        viewAbout = [[AboutViewContoller alloc] initWithNibName:@"AboutViewContoller" bundle:nil];
        
    }
    viewAbout.viewFile = @"about_app";
    
    [self.navigationController pushViewController:viewAbout animated:TRUE];
}

- (IBAction)btnSettingsClicked:(id)sender {
    
    SettingView *viewSetting = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
    
    
    
    [self.navigationController pushViewController:viewSetting animated:TRUE];

}

- (IBAction)btnContactUsClicked:(id)sender {
    if (viewContactUs == nil) {
        viewContactUs = [[ContactUs alloc] initWithNibName:@"ContactUs" bundle:nil];
    }
    //viewContactUs.mID = @"99";
    [self.navigationController pushViewController:viewContactUs animated:TRUE];

}

- (IBAction)btnEnableNotificationClicked:(id)sender {
    
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري ارسال الطلب...";
    
    // Get device unique ID
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    if ([[device model] isEqualToString:@"iPhone Simulator"] ) {
        uniqueIdentifier = @"73967c9358810459bfe0f1a900581b0993e487be";
    }
    // NSString *temUrl = [URL_REGISTER_CHECK stringByAppendingFormat:@"?deviceID=%@&token=%@", uniqueIdentifier,token];
    
    // NSLog(@"URL %@",temUrl);
    NSString * current = [self getCurrentNotificationStatus];
    NSString * mtoken = [self getDeviceToke];
    NSURL *url = [NSURL URLWithString:URL_REGISTER_TOKEN];
    NSLog(@"%@",current);
    if ([current isEqualToString:@"TRUE"]) {
        
        NSString *temp = @"";
        temp = [URL_REGISTER_TOKEN stringByAppendingFormat:@"?op=unregister"];
        
        url = [NSURL URLWithString:temp];
        //[request setPostValue:@"unregister" forKey:@"op"];
        
    }
    NSLog(@"%@",[url absoluteString]);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:uniqueIdentifier forKey:@"deviceID"];
    
    [request setPostValue:mtoken forKey:@"token"];
    [request setPostValue:@"iPhone" forKey:@"mobileType"];
    [request setDelegate:self];
    [request startAsynchronous];
}




#pragma mark - NEWS Buttons
- (IBAction)btn1Clicked:(id)sender {
    if (viewNewsController == nil) {
        
        viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"1";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn2Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"2";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
    
}

- (IBAction)btn3Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"3";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn4Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"4";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn5Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"5";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn6Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"6";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn7Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"7";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn8Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"8";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

- (IBAction)btn9Clicked:(id)sender {
    if (viewNewsController == nil) {
    
    viewNewsController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
    }
    
    viewNewsController.secID = @"9";
    viewNewsController.reLoad = TRUE;
    [self.navigationController pushViewController:viewNewsController animated:TRUE];
}

#pragma mark - Email
- (IBAction)btnEmailUs:(id)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Hello from California!"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"first@example.com",
                             nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com",
                             @"third@example.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com",
                              nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ipodnano"
                                                     ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/png"
                     fileName:@"ipodnano"];
    
    // Fill out the email body text.
    NSString *emailBody = @"It is raining in sunny California!";
    [picker setMessageBody:emailBody isHTML:NO];
    
    // Present the mail composition interface.
    [self presentModalViewController:picker animated:YES];
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - SQL

- (void) getDeletedNews
{
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@"select * FROM newsDeleted"];
    
    
    sqlite3_stmt * theStat;
    
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [deletedNews addObject:[dbConnt fetchString:theStat ColID:0]];
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {
        [deletedNews addObject:[dbConnt fetchString:theStat ColID:0]];
        
    }
}


#pragma mark - HTTP

- (void) updateStuff
{
    if (reLoad) {
        // Start hud
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"جاري تحميل الأخبار...";
        
        [self getBanners];
        //[self getAllNews];
        reLoad = FALSE;
    }
}

- (void) getBanners
{
    NSURL *url = [NSURL URLWithString:URL_GET_BANNER];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) getAllNews
{
    NSURL *url = [NSURL URLWithString:URL_NEWS_ALL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) saveBanners
{
    @try {
        
        NSLog(@"all done!");
        
        char * chrSQL;
        
        NSString * tSQL = [[NSString alloc] initWithFormat:@""];
        
        NSMutableArray *bannersArray = [[NSMutableArray alloc] init];
        
        sqlite3_stmt * theStat;
        
        
        tSQL = [ tSQL stringByAppendingFormat:@"DELETE FROM Banners"];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"DELETING:  %@", tSQL);
        
        tSQL = @"";
        
        /*
        //Delete all files
        
        //Prepare the path
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/BannerNo0.png",docDir];
        
        //Prepear the Engin
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        //Check the file existance
        BOOL fileExists = [fileManager fileExistsAtPath:pngFilePath];
        NSLog(@"Path to file: %@", pngFilePath);        
        NSLog(@"File exists: %d", fileExists);
        NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:pngFilePath]);
        
        if (fileExists) 
        {   //Remove if found
            BOOL success = [fileManager removeItemAtPath:pngFilePath error:&error];
            if (!success) NSLog(@"Error: %@", [error localizedDescription]);
        }
        */
        
         NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //Send the sql
        NSString * imgFile = @"";
        BannerInfo *bannerInst;
        for (int I = 0; I< [bannersCollection count]; I++) 
        {
            imgFile = [docDir stringByAppendingFormat:@"/"];
            bannerInst = [bannersCollection objectAtIndex:I];
            //Save the Picture
            imgFile = [imgFile stringByAppendingFormat:[bannerInst bnrImg]];
           
            [self SaveFileFromURL:[URL_BANNER_IMAGE stringByAppendingFormat:[bannerInst bnrImg]] ResultFileName:imgFile ];
            
            //Save the file name
            tSQL = [tSQL stringByAppendingFormat:@"INSERT INTO Banners (bnrID, bnrTitle, bnrImg, bnrStatus, inHomePage, URL) VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",[bannerInst bnrID] ,[bannerInst bnrTitle], [bannerInst bnrImg], [bannerInst bnrStatus], [bannerInst inHomePage],[bannerInst bnrLink] ];
            
            
            
            chrSQL = (char*) [tSQL UTF8String];
            
            NSLog(@" ## [%@]", tSQL);
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
            
            //NSLog(@"%@", theStat);
            
            tSQL = @"";
             NSLog(@"%@", imgFile);
            //[bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
            
            @try {
                [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
            }
            @catch (NSException *exception) {
                NSLog(@"The image is not found %@",imgFile);
            }

            
            //[bannerImage setImage:[UIImage imageWithContentsOfFile:imgFile]];
            imgFile = @"";
           
        }
        
        bannerImage.animationImages = bannersArray;
        
        bannerImage.animationDuration = 5* ([bannersArray count]);
        bannerImage.animationRepeatCount = 0;
        
        [bannerImage startAnimating];
        
        startTime = [[NSDate date] timeIntervalSince1970];
        
        UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
        bannerImage.userInteractionEnabled = YES;
        [bannerImage addGestureRecognizer:myTapGesture];
    }
    @catch (NSException *e) 
    {
        NSLog(@"Excption %@", e.description);
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"saveBanners:010"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];       
    }
    
}

NSTimeInterval startTime;
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    BannerInfo *bannerInstance;
    NSData *jsonData = [request responseData];
    
    NSError *jsonParseErro = nil;
    
    
    
    if (jsonData == nil) {
        NSLog(@"ERROR");
    }
    else
    {
        NSString *temp = @"";
        temp = [URL_REGISTER_TOKEN stringByAppendingFormat:@"?op=unregister"];
        
        if([[request url] isEqual:[NSURL URLWithString:URL_GET_BANNER]])
        {
            if ([bannersCollection count] != 0) {
                [bannersCollection removeAllObjects];
            }
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
            
            for (int i=0; i< [jsonArray count]; i++) 
            {
                
                
                NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
                
                for (id key in jsonDic) {
                    NSLog(@"key: %@, value: %@", key, [jsonDic objectForKey:key]);
                } 
                
                bannerInstance = [[BannerInfo alloc] init];
                
                [bannerInstance setBnrID:[jsonDic objectForKey:@"bnrID"]];
                [bannerInstance setBnrTitle:[jsonDic objectForKey:@"bnrTitle"]];
                [bannerInstance setBnrImg:[jsonDic objectForKey:@"bnrImg"]];
                [bannerInstance setBnrStatus:[jsonDic objectForKey:@"bnrStatus"]];
                [bannerInstance setInHomePage:[jsonDic objectForKey:@"inHomePage"]];
                [bannerInstance setBnrLink:[jsonDic objectForKey:@"bnrLink"]];
                
                
                [bannersCollection addObject:bannerInstance];   
            }   
            // save comments to SQL
            [self saveBanners];
            //display comments
            //[_newsTable reloadData];
        }
        else if([[request url] isEqual:[NSURL URLWithString:URL_NEWS_ALL]])
        {
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
            @try 
            {
                char * chrSQL;
                
                NSString * tSQL = [[NSString alloc] initWithFormat:@""];
                
                //tSQL = [[NSString alloc] init];
                
                sqlite3_stmt * theStat;
                
                
                tSQL = @"DELETE FROM news";
                NSLog(@" ## [%@]", tSQL);
                
                chrSQL = (char*) [tSQL UTF8String];    
                theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
                NSLog(@"DELETING:  %@", tSQL);

                
            for (int i=0; i< [jsonArray count]; i++) 
            {
                
                
                NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
                
               // NSString *tempSummery = [[jsonDic objectForKey:@"nSummary"] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
                if ([deletedNews indexOfObject:[jsonDic objectForKey:@"nID"]] == NSNotFound)
                {
                    tSQL = @"";
                    //Save the file name
                    tSQL = [tSQL stringByAppendingFormat:@"INSERT INTO news (_id, tittle, description, date, image, secID) VALUES ('%@', '%@', '%@', '%@', '%@', %@)",[jsonDic objectForKey:@"nID"] ,[jsonDic objectForKey:@"nTitle"], [jsonDic objectForKey:@"nSummary"], [jsonDic objectForKey:@"nDate"], [jsonDic objectForKey:@"nImgPath"], [jsonDic objectForKey:@"secID"]  ];
                    
                    
                    
                    chrSQL = (char*) [tSQL UTF8String];
                    
                    NSLog(@" ## [%@]", tSQL);
                    theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
                    
                    //NSLog(@"%@", theStat);
                    
                    tSQL = @"";
                }
            }   
            }
            @catch (NSException *e) 
            {
                UIAlertView *alert = [[UIAlertView alloc] init];
                [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:010"]];
                [alert setMessage:@""];
                [alert setDelegate:self];
                [alert addButtonWithTitle:@"حسناً"];
                [alert show];       
            }

            [self updateCountLabels]; 
        }
        else if([[request url] isEqual:[NSURL URLWithString:URL_REGISTER_TOKEN]] || [[request url] isEqual:[NSURL URLWithString:temp]] )
        {
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
            
            for (id key in jsonDic) 
            {
                NSLog(@"key: %@, value: %@", key, [jsonDic objectForKey:key]);
            }
            
            char * chrSQL;
            
            NSString * tSQL = [[NSString alloc] initWithFormat:@""];
            
            NSString * current = [self getCurrentNotificationStatus];
            
            sqlite3_stmt * theStat;
            
            tSQL = @"DELETE FROM NotificationSettings";
            NSLog(@" ## [%@]", tSQL);
            
            chrSQL = (char*) [tSQL UTF8String];    
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
            NSLog(@"DELETING:  %@", tSQL);
            
            tSQL = @"";
            if ([current isEqualToString:@"TRUE"]) {
                tSQL = [ tSQL stringByAppendingFormat:@"Insert Into NotificationSettings Values (0, 'FALSE')"];
            }
            else
            {
                tSQL = [ tSQL stringByAppendingFormat:@"Insert Into NotificationSettings Values (0, 'TRUE')"];
            }
            NSLog(@" ## [%@]", tSQL);
            
            chrSQL = (char*) [tSQL UTF8String];    
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
            NSLog(@"Inserting:  %@", tSQL);
            
            tSQL = @"";
            
            
            
            
            
            [self updateLabels];
        }
        
    }
    NSLog(@"No Error");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    @try {
        
        if([[request url] isEqual:[NSURL URLWithString:URL_GET_BANNER]])
        {
            //Send the sql
            NSString * imgFile = [docDir stringByAppendingFormat:@"/"];
            
            NSMutableArray *bannersArray = [[NSMutableArray alloc] init];
            NSLog(@"Parser Error, DB read");
            
            NSString * sqlStat = [[NSString alloc] initWithFormat:@""];    
            sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM Banners"];
            
            NSLog(@" ## [%@]", sqlStat);
            
            //Convert the NSStirng to char b/c SendSQL function accept char only
            char * chrSQL = (char*) [sqlStat UTF8String];    
            
            //Send the sql
            sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
            
            BannerInfo *newsD = [[BannerInfo alloc] init];
            
            //Fetch the first item and init the arrayss
            if (sqlite3_step(theStat) == SQLITE_ROW)
            {
                
                [newsD setBnrID:[dbConnt fetchString:theStat ColID:0]];
                [newsD setBnrTitle:[dbConnt fetchString:theStat ColID:1]];
                [newsD setBnrImg:[dbConnt fetchString:theStat ColID:2]];
                [newsD setBnrStatus:[dbConnt fetchString:theStat ColID:3]];
                [newsD setInHomePage:[dbConnt fetchString:theStat ColID:4]];
                [newsD setBnrLink:[dbConnt fetchString:theStat ColID:5]];
                
                [bannersCollection addObject:newsD];
                
                imgFile = [imgFile stringByAppendingFormat:[newsD bnrImg]];
                NSLog(@"%@", imgFile);
                @try {
                    [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
                }
                @catch (NSException *exception) {
                    NSLog(@"The image is not found %@",imgFile);
                }

            }
            
            //Fill up the array
            while( sqlite3_step(theStat) == SQLITE_ROW)
            {
                imgFile = [docDir stringByAppendingFormat:@"/"];
                
                newsD = [[BannerInfo alloc] init];
                [newsD setBnrID:[dbConnt fetchString:theStat ColID:0]];
                [newsD setBnrTitle:[dbConnt fetchString:theStat ColID:1]];
                [newsD setBnrImg:[dbConnt fetchString:theStat ColID:2]];
                [newsD setBnrStatus:[dbConnt fetchString:theStat ColID:3]];
                [newsD setInHomePage:[dbConnt fetchString:theStat ColID:4]];
                [newsD setBnrLink:[dbConnt fetchString:theStat ColID:5]];
                
                [bannersCollection addObject:newsD];
                
                imgFile = [imgFile stringByAppendingFormat:[newsD bnrImg]];
                NSLog(@"%@", imgFile);
                @try {
                    [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
                }
                @catch (NSException *exception) {
                    NSLog(@"The image is not found %@",imgFile);
                }
                
                
                
            }
            
            //  [bannersArray addObject:[UIImage imageNamed:@"1.jpg"]];
            //   [bannersArray addObject:[UIImage imageNamed:@"2.jpg"]];
            // [bannersArray addObject:nil];
            
            
            
            bannerImage.animationImages = bannersArray;
            
            bannerImage.animationDuration = 5* ([bannersArray count]);
            bannerImage.animationRepeatCount = 0;
            
            [bannerImage startAnimating];
            
            startTime = [[NSDate date] timeIntervalSince1970];
            
            UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
            bannerImage.userInteractionEnabled = YES;
            [bannerImage addGestureRecognizer:myTapGesture];
            

        }
        else if([[request url] isEqual:[NSURL URLWithString:URL_NEWS_ALL]])
        {
            [self updateCountLabels];
        }
                
        //[_newsTable reloadData ];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"request Failed:004"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];        
    }
    
}
#pragma mark - Banner OpenURL
-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture
{
    
    NSTimeInterval duration = [[NSDate date] timeIntervalSince1970] - startTime;
    
    NSLog(@"Start Time %i", (int)startTime);
    
    int currentFrame = duration/([bannerImage animationDuration]/[[bannerImage animationImages] count]);
    
    if (currentFrame >= [bannersCollection count]) {
        currentFrame = currentFrame % [bannersCollection count];
    }
    NSLog(@"Cuurent Frame %i",currentFrame);
    
    
    if (currentFrame < [bannersCollection count]) {
        BannerInfo *banerInst = [bannersCollection objectAtIndex:currentFrame];
        NSLog(@"Banner Clicked %@",[banerInst bnrLink]);
        
        NSLog(@"Banner %@",[[banerInst bnrLink] substringToIndex:4]);
        if ([[banerInst bnrLink] substringToIndex:4]==@"http") {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[banerInst bnrLink]]];
        }
        else{
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://" stringByAppendingFormat:[ banerInst bnrLink]]]];
        }
    }
    
}


#pragma mark - Others
- (void) SaveFileFromURL:(NSString *) theURL ResultFileName: (NSString *) rFile
{
    @try {
        NSLog(@"Downloading... FROM: %@", theURL);
        
        // Get an image from the URL below
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theURL]]];
        
        NSLog(@"%f,%f",image.size.width,image.size.height);
        
        // Let's save the file into Document folder.
        // You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
        // NSString *deskTopDir = @"/Users/kiichi/Desktop";
        
        //NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // If you go to the folder below, you will find those pictures
       // NSLog(@"%@",docDir);
        
        //NSLog(@"saving png");
        //NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, rFile];
        //NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
       // [data1 writeToFile:rFile atomically:YES];
        
        NSLog(@"saving jpeg");
        //NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:rFile atomically:YES];
        
        NSLog(@"saving image done");
        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NE:018"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];       
    }
    
}

-( void) updateCountLabels
{
    @try {
        
            
            NSString * sqlStat = [[NSString alloc] initWithFormat:@""];    
        sqlStat =[sqlStat stringByAppendingFormat:@"SELECT n.secID, count(n._id) - count(r._id) as count FROM news n left outer join newsread r on n._id = r._id and n.secID = r.secID Group By n.secID"];
            
            NSLog(@" ## [%@]", sqlStat);
            
            //Convert the NSStirng to char b/c SendSQL function accept char only
            char * chrSQL = (char*) [sqlStat UTF8String];    
            
            //Send the sql
            sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
            
            
            
            //Fetch the first item and init the arrayss
            if (sqlite3_step(theStat) == SQLITE_ROW)
            {
                
                switch ([[dbConnt fetchString:theStat ColID:0] intValue]) 
                {
                    case 1:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn1Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn1Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn1Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 2:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn2Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn2Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn2Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 3:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn3Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn3Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn3Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 4:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn4Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn4Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn4Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 5:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn5Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn5Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn5Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 6:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn6Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn6Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn6Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 7:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn7Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn7Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn7Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 8:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn8Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn8Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn8Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 9:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn9Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn9Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn9Lbl setHidden:TRUE];
                        }
                        
                        break;
                    default:
                        break;
                }
            }
            
            //Fill up the array
            while( sqlite3_step(theStat) == SQLITE_ROW)
            {
                switch ([[dbConnt fetchString:theStat ColID:0] intValue]) 
                {
                    case 1:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn1Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn1Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn1Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 2:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn2Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn2Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn2Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 3:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn3Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn3Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn3Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 4:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn4Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn4Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn4Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 5:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn5Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn5Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn5Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 6:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn6Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn6Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn6Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 7:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn7Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn7Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn7Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 8:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn8Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn8Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn8Lbl setHidden:TRUE];
                        }
                        
                        break;
                    case 9:
                        if ([[dbConnt fetchString:theStat ColID:1] intValue] > 0) {
                            [btn9Lbl setText:[dbConnt fetchString:theStat ColID:1]];
                            [btn9Lbl setHidden:FALSE];
                        }
                        else
                        {
                            [btn9Lbl setHidden:TRUE];
                        }
                        
                        break;
                    default:
                        break;
                }
            }
            
           
        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"UpdateLabel:004"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];        
    }

}

#pragma mark - Notification

-(NSString *) getCurrentNotificationStatus
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@"Select * From NotificationSettings"];    
    //sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %i", secID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        NSLog(@"%@", [dbConnt fetchString:theStat ColID:1] );
        return [dbConnt fetchString:theStat ColID:1];        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {
        
    }
    return nil;
}

-(NSString *) getDeviceToke
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@"Select * From device"];    
    //sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %i", secID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        NSLog(@"Token %@", [dbConnt fetchString:theStat ColID:1] );
        return [dbConnt fetchString:theStat ColID:1];        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {
        
    }
    return nil;
}

- (void) updateLabels
{
    @try {
        
        NSString * current = [self getCurrentNotificationStatus];
        
        
        if ([current isEqualToString:@"TRUE"]) {
           
            [btnEnableNotification setBackgroundImage:[UIImage imageNamed:@"btn_notification_on.png"] forState:normal];
        } 
        else
        {
            [btnEnableNotification setBackgroundImage:[UIImage imageNamed:@"btn_notification_off.png"] forState:normal];
        } 
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


@end
