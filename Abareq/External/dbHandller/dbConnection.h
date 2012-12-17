//
//  dbConnection.h
//  FamilyTree
//
//  Created by ALI AL-AWADH on 9/7/11.
//  Copyright 2011 INNOFLAME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface dbConnection : NSObject
{    
    //Declare the DB main handler in the class
    sqlite3 *myDB;
}

@property (nonatomic, assign) sqlite3 * myDB;

- (Boolean) StartConnection: (NSString *) dbNames;

- (sqlite3_stmt *) SendSQL: (char *) SQLStatment SelectSQL:(BOOL) SelectSQL;

- (int) fetchInterger: (sqlite3_stmt *) StatmentIN ColID:(int) ColID;
- (NSString *) fetchString: (sqlite3_stmt *) StatmentIN ColID:(int) ColID;
- (void) CloseDB;

@end