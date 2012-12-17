//
//  NewsController.h
//  iWS
//
//  Created by ALI AL-AWADH on 5/19/12.
//  Copyright (c) 2012 INNOFLAME. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
    NSInteger _currentPage;
    NSInteger _totalPages;
}
- (IBAction)btnBackClicked:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *newsTable;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bannerImage;

@property (nonatomic, copy) NSString * nID;
@property (nonatomic, copy) NSString * secID;
@property (nonatomic, assign) BOOL * reLoad;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTittle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txtSearch;


- (void) UpdateNews;
- (void) UpdateAllNews;
- (IBAction)btnRefreshClicked:(id)sender;
- (IBAction)btnSearchClicked:(id)sender;

- (void) SaveFileFromURL:(NSString *) theURL ResultFileName: (NSString *) rFile;
- (void) saveReadNews: (NSString *) newsId;

- (void) getReadNews;
- (void) getDeletedNews;
- (void) getNewsFromSQL;
- (void) getNewsFromSQL:(NSString *)searchKey;

- (void) getBanners;
@end
