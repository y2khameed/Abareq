//
//  SettingView.m
//  Abareq
//
//  Created by ALI AL-AWADH on 9/9/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "SettingView.h"
#import "globalVars.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constants.h"
#import "MBProgressHUD.h"

@implementation SettingView
@synthesize lblEnable;
@synthesize lblDisable;
@synthesize btnEnableNotification;

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
    
    [self updateLabels];
    
}

- (void)viewDidUnload
{
    [self setLblEnable:nil];
    [self setLblDisable:nil];
    [self setBtnEnableNotification:nil];
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
#pragma mark - Buttin Actions

- (IBAction)btnEnableNotificationClicked:(id)sender 
{
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
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:uniqueIdentifier forKey:@"deviceID"];
    if ([current isEqualToString:@"TRUE"]) {
        [request setPostValue:@"unregister" forKey:@"op"];
    }
    [request setPostValue:mtoken forKey:@"token"];
    [request setPostValue:@"iPhone" forKey:@"mobileType"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


- (IBAction)btnBackClicked:(id)sender {
     [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - Others

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

#pragma mark - HTTP

- (void)requestFinished:(ASIHTTPRequest *)request 
{
    NSLog(@"request: %@", [request responseString]);
    
    NSData *jsonData = [request responseData];
    
    NSError *jsonParseErro = nil;
    
    
    if (jsonData == nil) 
    {
        NSLog(@"ERROR");
    }
    else
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:[NSString stringWithFormat: @"حالة الطلب"]];
    [alert setMessage:@"فشل تنفيذ الطلب الرجاء المحاولة مرة أخرى"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"حسناً"];
    [alert show];      
    
    
}


@end
