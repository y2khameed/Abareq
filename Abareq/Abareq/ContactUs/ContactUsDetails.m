//
//  ContactUsDetails.m
//  mHajj
//
//  Created by ALI AL-AWADH on 5/25/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "ContactUsDetails.h"
#import <QuartzCore/QuartzCore.h>

@interface ContactUsDetails ()
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webViewContactUs;


- (IBAction)btnCloseClicked:(id)sender;

@property (nonatomic, unsafe_unretained) IBOutlet UIView *backgroundView;

@end


@implementation ContactUsDetails
@synthesize webViewContactUs;
@synthesize htmlCode = _htmlCode;
@synthesize backgroundView = _backgroundView;

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
    //white border
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundView.layer.borderWidth = 3.0f;
    self.backgroundView.layer.cornerRadius = 10.0f;
    //[webViewContactUs setHidden:TRUE];

    //self.webViewContactUs.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.webViewContactUs.layer.borderWidth = 3.0f;
    //self.webViewContactUs.layer.cornerRadius = 10.0f;
    
    [webViewContactUs loadHTMLString:_htmlCode baseURL:nil];
}

- (void)viewDidUnload
{
    [self setWebViewContactUs:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnCloseClicked:(id)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
   // [self willMoveToParentViewController:nil];
   // [self.view removeFromSuperview];
   // [self removeFromParentViewController];
    
    [self dismissFromParentViewController];

}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)dismissFromParentViewController
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)presentInParentViewController:(UIViewController *)parentViewController
{
    //[parentViewController.view addSubview:self.view];
    //[parentViewController addChildViewController:self];
    //[self didMoveToParentViewController:parentViewController];
    
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.7f],
                              [NSNumber numberWithFloat:1.2f],
                              [NSNumber numberWithFloat:0.9f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
    
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.334f],
                                [NSNumber numberWithFloat:0.666f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
    
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       nil];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
}
@end
