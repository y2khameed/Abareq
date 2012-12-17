//
//  NewsDisplay.m
//  iWS
//
//  Created by ALI AL-AWADH on 5/30/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "NewsDisplay.h"
#import "globalVars.h"
#import "BannerInfo.h"
#import "BannerImage.h"

#define DEFAULT_FONT_SIZE 24

@implementation NewsDisplay

@synthesize TheSQL;
@synthesize TheString;
@synthesize nID, sID;

int NewsFontSize = 24;
NSString *newsBody;

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
    
    //[txtView loadHTMLString:TheString baseURL:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStuff)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
   
}

- (void)viewDidUnload
{
    [self setBannerImage:nil];
    [self setBtnBanner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:TRUE];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:TRUE];
     [self getBanners];
    
    //Hide Next Button if this is the last Item
    /*
    if ([a3malHajjItemID intValue]<last3malID) {
        btnNext.hidden = FALSE;
        
    }
    else 
    {
        btnNext.hidden = TRUE;
    }
     */
    //Hide Prev Button if this is the first Item
    /*
    if ([a3malHajjItemID intValue]>first3malID) {
        btnPrev.hidden = FALSE;
    }
    else 
    {
        btnPrev.hidden = TRUE;
    }
    */
    
    //
    //Get The Text from SQL and disply it
    NSString *nTheSQL = @"";
    
    NSLog(@"News ID %@",nID );
    
    nTheSQL =[nTheSQL stringByAppendingFormat:@"SELECT * FROM News where _ID = %@", nID];
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [nTheSQL UTF8String];
    
    sqlite3_stmt * theStat =[dbConnt SendSQL:chrSQL SelectSQL:true];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        NSString *imagePath = [URL_NEWS_IMAGE stringByAppendingFormat:[dbConnt fetchString:theStat ColID:4]];
        NSLog(@"The imge: %@", imagePath);
        
        NSString *tempSummery = [[dbConnt fetchString:theStat ColID:2] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
        
        newsBody = [dbConnt fetchString:theStat ColID:2];
        
        NSString * rString =@"";
        
        if ([[dbConnt fetchString:theStat ColID:4] isEqualToString:@"default_abarig.png"] || [[dbConnt fetchString:theStat ColID:4] isEqualToString:@""]) {
            rString =  [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\"><p style=\"font-size: 24px;text-align:Center;\">%@</p><p style=\"font-size: 14px;text-align:Center;Color:Red\">%@</p><p  dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\">%@</p></body></html>",[dbConnt fetchString:theStat ColID:1],[dbConnt fetchString:theStat ColID:3], tempSummery ];
        }
        else
        {
        rString =  [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\"><p style=\"font-size: 24px;text-align:Center;\">%@</p><p style=\"font-size: 14px;text-align:Center;Color:Red\">%@</p><p  dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\">%@</p><p align=\"center\"><img border=\"0\" width=\"300\" src=\"%@\" style=\"border:1px solid #ffffff;box-shadow: 1px 1px 2px #b0b0b0;\" /></p></body></html>",[dbConnt fetchString:theStat ColID:1],[dbConnt fetchString:theStat ColID:3], tempSummery, imagePath ];
        }
        NSLog(@"HTML: %@", rString);
        
        [txtView loadHTMLString:rString baseURL:nil];
        
        [self saveReadNews:[dbConnt fetchString:theStat ColID:0]];
        
    }
    else
    {
        [txtView loadHTMLString:@"" baseURL:nil];
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Actions

- (IBAction)btnShowCommentsClicked:(id)sender {
    NewsComments *showComments = [[NewsComments alloc] initWithNibName:@"NewsComments" bundle:nil];
    
    showComments.nID = nID;
    NSLog(@"nID %@", nID);
 
    [self.navigationController pushViewController:showComments animated:TRUE];
}

- (IBAction)btnFullURLClicked:(id)sender 
{
    NSString *tempURL = [NEWS_FULL_URL stringByAppendingFormat:@"%@", nID];
    NSLog(@"News Full URL %@", tempURL);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempURL]];
}

- (IBAction)btnNextClicked:(id)sender
{
    NSString *nTheSQL = @"";
    
    NSLog(@"News ID %@",nID );
    
    nTheSQL =[nTheSQL stringByAppendingFormat:@"SELECT * FROM News where _ID < %@ and secID= %@ order by _id DESC ", nID,sID];
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [nTheSQL UTF8String];
    
    sqlite3_stmt * theStat =[dbConnt SendSQL:chrSQL SelectSQL:true];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        nID = [dbConnt fetchString:theStat ColID:0];
        
        [self viewDidAppear:TRUE];
    }
}

