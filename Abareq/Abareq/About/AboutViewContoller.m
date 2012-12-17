//
//  AboutViewContoller.m
//  iWS
//
//  Created by ALI AL-AWADH on 7/2/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "AboutViewContoller.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AboutUsApp.h"
#import "globalVars.h"

@implementation AboutViewContoller

@synthesize viewFile;
@synthesize aboutUsAppCollection;
NSString *defaultApps;
NSString *imgURL = @"<a href=\"%@\"><img src=\"%@\" alt=\"%@\"  height=\"32\" width=\"32\"/></a>&nbsp;";

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
    
    //Load aboutus app
    aboutUsAppCollection = [[NSMutableArray alloc] init];

    NSURL *url = [NSURL URLWithString:@"http://www.innoflame.com/aboutApp/getApp.php?cat"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    defaultApps = @"";
}

- (void)viewDidUnload
{
    aboutImg = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

- (IBAction)btn_exit:(id)sender {
    
    [webViewer loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
    //[self dismissModalViewControllerAnimated:YES];  
}

-(void) viewWillAppear:(BOOL)animated
{
    
   // defaultApps = @"<img src=\"icon57.png\" alt=\"Abariq App\"  height=\"32\" width=\"32\"/>&nbsp;<img src=\"alhuda_icon.png\" alt=\"Abariq App\"  height=\"32\" width=\"32\"/>&nbsp;<img src=\"sharallah_icon.png\" alt=\"Abariq App\"  height=\"32\" width=\"32\"/>&nbsp;<img src=\"hajj_icon.png\" alt=\"Abariq App\"  height=\"32\" width=\"32\"/>";
    //Load HTML
    [self loadWebView];
    }

#pragma mark - HTTP request

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    AboutUsApp *bannerInstance;
    NSData *jsonData = [request responseData];
    
    NSError *jsonParseErro = nil;
    
    
    
    if (jsonData == nil) {
        NSLog(@"ERROR");
    }
    else
    {
        if ([aboutUsAppCollection count] != 0) {
            [aboutUsAppCollection removeAllObjects];
        }
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
        
        for (int i=0; i< [jsonArray count]; i++) 
        {
            
            
            NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
            
            for (id key in jsonDic) {
                NSLog(@"key: %@, value: %@", key, [jsonDic objectForKey:key]);
            } 
            
            bannerInstance = [[AboutUsApp alloc] init];
            
            [bannerInstance setAppName:[jsonDic objectForKey:@"appName"]];
            [bannerInstance setAppIcon:[jsonDic objectForKey:@"appIcon"]];
            [bannerInstance setCategory:[jsonDic objectForKey:@"category"]];
            [bannerInstance setAndroidLink:[jsonDic objectForKey:@"androidLink"]];
            [bannerInstance setIPhoneLink:[jsonDic objectForKey:@"iPhoneLink"]];
            
            [aboutUsAppCollection addObject:bannerInstance];
        }   
        // save comments to SQL
        [self saveAboutUsApp];
        //display comments
        //[_newsTable reloadData];

    }
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request 
{
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //Send the sql
    NSString * imgFile = [docDir stringByAppendingFormat:@"/"];
    
    NSMutableArray *bannersArray = [[NSMutableArray alloc] init];
    NSLog(@"Parser Error, DB read");
    
    NSString * sqlStat = [[NSString alloc] initWithFormat:@""];    
    sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM AboutUsApps"];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    AboutUsApp *newsD = [[AboutUsApp alloc] init];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        
        [newsD setAppName:[dbConnt fetchString:theStat ColID:0]];
        [newsD setAppIcon:[dbConnt fetchString:theStat ColID:1]];
        [newsD setIPhoneLink:[dbConnt fetchString:theStat ColID:2]];
        
        [aboutUsAppCollection addObject:newsD];
        
        imgFile = [imgFile stringByAppendingFormat:[newsD appIcon]];
        NSLog(@"%@", imgFile);
        @try {
            [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
            defaultApps = [defaultApps stringByAppendingFormat:imgURL,[newsD iPhoneLink],imgFile,[newsD appName] ];
        }
        @catch (NSException *exception) {
            NSLog(@"The image is not found %@",imgFile);
        }
        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {
        imgFile = [docDir stringByAppendingFormat:@"/"];
        
        newsD = [[AboutUsApp alloc] init];
        
        [newsD setAppName:[dbConnt fetchString:theStat ColID:0]];
        [newsD setAppIcon:[dbConnt fetchString:theStat ColID:1]];
        [newsD setIPhoneLink:[dbConnt fetchString:theStat ColID:2]];

        [aboutUsAppCollection addObject:newsD];
        
        imgFile = [imgFile stringByAppendingFormat:[newsD appIcon]];
        NSLog(@"%@", imgFile);
        @try {
            [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
            defaultApps = [defaultApps stringByAppendingFormat:imgURL,[newsD iPhoneLink],imgFile,[newsD appName] ];
        }
        @catch (NSException *exception) {
            NSLog(@"The image is not found %@",imgFile);
        }
    }
    
    [self loadWebView];

       
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - SQL
-(void) saveAboutUsApp
{
    for (AboutUsApp *a in aboutUsAppCollection) {
        NSLog(@"%@",[a appName]);
    }
    
    @try {
        
        NSLog(@"all done!");
        
        char * chrSQL;
        
        NSString * tSQL = [[NSString alloc] initWithFormat:@""];
        
        NSMutableArray *bannersArray = [[NSMutableArray alloc] init];
        
        sqlite3_stmt * theStat;
        
        
        tSQL = [ tSQL stringByAppendingFormat:@"DELETE FROM AboutUsApps"];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"DELETING:  %@", tSQL);
        
        tSQL = @"";
        
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //Send the sql
        NSString * imgFile = @"";
        AboutUsApp *bannerInst;
        
        defaultApps = @"";
        for (int I = 0; I< [aboutUsAppCollection count]; I++) 
        {
            imgFile = [docDir stringByAppendingFormat:@"/"];
            bannerInst = [aboutUsAppCollection objectAtIndex:I];
            //Save the Picture
            imgFile = [imgFile stringByAppendingFormat:[bannerInst appIcon]];
            
            [self SaveFileFromURL:[@"http://www.innoflame.com/aboutApp/icons/" stringByAppendingFormat:[bannerInst appIcon]] ResultFileName:imgFile ];
            
            //Save the file name
            tSQL = [tSQL stringByAppendingFormat:@"INSERT INTO AboutUsApps (appName, appIcon, iPhoneLink) VALUES ('%@', '%@', '%@')",[bannerInst appName] ,[bannerInst appIcon], [bannerInst iPhoneLink]];
            
            
            
            chrSQL = (char*) [tSQL UTF8String];
            
            NSLog(@" ## [%@]", tSQL);
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
            
            //NSLog(@"%@", theStat);
            
            tSQL = @"";
            NSLog(@"%@", imgFile);
            //[bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
            
            @try {
                [bannersArray addObject:[UIImage imageWithContentsOfFile:imgFile]];
                defaultApps = [defaultApps stringByAppendingFormat:imgURL,[bannerInst iPhoneLink],imgFile,[bannerInst appName] ];
            }
            @catch (NSException *exception) {
                NSLog(@"The image is not found %@",imgFile);
            }
         
            imgFile = @"";
            
        }
        
        [self loadWebView];
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
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
         [data1 writeToFile:rFile atomically:YES];
        
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
#pragma mark - WebView
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] scheme] isEqual:@"mailto"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return false;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}

- (void) loadWebView
{
    NSLog(@"Resulted URL = %@", viewFile);
    NSURL *url = [[NSBundle mainBundle] URLForResource:viewFile withExtension:@"html"];
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    
    html = [@"" stringByAppendingFormat:html, defaultApps];
    
    [webViewer loadHTMLString:html baseURL:baseURL];
    [webViewer canGoBack];
    
    NSLog(@"%@",html);    
   
}
@end
