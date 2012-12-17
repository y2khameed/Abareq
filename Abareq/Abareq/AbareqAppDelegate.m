//
//  AbareqAppDelegate.m
//  Abareq
//
//  Created by ALI AL-AWADH on 8/26/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "AbareqAppDelegate.h"
#import "globalVars.h"
#import "AbareqViewController.h"
#import "NewsController.h"
#import "ContactUs.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@implementation AbareqAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController = _navController;
@synthesize token;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //prepare DB Connection
    dbConnt = [[dbConnection alloc] init];
    [dbConnt StartConnection:@"Abareq.db"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[AbareqViewController alloc] initWithNibName:@"AbareqViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:_viewController];
    
    self.window.rootViewController = self.navController;
   // self.window.rootViewController = self.viewController;
    
    
    // if opened from Notification
    if (launchOptions != nil)
    {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (dictionary != nil)
        {
            NSString *screenName =[dictionary objectForKey:@"s"];
            //News
            if([screenName isEqualToString:@"n"])
            {
                // NSLog(@"our screen is %@",[screenInfo objectForKey:@"screen"]);
                
                //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                //[[UIApplication sharedApplication] cancelAllLocalNotifications];
                
                NewsController *newViewController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
                newViewController.nID = [dictionary objectForKey:@"i"];
                newViewController.reLoad = TRUE;
                
                newViewController.secID = [dictionary objectForKey:@"c"];
                
                [self.navController pushViewController:newViewController animated:FALSE];
            }
            //contact US
            else if([screenName isEqualToString:@"c"] || [screenName isEqualToString:@"hc"])
            {
                //   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                // [[UIApplication sharedApplication] cancelAllLocalNotifications];
                
                ContactUs *contactUs = [[ContactUs alloc] initWithNibName:@"ContactUs" bundle:nil];
                contactUs.mID = [dictionary objectForKey:@"i"];
                contactUs.mType = screenName;
                
                [self.navController pushViewController:contactUs animated:TRUE];
            }  
        }
    }
    //hide bar to add custome back methods
    [self.navController setNavigationBarHidden:YES];
    
    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark - Push Notification
- (void) registerDevice: (NSString *) mtoken
{
    // Get device unique ID
    UIDevice *device = [UIDevice currentDevice];
    NSString *uniqueIdentifier = [device uniqueIdentifier];
    if ([[device model] isEqualToString:@"iPhone Simulator"] ) {
        uniqueIdentifier = @"73967c9358810459bfe0f1a900581b0993e487be";
    }
    // NSString *temUrl = [URL_REGISTER_CHECK stringByAppendingFormat:@"?deviceID=%@&token=%@", uniqueIdentifier,token];
    
    // NSLog(@"URL %@",temUrl);
    
    [self saveDeviceToken:uniqueIdentifier token:mtoken];
    NSString * current = [self getCurrentNotificationStatus];
    if ([current isEqualToString:@"TRUE"]) {
        NSURL *url = [NSURL URLWithString:URL_REGISTER_TOKEN];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:uniqueIdentifier forKey:@"deviceID"];
        [request setPostValue:mtoken forKey:@"token"];
        [request setPostValue:@"iPhone" forKey:@"mobileType"];
        [request setDelegate:self];
        if ([mtoken length]>5) {
            [request startAsynchronous];
        }
        
    }
    
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    //remove white spaces from DeviceTokem
    //remove < > from deviceToken
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self setToken:newToken];
    
    
    // Send Data to Data Provider to save the device Token in order to use it for sending Push Notification.
    
    [self registerDevice:newToken];
    
    
    //self.registered = YES;
}



- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
   // [self registerDevice:@"123456789"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([application applicationState]==UIApplicationStateInactive) {
        NSLog(@"the user tapped the action button");
        for (id key in userInfo) {
            NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
        }
        
        
        
        if (userInfo != nil) {
            NSLog(@"push %@",userInfo );
            //NSDictionary *screenInfo = [dictionary objectForKey:@"screen"];
            
            NSString *screenName =[userInfo objectForKey:@"s"];
            //News
            if([screenName isEqualToString:@"n"])
            {
                // NSLog(@"our screen is %@",[screenInfo objectForKey:@"screen"]);
                
                //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                //[[UIApplication sharedApplication] cancelAllLocalNotifications];
                
                NewsController *newViewController = [[NewsController alloc] initWithNibName:@"NewsController" bundle:nil];
                newViewController.nID = [userInfo objectForKey:@"i"];
                newViewController.reLoad = TRUE;
                
                newViewController.secID = [userInfo objectForKey:@"c"];
                
                [self.navController pushViewController:newViewController animated:FALSE];
            }
            //contact US
            else if([screenName isEqualToString:@"c"] || [screenName isEqualToString:@"hc"])
            {
                //   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                // [[UIApplication sharedApplication] cancelAllLocalNotifications];
                
                ContactUs *contactUs = [[ContactUs alloc] initWithNibName:@"ContactUs" bundle:nil];
                contactUs.mID = [userInfo objectForKey:@"i"];
                contactUs.mType = screenName;
                
                [self.navController pushViewController:contactUs animated:TRUE];
            }
        }
        
    }
    else if ([application applicationState]==UIApplicationStateActive)
    {
        //add remote noification
        NSLog(@"he application was frontmost when it received the notification");
        
        NSString *alertMsg;
        NSString *badge;
        NSString *sound;
        
        if( [[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != NULL)
        {
            alertMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        }
        else
        {    alertMsg = @"{no alert message in dictionary}";
        }
        
        if( [[userInfo objectForKey:@"aps"] objectForKey:@"badge"] != NULL)
        {
            badge = [[userInfo objectForKey:@"aps"] objectForKey:@"badge"];
        }
        else
        {    badge = @"{no badge number in dictionary}";
        }
        
        if( [[userInfo objectForKey:@"aps"] objectForKey:@"sound"] != NULL)
        {
            sound = [[userInfo objectForKey:@"aps"] objectForKey:@"sound"];
        }
        else
        {    sound = @"{no sound in dictionary}";
        }
        
        //  AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        
        //  NSString* alert_msg = [NSString stringWithFormat:@"APNS message '%@' was just received.",alertMsg];
        
        //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UI_ALERT_MESSAGE_VIEW__CAPTION message:alert_msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //  [alert show];
    }
    else
    {
        NSLog(@"Applicaion running in Background");
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
        
       // NSLog(@"----  %@  ----",[request description]);
               
    }   
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
}


#pragma mark - Others

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSLog(@"Salam Shababa +++++++++@@@@@@@@@@@@@@@@");
    _viewController.reLoad = TRUE;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    
    //[_viewController viewDidAppear:TRUE];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
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

- (void) saveDeviceToken: (NSString *) udid token:(NSString *)mToken
{
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    tSQL = @"DELETE FROM device";
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
    NSLog(@"DELETING:  %@", tSQL);
    
    tSQL = @"";
    
    tSQL = [ tSQL stringByAppendingFormat:@"Insert into device Values ('%@', '%@')", udid, mToken];
    
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
    NSLog(@"Inserting:  %@", tSQL);
    
    tSQL = @"";

}
@end
