//
//  NSObject+dbFile.m
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 17/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "dbFile.h"

static dbFile *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation dbFile

+(dbFile*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];}
    return sharedInstance;
}
//create database
-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"player.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
            char *errMsg;
            NSString *sql_stmts = [NSString stringWithFormat: @"create table if not exists playerDetail (playerId integer primary key, name text, score text)"];
            if (sqlite3_exec(database, [sql_stmts UTF8String], NULL, NULL, &errMsg)!= SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Failed to create table");}
            sqlite3_close(database);
            return  isSuccess;}
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");}}
    return isSuccess;
}

//save the player information in the database
- (BOOL) saveData:(NSString*)name :(NSString*)score;{
    int playerIds = [self getRowCount];
    playerIds++;
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"insert into playerDetail (playerId,name, score) values (\"%d\",\"%@\", \"%@\")",playerIds, name, score];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            return YES;}
        else {return NO;}
        //sqlite3_reset(statement);
    }
    return NO;
}

//get the all player information from the database
- (NSArray*) findByPlayerId{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from playerDetail"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *pId = [[NSString alloc]initWithUTF8String:
                                 (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:pId];
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:name];
                NSString *score = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:score];
                
                return resultArray;}
            else{
                NSLog(@"Not found");
                return nil;}
            //sqlite3_reset(statement);
        }
    }
    return nil;
}

//get all player names
-(NSArray*)getPlayerName{
    NSMutableArray * name = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        const char *sqlStatement = "SELECT name FROM playerDetail";  // Your Tablename
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            [name removeAllObjects];
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                [name addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];}}
        sqlite3_finalize(compiledStatement);}
    sqlite3_close(database);
    return name;
}

//get all player scores
-(NSArray*)getPlayerScore{
    NSMutableArray * score = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        const char *sqlStatement = "SELECT score FROM playerDetail";  // Your Tablename
        sqlite3_stmt *compiledStatement;
        
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            [score removeAllObjects];
            while(sqlite3_step(compiledStatement) == SQLITE_ROW){
                [score addObject:[NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(compiledStatement, 0)]];}}
        sqlite3_finalize(compiledStatement);}
    sqlite3_close(database);
    return score;
}


//get number of rows in database
- (int)getRowCount{
    int count = 0;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        const char* sqlStatement = "SELECT COUNT(*) FROM playerDetail";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK ){
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW ){
                count = sqlite3_column_int(statement, 0);}
        }
        else{
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );}
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return count;
}
@end
