//
//  dbConnection.m
//  FamilyTree
//
//  Created by ALI AL-AWADH on 9/7/11.
//  Copyright 2011 INNOFLAME. All rights reserved.
//

#import "dbConnection.h"

dbConnection* dbConnt;


@implementation dbConnection

@synthesize myDB;

- (Boolean) StartConnection:(NSString *) dbName
{
    @try 
    {
        NSLog(@"Connection Method STARTED");
        //geting the DB path
        // Because the database is in the resources folder, you can access it directly using the bundle’s resourcePath
        NSFileManager * fMang = [NSFileManager defaultManager];
        
        //TestDB.sqlite is the name of the database
        NSString* theDBPath = [[[NSBundle mainBundle] resourcePath]
                               stringByAppendingPathComponent:dbName]; 
        
        NSLog(@"theDBPath = %@", theDBPath);
        
        //Check if we found the db
        BOOL success = [fMang fileExistsAtPath:theDBPath]; 
        if (!success) 
        {
            NSLog(@"Failed to find database file '%@'.", theDBPath);
            return FALSE;
        }
        else
        {
            //copy the database to the doc folder
            
            //Find the needed paths
            NSArray  * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);

            NSString * documentsDir = [paths objectAtIndex:0];
            NSLog(@"documentsDir = %@", documentsDir);

            NSString * pathLocal = [documentsDir stringByAppendingPathComponent:dbName];
            NSLog(@"pathLocal = %@", pathLocal);

            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //Copy the database
            NSError *error;

            BOOL success;
            success = [fileManager copyItemAtPath:theDBPath toPath:pathLocal error:&error];            
            
            theDBPath = pathLocal;

            NSLog(@"theDBPath = %@", theDBPath);
        }
        
        //Opne the database after getting its Path
        if (!(sqlite3_open([theDBPath UTF8String], &myDB) == SQLITE_OK)) 
        {   //&myDB is the database hundler defined at dbConnection.h file
            
            //Error on opening the database
            NSLog(@"An error opening database, normally handle error here.");
            return FALSE;
        }
        
       // [fMang release];
        
        //Database was open successfully
        return TRUE;
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"DB:101"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
      //  [alert release];        
    }
    return false;
}

- (sqlite3_stmt *) SendSQL: (char *) SQLStatment SelectSQL:(BOOL) SelectSQL;
{
    
    @try 
    {
        sqlite3_stmt *theStatment;
        
        int rRe = sqlite3_prepare_v2(myDB, SQLStatment, -1, &theStatment, NULL) ;
        //SendSQL
        if (rRe != SQLITE_OK) 
        {   
            NSLog(@"Error, failed to prepare statement, handle error here. ");
            return NULL;
        }
        else
        {   
            if (SelectSQL == false)
            {    
                sqlite3_step(theStatment);
                sqlite3_finalize(theStatment);
                
                if (rRe != 101) 
                {  //anything except 101 (SQLITE_DONE for delete, *not* SQLITE_OK)
                    NSLog(@"couldn't delete : result code %i", rRe);
                }
                else 
                {
                    NSLog(@"deleted OK!");
                }
            }
 
            return theStatment;
        }
 
    } //Try Block END        
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"DB:102"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
       // [alert release];        
    }

    return nil;
}    

- (void) CloseDB
{   sqlite3_close(myDB);    
    NSLog(@"DB Closed OK!");
}

- (int) fetchInterger: (sqlite3_stmt *) StatmentIN ColID:(int) ColID;
{   //read integer
    @try {
    return sqlite3_column_int(StatmentIN, ColID);
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"DB:003"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
       // [alert release];        
    }
    return 0;
}

- (NSString *) fetchString: (sqlite3_stmt *) StatmentIN ColID:(int) ColID;
{   /*Read String: String should be a C string so we need to convert it to NSString using stringWithUTF8String from the NSStirng class.         */
    @try {
    char *localityChars = (char*) sqlite3_column_text(StatmentIN, ColID);
    
    if (localityChars == nil) 
        return @"";
    else 
        return [NSString stringWithUTF8String:localityChars];
    }
    @catch (NSException *e) 
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:[NSString stringWithFormat: @"حصل خطأ في البرنامج : خطأ رقم : %@", @"DB:104"]];
        [alert setMessage:@""];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"حسناً"];
        [alert show];
      //  [alert release];        
    }
    
    return @"";
}

@end
