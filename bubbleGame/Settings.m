//
//  UIViewController+Settings.m
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 17/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "Settings.h"

@implementation Settings
int numberOfBalls,timeInterVals, intervalDifferences;

-(void)viewDidLoad
{
    [super viewDidLoad];
   
    //initialize label data
    _increaseLbl.text = [NSString stringWithFormat:@"Time:%d",(int)_increaseTime.value];
    _ballLbl.text = [NSString stringWithFormat:@"Number ofa balls:%d",(int)_increaseBalls.value];
    _timeLbl.text = [NSString stringWithFormat:@"Time Interval:%d",(int)_increaseTimeIntervaals.value];
}

//set value on slider change
- (void)valueChanged{
    [_increaseBalls setValue:((int)((_increaseBalls.value + 2.5) / 5) * 5) animated:NO];}

//game time label action
- (IBAction)increaseTimeChange:(id)sender {
    _increaseTime.continuous = YES;
    [_increaseTime addTarget:self
                       action:@selector(valueChanged)
             forControlEvents:UIControlEventValueChanged];
    
    timeInterVals = [[[NSString alloc] initWithFormat:@"%d", ((int)((_increaseTime.value + 15) / 30) * 30)] intValue];
    NSLog(@"timeInterVals:%d",timeInterVals);
    [self saveData:[NSString stringWithFormat:@"%d",timeInterVals] :@"timeInterVals"];
    _increaseLbl.text = [NSString stringWithFormat:@"Time:%d",timeInterVals];
}

//number of balls label action
- (IBAction)increaseBallsChange:(id)sender {
    _increaseBalls.continuous = YES;
    [_increaseBalls addTarget:self
                       action:@selector(valueChanged)
             forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"_increaseBalls:%@",[[NSString alloc] initWithFormat:@" Value: %d ", ((int)((_increaseBalls.value + 2.5) / 5) * 5)]);
    numberOfBalls = [[[NSString alloc] initWithFormat:@"%d", ((int)((_increaseBalls.value + 2.5) / 5) * 5)] intValue];
    NSLog(@"numberOfBalls:%d",numberOfBalls);
    [self saveData:[NSString stringWithFormat:@"%d",numberOfBalls] :@"numberOfBalls"];
    _ballLbl.text = [NSString stringWithFormat:@"Number of balls:%d",numberOfBalls];
}

//game time interval label action
- (IBAction)increaseTimeIntervalsChange:(id)sender {
    _increaseTimeIntervaals.continuous = YES;
    [_increaseTimeIntervaals addTarget:self
                      action:@selector(valueChanged)
            forControlEvents:UIControlEventValueChanged];
    
    intervalDifferences = [[[NSString alloc] initWithFormat:@"%d", ((int)((_increaseTimeIntervaals.value + .1) / 1) * 1)] intValue];
    NSLog(@"intervalDifferences:%d",intervalDifferences);
    
    [self saveData:[NSString stringWithFormat:@"%d",intervalDifferences] :@"intervalDifferences"];
    _timeLbl.text = [NSString stringWithFormat:@"Time Interval:%d",intervalDifferences];

}

//save settings data
-(void)saveData:(NSString*)name :(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:key];
    [defaults synchronize];
}


@end