- (IBAction)btnPrevClicked:(id)sender
{
    NSString *nTheSQL = @"";
    
    NSLog(@"News ID %@",nID );
    
    nTheSQL =[nTheSQL stringByAppendingFormat:@"SELECT * FROM News where _ID > %@ and secID= %@ order by _id", nID,sID];
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [nTheSQL UTF8String];
    
    sqlite3_stmt * theStat =[dbConnt SendSQL:chrSQL SelectSQL:true];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        nID = [dbConnt fetchString:theStat ColID:0];
        
        [self viewDidAppear:TRUE];
    }

}

- (IBAction)btnCopyClicked:(id)sender
{
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    [pastBoard setString:newsBody];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Delete News
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            NSLog(@"News ID %@", nID);
            
            char * chrSQL;
            
            NSString * tSQL = [[NSString alloc] initWithFormat:@""];
            
            
            sqlite3_stmt * theStat;
            
            
            /*
            tSQL = [tSQL stringByAppendingFormat: @"select * FROM newsDeleted where _id = '%@' and secID = '%@'", nID, sID];;
            NSLog(@" ## [%@]", tSQL);
            
            chrSQL = (char*) [tSQL UTF8String];
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
            */
            //if (sqlite3_step(theStat) != SQLITE_ROW)
            if(TRUE)
            {
                tSQL = @"";
                
                
                tSQL = [ tSQL stringByAppendingFormat:@"Delete From news where _id=%@ and secID=%@", nID, sID];
                NSLog(@" ## [%@]", tSQL);
                
                chrSQL = (char*) [tSQL UTF8String];
                theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
                NSLog(@"Delete:  %@", tSQL);
                
                tSQL = @"";
                
                tSQL = [ tSQL stringByAppendingFormat:@"Delete From newsRead where _id=%@ and secID=%@", nID, sID];
                NSLog(@" ## [%@]", tSQL);
                
                chrSQL = (char*) [tSQL UTF8String];
                theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
                NSLog(@"Delete:  %@", tSQL);
                
                tSQL = @"";
                
                tSQL = [ tSQL stringByAppendingFormat:@"Insert Into newsDeleted ( _id, secID ) values ('%@','%@')", nID, sID];
                NSLog(@" ## [%@]", tSQL);
                
                chrSQL = (char*) [tSQL UTF8String];
                theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
                NSLog(@"Inserting:  %@", tSQL);
                
                tSQL = @"";
            }
            
            
            [txtView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
            
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        
    }
}
- (IBAction)btnDeleteClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"حذف الخبر"];
    [alert setMessage:@"الرجاء تأكيد حذف الخبر"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"إلغاء"];
    [alert addButtonWithTitle:@"موافق"];
    //tag 1 : Delete News
    alert.tag = 1;
    [alert show];
}

- (void) changeTextSize:(NSString *) newSize
{
    @try {
                 
        NSString * testText;    
        
        //Get the HTML code from the UIWebView
        testText = [txtView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]; 
        
        NSRange searchRange = NSMakeRange(0, [testText length]);
        NSRange foundRange;
       // int counter = 0;
        while (searchRange.location < [testText length]) {
            searchRange.length = [testText length] - searchRange.location;
            foundRange = [testText rangeOfString:@"font-size:" options:nil range:searchRange];
            if (foundRange.location != NSNotFound) {
               // counter++;
                //move to the place of the number and modify the size of the raplacemnet
                foundRange.location = foundRange.location + foundRange.length+1;
                foundRange.length = 2;
                
               // if (counter == 3) {
                    //Replace with the new size
                    testText = [testText stringByReplacingCharactersInRange:foundRange withString:newSize];
                    
                //    counter = 0;
               //     break;
              //  }
               
                
                searchRange.location = foundRange.location+foundRange.length;
            }
            else
            {
                // no more found
                break;
            }
        }
        
        //Find the Font-size style
        /*
        NSRange pos = [testText rangeOfString:@"font-size:"];
        
        if ( pos.length > 0  )
        {
            //move to the place of the number and modify the size of the raplacemnet
            pos.location = pos.location + pos.length+1;
            pos.length = 2;
            
            //Replace with the new size
            testText = [testText stringByReplacingCharactersInRange:pos withString:newSize];
        }
        else
        {
            NSString * ResultHTML;
            
            ResultHTML = [[NSString alloc] initWithString:@"  "];
            
            ResultHTML = [ResultHTML stringByAppendingFormat:@"<html><head></head><body><p dir=\"rtl\" style=\"text-align: justify;\"><span style=\"font-size: %@px;\">%@</span></p></body></html>", newSize, testText];
            
            testText = ResultHTML;
            //[ResultHTML release];
        }
        */
        //Review the text in the view
        [txtView loadHTMLString:testText baseURL:nil];  
        
        
        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"RD:202"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
    }
    
}

