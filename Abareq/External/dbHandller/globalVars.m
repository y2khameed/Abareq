//
//  globalVars.m
//  FamilyTree
//
//  Created by ALI AL-AWADH on 9/9/11.
//  Copyright 2011 INNOFLAME. All rights reserved.
//

#import "globalVars.h"

dbConnection* dbConnt;

const char * Select_Person = "SELECT id, name || ' ' || ifNull(surname1, '') ||   ' ' || ifnull(surname2, '') Name";

@implementation globalVars


@end
