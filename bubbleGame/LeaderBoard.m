
//
//  UITableView+leaderBoard.m
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 16/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "LeaderBoard.h"
#import "GamePlay.h"
#import "dbFile.h"

NSArray *playerNames, *playerScores;

@implementation LeaderBoard:UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //get player names and scores from database
    @try {
        playerNames = [[dbFile getSharedInstance]getPlayerName];
        playerScores = [[dbFile getSharedInstance]getPlayerScore];
    } @catch (NSException *exception) {
        NSLog(@"player names and scores not found!");
    } @finally { }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return playerScores.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];}
    
    //text label for showing player names
    CGRect Label1Frame = CGRectMake(17,5,250,18);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:Label1Frame];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:nameLabel];
    nameLabel.text = [NSString stringWithFormat:@"%@", [playerNames objectAtIndex:indexPath.row]];
    
    //text label for showing player scores
    CGRect Label2Frame = CGRectMake(267,5,250,18);
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:Label2Frame];
    [scoreLabel setTextColor:[UIColor blackColor]];
    [scoreLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
    [scoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cell.contentView addSubview:scoreLabel];
    scoreLabel.text = [NSString stringWithFormat:@"%@", [playerScores objectAtIndex:indexPath.row]];
    
    return cell;
}




@end