- (IBAction) butSize01Click:(id) sender     
{   //[txtFont :18]; 
    //[self changeTextSize:@"18"];
    if (NewsFontSize == 18) {
        NewsFontSize = 24;
        [sender setImage:[UIImage imageNamed:@"size02.png"] forState:normal];
    }
    else if (NewsFontSize == 24)
    {
        NewsFontSize = 30;
        [sender setImage:[UIImage imageNamed:@"size03.png"] forState:normal];
    }
    else if (NewsFontSize == 30)
    {
        NewsFontSize = 40;
        [sender setImage:[UIImage imageNamed:@"size04.png"] forState:normal];
    }
    else
    {
        NewsFontSize = 18;
        [sender setImage:[UIImage imageNamed:@"size01.png"] forState:normal];
    }
    NSString * newSize  = [NSString stringWithFormat:@"%i",NewsFontSize];
    
    [self changeTextSize:newSize];
    
     
}

- (IBAction) butCloseClick:(id)sender
{

    [txtView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - SQL

- (void) saveReadNews: (NSString *) newsId
{
    NSLog(@"News ID %@", newsId);
    
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    tSQL = [tSQL stringByAppendingFormat: @"select * FROM newsRead where _id = '%@' and secID = '%@'", newsId, sID];;
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    if (sqlite3_step(theStat) != SQLITE_ROW)
    {
        
        tSQL = @"";
        
        
        tSQL = [ tSQL stringByAppendingFormat:@"Insert Into newsRead ( _id, secID ) values ('%@','%@')", newsId, sID];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"Inserting:  %@", tSQL);
        
        tSQL = @"";
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
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // If you go to the folder below, you will find those pictures
        NSLog(@"%@",docDir);
        
        NSLog(@"saving png");
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir, rFile];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data1 writeToFile:pngFilePath atomically:YES];
        
        //NSLog(@"saving jpeg");
        //NSString *jpegFilePath = [NSString stringWithFormat:@"%@/test.jpeg",docDir];
        //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        //[data2 writeToFile:jpegFilePath atomically:YES];
        
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

NSTimeInterval startTime;
NSMutableArray *bannersCollection;

- (void) updateStuff
{
    startTime = 0 ;
        [self getBanners];
}


- (void) getBanners
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //Send the sql
    NSString * imgFile = [docDir stringByAppendingFormat:@"/"];
    
    NSMutableArray *bannersArray = [[NSMutableArray alloc] init];
    bannersCollection = [[NSMutableArray alloc] init];

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
            UIImage *image = [UIImage imageWithContentsOfFile:imgFile];
           // image.bannerURL = [newsD bnrImg];
            
            [bannersArray addObject:image];
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
        @try
        {
            UIImage *image = [UIImage imageWithContentsOfFile:imgFile];
            //BannerImage *imageB = [BannerImage imageWithContentsOfFile:imgFile];
            //imageB.bannerURL = [newsD bnrLink];
            [bannersArray addObject:image];
        }
        @catch (NSException *exception) {
            NSLog(@"The image is not found %@",imgFile);
        }
        
        
        
    }
    
    //  [bannersArray addObject:[UIImage imageNamed:@"1.jpg"]];
    //   [bannersArray addObject:[UIImage imageNamed:@"2.jpg"]];
    // [bannersArray addObject:nil];
    
    
    
    _bannerImage.animationImages = bannersArray;
    _bannerImage.userInteractionEnabled = TRUE;
    
    
    _bannerImage.animationDuration = 5* ([bannersArray count]);
    _bannerImage.animationRepeatCount = 0;
    
    [_bannerImage startAnimating];
    startTime = [[NSDate date] timeIntervalSince1970];
    
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
    _bannerImage.userInteractionEnabled = YES;
    [_bannerImage addGestureRecognizer:myTapGesture];
    
   // [_btnBanner setBackgroundImage:[UIImage imageWithContentsOfFile:imgFile] forState:normal];
}

#pragma mark - Banner OpenURL
-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture
{
      
    NSTimeInterval duration = [[NSDate date] timeIntervalSince1970] - startTime;
    NSLog(@"Duration %i", (int)duration);
    NSLog(@"Start Time %i", (int)startTime);
    NSLog(@"Animation Duration %i",(int) [_bannerImage animationDuration]);
    int currentFrame = duration/([_bannerImage animationDuration]/[[_bannerImage animationImages] count]);
    
    if (currentFrame >= [bannersCollection count]) {
        currentFrame = currentFrame % [bannersCollection count];
    }
    NSLog(@"Cuurent Frame %i",currentFrame);
    
    
    if (currentFrame < [bannersCollection count]) {
        BannerInfo *banerInst = [bannersCollection objectAtIndex:currentFrame];
        NSLog(@"Banner Clicked %@",[banerInst bnrLink]);
        
        if ([[banerInst bnrLink] substringToIndex:4]==@"http") {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[banerInst bnrLink]]];
        }
        else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://" stringByAppendingFormat:[ banerInst bnrLink]]]];
        }
    }
    
}

@end
