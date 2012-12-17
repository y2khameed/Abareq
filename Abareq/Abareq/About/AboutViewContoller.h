//
//  AboutViewContoller.h
//  iWS
//
//  Created by ALI AL-AWADH on 7/2/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewContoller : UIViewController <UIWebViewDelegate>{

IBOutlet NSString * viewFile;

IBOutlet UIWebView *  webViewer;
    
    __unsafe_unretained IBOutlet UIImageView *aboutImg;

}
- (IBAction)btn_exit:(id)sender;

@property (nonatomic, retain) IBOutlet NSString * viewFile;
@property (nonatomic, retain) NSMutableArray * aboutUsAppCollection;


- (void) saveAboutUsApp;

- (void) SaveFileFromURL:(NSString *) theURL ResultFileName: (NSString *) rFile;

- (void) loadWebView;
@end
