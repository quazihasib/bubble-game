//
//  NSObject+dbFile.h
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 17/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface dbFile:NSObject
{
    NSString *databasePath;
}

+(dbFile*)getSharedInstance;
-(BOOL)createDB;
- (BOOL)saveData:(NSString*)name :(NSString*)score;
-(NSArray*)findByPlayerId;
-(NSArray*)getPlayerName;
-(NSArray*)getPlayerScore;
-(int)getRowCount;
@end
