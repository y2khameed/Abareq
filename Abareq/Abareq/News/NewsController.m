//
//  NewsController.m
//  iWS
//
//  Created by ALI AL-AWADH on 5/19/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import "NewsController.h"
#import "NewsCell.h"
#import "NewsInfo.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "globalVars.h"
#import "NewsDisplay.h"
#import "BannerInfo.h"

static NSString *const NewsCellIdentifier = @"NewsCell";
static NSString *const NewsCellUIdentifier = @"NewsCellU";
static NSString *const NothingFoundCellIdentifier = @"NoNewsFoundCell";

const int kLoadingCellTag = 1273;

@implementation NewsController{
    NSMutableArray *newsCollection;
    NSMutableArray *readnews;
    NSMutableArray *deletedNews;
    
    NewsInfo *newsInstance;
    BOOL itemStart;
    NSString * currentElement;
    NSString * currentData;
}


@synthesize newsTable = _newsTable;
@synthesize bannerImage;
//for Push Notification
@synthesize nID;
@synthesize secID;
//NSInteger secID = 0;
@synthesize reLoad;
@synthesize lblTittle;
@synthesize txtSearch;

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
    
    
    UINib *cellNib = [UINib nibWithNibName:NewsCellIdentifier bundle:nil];
    [_newsTable registerNib:cellNib forCellReuseIdentifier:NewsCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NewsCellUIdentifier bundle:nil];
    [_newsTable registerNib:cellNib forCellReuseIdentifier:NewsCellUIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [_newsTable registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    _newsTable.rowHeight = 80;
    
    
    
    newsCollection = [[NSMutableArray alloc] init];
    newsInstance = [[NewsInfo alloc] init];
    
    
    
    readnews = [[NSMutableArray alloc] init];
    deletedNews = [[NSMutableArray alloc] init];
    [self getDeletedNews];
    [self getReadNews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStuff)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
//paging
    _currentPage = 0;
    
}

- (void)viewDidUnload
{
    [self setNewsTable:nil];
    
    [self setLblTittle:nil];
    [self setTxtSearch:nil];
    [self setBannerImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

bool openPush = FALSE;

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:TRUE];
    [self getBanners];
    if (reLoad)
    {
        //paging
        _currentPage = 0;
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل الأخبار...";
     //   [self UpdateNews];
        [newsCollection removeAllObjects];
        //[self getNewsFromSQL];
        [self UpdateNews];
        reLoad = FALSE;
        
        
        switch ([secID intValue]) {
            case 1:
                lblTittle.text = NSLocalizedString(@"News_sec1", nil);
                break;
            case 2:
                lblTittle.text = NSLocalizedString(@"News_sec2", nil);
                break;
            case 3:
                lblTittle.text = NSLocalizedString(@"News_sec3", nil);
                break;
            case 4:
                lblTittle.text = NSLocalizedString(@"News_sec4", nil);
                break;
            case 5:
                lblTittle.text = NSLocalizedString(@"News_sec5", nil);
                break;
            case 6:
                lblTittle.text = NSLocalizedString(@"News_sec6", nil);
                break;
            case 7:
                lblTittle.text = NSLocalizedString(@"News_sec7", nil);
                break;
            case 8:
                lblTittle.text = NSLocalizedString(@"News_sec8", nil);
                break;

            default:
                break;
        }
        
        if ([nID length] >0 && openPush) {
            @try {
                NewsDisplay *ShowDetils = [[NewsDisplay alloc] initWithNibName:@"NewsDisplay" bundle:nil];
                
                for (int i=0; i<[newsCollection count]; i++) 
                {
                    NewsInfo * newsInst = [newsCollection objectAtIndex:i];
                    if ([[newsInst newsID] isEqualToString:nID]) 
                    {
                        NSLog(@"The imge: %@", [newsInst newsImage]);
                        
                        NSString *tempSummery = [[newsInst newsbody] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
                        
                        NSString * rString = [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\"><p style=\"font-size: 24px;text-align:Center;\">%@</p><p style=\"font-size: 14px;text-align:Right;Color:Green\">%@</p><p  dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\">%@</p><p align=\"center\"><img border=\"0\" width=\"300\" src=\"%@\" style=\"border:1px solid #ffffff;box-shadow: 1px 1px 2px #b0b0b0;\" /></p></body></html>",[newsInst newsTitle], [newsInst newsDate], tempSummery,[newsInst newsImage] ];
                        
                        NSLog(@"HTML: %@", rString);
                        
                        
                        ShowDetils.TheString = rString;
                        
                        ShowDetils.nID = [newsInst newsID];
                        ShowDetils.sID = secID;
                        
                        [self.navigationController pushViewController:ShowDetils animated:TRUE];
                        
                        [self saveReadNews:[newsInst newsID]];
                        
                        [readnews addObject:[newsInst newsID]];
                        [[newsCollection objectAtIndex:i]  setIsRead:@"1"];
                        
                        [_newsTable reloadData];
                        break;
                    }
                    
                    
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
    else
    {
        [readnews removeAllObjects];
        [newsCollection removeAllObjects];
        [deletedNews removeAllObjects];
        
        [self getDeletedNews];
        [self getReadNews];
        [self getNewsFromSQL];
        [_newsTable reloadData];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Button Actions

- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}


- (IBAction)btnRefreshClicked:(id)sender {
    // Start hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"جاري تحميل الأخبار...";

    [self UpdateNews];

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
        
        
        [newsCollection removeAllObjects];
        if ([txtSearch.text length]>2) 
        {
            [self getNewsFromSQL:txtSearch.text];
        }
        else
        {
            [self getNewsFromSQL];
        }
        
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (newsCollection == nil) {
        return 0;
    }
    else if([newsCollection count] == 0)
    {
        return 1;
    }
    else
    {
        if (_currentPage< (_totalPages*10)) {
            return [newsCollection count]+1;
        }
        
        return [newsCollection count];
    }
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc]
                              initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    //[activityIndicator release];
    
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([newsCollection count] == 0) {
        return [_newsTable  dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    }
    else
    {
        if (indexPath.row < [newsCollection count])
        {
            NewsCell * cell ;
            
            NewsInfo *searchResult = [newsCollection objectAtIndex:indexPath.row];
            
            if ([[searchResult isRead] isEqualToString:@"0"])
            {
                cell =(NewsCell *) [tableView dequeueReusableCellWithIdentifier:NewsCellUIdentifier];
                //cell =(NewsCell *) [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
            }
            else
            {
                cell =(NewsCell *) [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
            }
            
            cell.newsTitle.text = searchResult.newsTitle;
            cell.newsBody.text = searchResult.newsbody;
            cell.newsDate.text = searchResult.newsDate;
            
            
            return cell;

        }
        else{
            return [self loadingCell];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        _currentPage = _currentPage+10;
        [self UpdateNews];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        NewsDisplay *ShowDetils = [[NewsDisplay alloc] initWithNibName:@"NewsDisplay" bundle:nil];
        
        NewsInfo * newsInst = [newsCollection objectAtIndex:indexPath.row];
        NSString *imagePath = [URL_NEWS_IMAGE stringByAppendingFormat:[newsInst newsImage]];
        NSLog(@"The imge: %@", imagePath);
        
         NSString *tempSummery = [[newsInst newsbody] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
        
        NSString * rString = [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\"><p style=\"font-size: 24px;text-align:Center;\">%@</p><p style=\"font-size: 14px;text-align:Right;Color:Green\">%@</p><p  dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\">%@</p><p align=\"center\"><img border=\"0\" width=\"300\" src=\"%@\" style=\"border:1px solid #ffffff;box-shadow: 1px 1px 2px #b0b0b0;\" /></p></body></html>",[newsInst newsTitle],[newsInst newsDate], tempSummery, imagePath ];
        
        NSLog(@"HTML: %@", rString);
        

        ShowDetils.TheString = rString;
        
        ShowDetils.nID = [newsInst newsID];
        ShowDetils.sID = secID;
        
        [self.navigationController pushViewController:ShowDetils animated:TRUE];
        
        [self saveReadNews:[newsInst newsID]];
        
        [readnews addObject:[newsInst newsID]];
        [[newsCollection objectAtIndex:indexPath.row]  setIsRead:@"1"];
        
        [_newsTable reloadData];
        
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


#pragma mark - Custome
////////////////////////
/// Custome Methods
///////////////////////
- (void) UpdateNews
{
    @try {
        NSLog(@"Start The Update Method");

       // [newsCollection removeAllObjects];
        
        
        //NSURL *url = [NSURL URLWithString:[URL_NEWS stringByAppendingFormat:@"?secID=%@&limit=%d",secID,_currentPage]];
        NSURL *url = [NSURL URLWithString:URL_NEWS];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setPostValue:secID forKey:@"secID"];
        [request setPostValue:[NSString stringWithFormat:@"%d",_currentPage] forKey:@"limit"];
        [request setDelegate:self];
        [request startAsynchronous];

        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NEX:002"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];        
    }
}

- (void) UpdateAllNews
{
    @try {
        NSLog(@"Start The Update Method");
        
        [newsCollection removeAllObjects];
        
        
        NSURL *url = [NSURL URLWithString:URL_NEWS_ALL];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        //[request setPostValue:secID forKey:@"secID"];
        [request setDelegate:self];
        [request startAsynchronous];
        
        
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"NEX:002"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];        
    }
}

#pragma mark - SQL Operations

- (void) saveReadNews: (NSString *) newsId
{
    NSLog(@"News ID %@", newsId);
    
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@""];
    
    
    sqlite3_stmt * theStat;
    
    tSQL = [tSQL stringByAppendingFormat: @"select * FROM newsRead where _id = '%@' and secID = '%@'", newsId, secID];;
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    if (sqlite3_step(theStat) != SQLITE_ROW)
    {
        
        tSQL = @"";
        
        
        tSQL = [ tSQL stringByAppendingFormat:@"Insert Into newsRead ( _id, secID ) values ('%@','%@')", newsId, secID];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"Inserting:  %@", tSQL);
        
        tSQL = @"";
    }
}

- (void) getReadNews
{
    char * chrSQL;
    
    NSString * tSQL = [[NSString alloc] initWithFormat:@"select * FROM newsRead"];
    
    
    sqlite3_stmt * theStat;
    
    NSLog(@" ## [%@]", tSQL);
    
    chrSQL = (char*) [tSQL UTF8String];    
    theStat = [dbConnt SendSQL:chrSQL SelectSQL:TRUE];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        [readnews addObject:[dbConnt fetchString:theStat ColID:0]];
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        [readnews addObject:[dbConnt fetchString:theStat ColID:0]];
        
    }
    
    for (int i=0; i< [readnews count]; i++) {
        NSLog(@"Read News ID %@", [readnews objectAtIndex:i]);
    }
}

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


- (void) getNewsFromSQL
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@""];
    
    sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %@ order by _id DESC", secID];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    NewsInfo *newsD = [[NewsInfo alloc] init];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        
        [newsD setNewsDate:[dbConnt fetchString:theStat ColID:3]];
        [newsD setNewsTitle:[dbConnt fetchString:theStat ColID:1]];
        [newsD setNewsbody:[dbConnt fetchString:theStat ColID:2]];
        [newsD setNewsImage:[dbConnt fetchString:theStat ColID:4]];
        [newsD setNewsID:[dbConnt fetchString:theStat ColID:0]];
        
        if ([readnews indexOfObject:[dbConnt fetchString:theStat ColID:0]] == NSNotFound) {
            [newsD setIsRead:@"0"];
        }
        else
        {
            [newsD setIsRead:@"1"];
        }
        
        [newsCollection addObject:newsD];
        
        if ([nID isEqualToString:[newsD newsID]]) {
            openPush = TRUE;
        }
    }
   
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        newsD = [[NewsInfo alloc] init];
        [newsD setNewsDate:[dbConnt fetchString:theStat ColID:3]];
        [newsD setNewsTitle:[dbConnt fetchString:theStat ColID:1]];
        [newsD setNewsbody:[dbConnt fetchString:theStat ColID:2]];
        [newsD setNewsImage:[dbConnt fetchString:theStat ColID:4]];
        [newsD setNewsID:[dbConnt fetchString:theStat ColID:0]];
        
        if ([readnews indexOfObject:[dbConnt fetchString:theStat ColID:0]] == NSNotFound) {
            [newsD setIsRead:@"0"];
        }
        else
        {
            [newsD setIsRead:@"1"];
        }
        
        [newsCollection addObject:newsD];            
        
        if ([nID isEqualToString:[newsD newsID]]) {
            openPush = TRUE;
        }
    }
    
    if ([nID length]>0 && !openPush) {
        [self UpdateNews];
    }
    
       
    [_newsTable reloadData ];
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) getNewsFromSQL:(NSString *) searchKey
{
    NSString * sqlStat = [[NSString alloc] initWithFormat:@""];
    
    if (secID == nil) {
        
        sqlStat =[sqlStat stringByAppendingFormat:@"SELECT secID FROM News where _id = %@", nID];
        
        NSLog(@" ## [%@]", sqlStat);
        
        //Convert the NSStirng to char b/c SendSQL function accept char only
        char * chrSQL = (char*) [sqlStat UTF8String];    
        
        //Send the sql
        sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
        
        
        //Fetch the first item and init the arrayss
        if (sqlite3_step(theStat) == SQLITE_ROW)
        {
            secID = [dbConnt fetchString:theStat ColID:0];
        }
        else
        {
            
        }
        
        sqlStat = @"";
    }
    sqlStat =[sqlStat stringByAppendingFormat:@"SELECT * FROM News where secID = %@ and (tittle like '%%%@%%' or description like '%%%@%%') order by _id DESC", secID, searchKey, searchKey];
    
    NSLog(@" ## [%@]", sqlStat);
    
    //Convert the NSStirng to char b/c SendSQL function accept char only
    char * chrSQL = (char*) [sqlStat UTF8String];    
    
    //Send the sql
    sqlite3_stmt * theStat = [dbConnt SendSQL:chrSQL SelectSQL:true];
    
    NewsInfo *newsD = [[NewsInfo alloc] init];
    
    //Fetch the first item and init the arrayss
    if (sqlite3_step(theStat) == SQLITE_ROW)
    {
        
        [newsD setNewsDate:[dbConnt fetchString:theStat ColID:3]];
        [newsD setNewsTitle:[dbConnt fetchString:theStat ColID:1]];
        [newsD setNewsbody:[dbConnt fetchString:theStat ColID:2]];
        [newsD setNewsImage:[dbConnt fetchString:theStat ColID:4]];
        [newsD setNewsID:[dbConnt fetchString:theStat ColID:0]];
        
        if ([readnews indexOfObject:[dbConnt fetchString:theStat ColID:0]] == NSNotFound) {
            [newsD setIsRead:@"0"];
        }
        else
        {
            [newsD setIsRead:@"1"];
        }
        
        [newsCollection addObject:newsD];
        
        
    }
    
    //Fill up the array
    while( sqlite3_step(theStat) == SQLITE_ROW)
    {  
        newsD = [[NewsInfo alloc] init];
        [newsD setNewsDate:[dbConnt fetchString:theStat ColID:3]];
        [newsD setNewsTitle:[dbConnt fetchString:theStat ColID:1]];
        [newsD setNewsbody:[dbConnt fetchString:theStat ColID:2]];
        [newsD setNewsImage:[dbConnt fetchString:theStat ColID:4]];
        [newsD setNewsID:[dbConnt fetchString:theStat ColID:0]];
        
        if ([readnews indexOfObject:[dbConnt fetchString:theStat ColID:0]] == NSNotFound) {
            [newsD setIsRead:@"0"];
        }
        else
        {
            [newsD setIsRead:@"1"];
        }
        
        [newsCollection addObject:newsD];            
        
    }
    
    
    for (int i=0; i<[newsCollection count]; i++) {
        NSLog(@"News : %@", [[newsCollection objectAtIndex:i] newsTitle]);
    }
    
    [_newsTable reloadData ];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void) updateStuff
{
   // [self viewDidAppear:TRUE];
    bannerImage.animationDuration = 0;
    [self getBanners];
}

#pragma mark - Banner OpenURL
-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture
{
    
    NSTimeInterval duration = [[NSDate date] timeIntervalSince1970] - startTime;
    NSLog(@"Duration %i", (int)duration);
    NSLog(@"Start Time %i", (int)startTime);
    
    int currentFrame = duration/([bannerImage animationDuration]/[[bannerImage animationImages] count]);
    
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

#pragma mark - HTTP request
- (void) saveNews
{
    @try {
        
        NSLog(@"all done!");
        
        char * chrSQL;
        
        NSString * tSQL = [[NSString alloc] initWithFormat:@""];
        
        //tSQL = [[NSString alloc] init];
        
        sqlite3_stmt * theStat;
        
       
        tSQL = [ tSQL stringByAppendingFormat:@"DELETE FROM news where secID = %@", secID];
        NSLog(@" ## [%@]", tSQL);
        
        chrSQL = (char*) [tSQL UTF8String];    
        theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
        NSLog(@"DELETING:  %@", tSQL);
        
        tSQL = @"";
        
        //Delete all files
        
        //Prepare the path
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/NewsNo0.png",docDir];
        
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
        
        
        //Send the sql
        //NSString * imgFile = [[NSString alloc] initWithString:@""];
        NewsInfo *newsInst;
        for (int I = 0; I< [newsCollection count]; I++) 
        {
            newsInst = [newsCollection objectAtIndex:I];
            //Save the Picture
           // imgFile = [imgFile stringByAppendingFormat:@"NewsNo%i.png", I];
            //NSLog([newsInst newsImage]);
            //[self SaveFileFromURL:[newsInst newsImage] ResultFileName:imgFile ];
            
            //Save the file name
            tSQL = [tSQL stringByAppendingFormat:@"INSERT INTO news (_id, tittle, description, date, image, secID) VALUES ('%@', '%@', '%@', '%@', '%@', %@)",[newsInst newsID] ,[newsInst newsTitle], [newsInst newsbody], [newsInst newsDate], [newsInst newsImage], secID  ];
            
           // imgFile = @"";
            
            chrSQL = (char*) [tSQL UTF8String];
            
            NSLog(@" ## [%@]", tSQL);
            theStat = [dbConnt SendSQL:chrSQL SelectSQL:false];
            
            //NSLog(@"%@", theStat);
            
            tSQL = @"";
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
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    
    NSData *jsonData = [request responseData];
    
    NSError *jsonParseErro = nil;
    
    NSLog(@"URL: %@",[[request url] description]);
    
    if (jsonData == nil) {
        NSLog(@"ERROR");
    }
    else
    {
        if ([newsCollection count] != 0) {
           // [newsCollection removeAllObjects];
        }
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParseErro];
        
        for (int i=0; i< [jsonArray count]; i++) 
        {
            
            
            NSDictionary *jsonDic = [jsonArray objectAtIndex:i];
            
            for (id key in jsonDic) {
                NSLog(@"key: %@, value: %@", key, [jsonDic objectForKey:key]);
            } 
            
            newsInstance = [[NewsInfo alloc] init];
            _totalPages = [jsonDic objectForKey:@"TotalPages"];
            
            [newsInstance setNewsID:[jsonDic objectForKey:@"nID"]];
            [newsInstance setNewsTitle:[jsonDic objectForKey:@"nTitle"]];
            //NSString *tempSummery = [[jsonDic objectForKey:@"nSummary"] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
            [newsInstance setNewsbody:[jsonDic objectForKey:@"nSummary"]];
            [newsInstance setNewsDate:[jsonDic objectForKey:@"nDate"]];
            [newsInstance setNewsImage:[jsonDic objectForKey:@"nImgPath"]];
            
            if ([readnews indexOfObject:[newsInstance newsID]] == NSNotFound) {
                [newsInstance setIsRead:@"0"];
            }
            else
            {
                [newsInstance setIsRead:@"1"];
            }
            
            if ([deletedNews indexOfObject:[newsInstance newsID]] == NSNotFound)
            {
                [newsCollection addObject:newsInstance];
            }
            
            
        }   
        // save comments to SQL
        [self saveNews];
        //display comments
        [_newsTable reloadData];
    }
    NSLog(@"No Error");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([nID length] >0) {
        @try {
            NewsDisplay *ShowDetils = [[NewsDisplay alloc] initWithNibName:@"NewsDisplay" bundle:nil];
            
            for (int i=0; i<[newsCollection count]; i++) 
            {
                NewsInfo * newsInst = [newsCollection objectAtIndex:i];
                if ([[newsInst newsID] isEqualToString:nID]) 
                {
                    NSLog(@"The imge: %@", [newsInst newsImage]);
                    
                    NSString *tempSummery = [[newsInst newsbody] stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
                    
                    NSString * rString = [[NSString alloc] initWithFormat:@"<html><body dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\"><p style=\"font-size: 24px;text-align:Center;\">%@</p><p style=\"font-size: 14px;text-align:Right;Color:Green\">%@</p><p  dir=\"rtl\" style=\"font-size: 18px;text-align:justify;\">%@</p><p align=\"center\"><img border=\"0\" width=\"300\" src=\"%@\" style=\"border:1px solid #ffffff;box-shadow: 1px 1px 2px #b0b0b0;\" /></p></body></html>",[newsInst newsTitle],[newsInst newsDate], tempSummery, [newsInst newsImage] ];
                    
                    NSLog(@"HTML: %@", rString);
                    
                    
                    ShowDetils.TheString = rString;
                    
                    ShowDetils.nID = [newsInst newsID];
                    ShowDetils.sID = secID;
                    
                    [self.navigationController pushViewController:ShowDetils animated:TRUE];
                    
                    [self saveReadNews:[newsInst newsID]];
                    
                    [readnews addObject:[newsInst newsID]];
                    [[newsCollection objectAtIndex:i]  setIsRead:@"1"];
                    
                    [_newsTable reloadData];
                    break;
                }
                
                
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


- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    NSLog(@"requestFailed: %@", error);
    
    @try {
        NSLog(@"Parser Error, DB read");
        
        [self getNewsFromSQL];
       
        
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
