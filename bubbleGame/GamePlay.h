//
//  UIViewController+GamePlay.h
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 16/4/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import <UIKit/UIKit.h>

//ui gesture is used for user tapping purpose
@interface GamePlay:UIViewController<UIGestureRecognizerDelegate>

//game methods
-(void) initializeTheScores;
-(void) intializeObjects:(int)ballNumber :(int)sizeOfBalls;
-(void)assignBallProbability:(int)ballNumbe;
-(void)countdown;
-(void)countdownTimerHandler;
-(void)createBalls;
-(void)removeBalls;
-(void)onImageTapped:(UITapGestureRecognizer*)recognizer;
-(void)allocateScore:(int) a;
-(void) finishGame;
-(void)alertView;
-(NSString*)getData:(NSString*)key;

//score board property
@property (weak, nonatomic) IBOutlet UILabel *labelTimer;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UILabel *labelHighScore;




@end
