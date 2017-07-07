//
//  UIViewController+Settings.h
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 17/5/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *increaseTime;
@property (weak, nonatomic) IBOutlet UISlider *increaseBalls;
@property (weak, nonatomic) IBOutlet UISlider *increaseTimeIntervaals;

@property (weak, nonatomic) IBOutlet UITextField *increaseLbl;
@property (weak, nonatomic) IBOutlet UITextField *ballLbl;
@property (weak, nonatomic) IBOutlet UITextField *timeLbl;

-(void)saveData:(NSString*)name :(NSString*)key;
- (void)valueChanged;

@end
