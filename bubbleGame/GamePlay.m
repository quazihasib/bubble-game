//
//  UIViewController+GamePlay.m
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 16/4/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "GamePlay.h"
#import "ViewController.h"
#import "dbFile.h"
#import "Settings.h"

@implementation GamePlay : UIViewController

@synthesize labelTimer;
@synthesize labelScore;
@synthesize labelHighScore;

float timeInterval;
int countInterval;
int imageNum, redBalls, pinkBalls, greenBalls, blueBalls, blackBalls, score, highScore, numOfBalls, sizeOfBalls, preTag, countdown;

NSMutableArray *balls;
NSMutableArray *positionX ,*positionY;
Boolean createBallFlag;
UIImageView *imageView;

NSTimer *gameTimer;
NSTimer *countdownTimer;
NSTimer *createBallTimer;
NSTimer *removeBallTimer;

NSString *playerName;
CGRect screenRect;
CGFloat screenWidth,screenHeight;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //load data from setttings or set default data
    @try {
        numOfBalls = [[self getData:@"numberOfBalls"] intValue];
        if(numOfBalls==0){
            numOfBalls=15;}
        countInterval = [[self getData:@"timeInterVals"]intValue];
        if(countInterval==0){
            countInterval=60;}
        timeInterval = [[self getData:@"intervalDifferences"]intValue];
        if(timeInterval==0){
            timeInterval=1;}
    } @catch (NSException *exception) {
        NSLog(@"Data not loaded from setting");
    } @finally { }
    
    //initialize the variables
    playerName=[self getData:@"name"];
    imageNum=0;
    score=0;
    sizeOfBalls = 60;
    preTag = 100;
    createBallFlag = false;
    countdown = 3;
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    balls = [[NSMutableArray alloc]init];
    positionX = [[NSMutableArray alloc]init];
    positionY = [[NSMutableArray alloc]init];

    //initialize the score board
    [self initializeTheScores];
    //initialize the objects
    [self intializeObjects: numOfBalls: sizeOfBalls];
}
//update scoreboard at beggening
-(void) initializeTheScores{
    NSArray *playerScores = [[dbFile getSharedInstance]getPlayerScore];
    highScore = [[playerScores valueForKeyPath:@"@max.intValue"] intValue];
    labelScore.text = [NSString stringWithFormat:@"%d",score];
    labelHighScore.text = [NSString stringWithFormat:@"%d",highScore];
    labelTimer.text = [NSString stringWithFormat:@"%d",countInterval];
}

//initialize ball objects and assigning ball properties
-(void) intializeObjects:(int)ballNumber :(int)sizeOfBalls{
    //assign the screen range for the balls to appear
    CGFloat xRange = screenWidth - 160;
    CGFloat yRange = screenHeight - 160;
    int xVal=0;
    int yVal=60;
    for(int i=1;i<=ballNumber;i++){
        if (xVal<xRange) {
            xVal=sizeOfBalls*i;
            [positionX addObject:[NSNumber numberWithInteger:xVal]];}}
    for(int j=1;j<=ballNumber;j++){
        if (yVal<yRange) {
            yVal=sizeOfBalls*j;
            [positionY addObject:[NSNumber numberWithInteger:yVal]];}}
    //assigning probability for color of balls to appear
    [self assignBallProbability:ballNumber];
    
    //assign the ball images accordingly
    for(int i=0;i<ballNumber;i++){
        if(i>=0 && i<=redBalls){
            [balls  addObject:[UIImage imageNamed:@"RED-1.png"]];}
        else if(i>=redBalls && i<=pinkBalls){
            [balls  addObject:[UIImage imageNamed:@"PINK-1.png"]];}
        else if(i>=pinkBalls && i<=greenBalls){
            [balls  addObject:[UIImage imageNamed:@"GREEN-1.png"]];}
        else if(i>=greenBalls && i<=blueBalls){
            [balls  addObject:[UIImage imageNamed:@"BLUE-1.png"]];}
        else if(i>=blueBalls && i<=blackBalls){
            [balls  addObject:[UIImage imageNamed:@"BLACK-1.png"]];}}
    //start countdown 3,2,1 after initializing the objects
    [self countdown];
}
//assigning the probability to appear balls in the screen
-(void)assignBallProbability:(int)ballNumber{
    redBalls = (ballNumber*40)/100;
    pinkBalls = redBalls + (ballNumber*25)/100;
    greenBalls = pinkBalls + (ballNumber*15)/100;
    blueBalls = greenBalls + (ballNumber*10)/100;
    blackBalls = blueBalls + (ballNumber*10)/100;}

//shows countdown that appears for counting 3,2,1 before game starting
-(void)countdown{
    UITextField* textField = [[UITextField alloc]
                              initWithFrame:CGRectMake(screenWidth/2, screenHeight/2, 200, 200)];
    textField.text = [NSString stringWithFormat:@"%d",countdown];
    [textField setTextColor:[UIColor blackColor]];
    [textField setFont:[UIFont systemFontOfSize:40]];
    [self.view addSubview:textField];
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval: timeInterval
                                                      target: self
                                                    selector: @selector(countdownTimerHandler)
                                                    userInfo: textField
                                                    repeats: YES];
}
//selector for countdown and start the game after finishing the countdown
-(void)countdownTimerHandler{
    UITextField* txts = countdownTimer.userInfo;
    countdown--;
    if(countdown==0){
        txts.text = [NSString stringWithFormat:@"GO!"];
    }
    else if(countdown==-1){
        if(countdownTimer){
            [countdownTimer invalidate];
            countdownTimer = nil;
            countdown=3;
            for (UIView *v in self.view.subviews) {
                if ([v isKindOfClass:[UITextField class]]) {
                    [v removeFromSuperview];}}}
        gameTimer = [NSTimer scheduledTimerWithTimeInterval: timeInterval
                                                     target: self
                                                   selector: @selector(finishGame)
                                                   userInfo: nil
                                                    repeats: YES];
        //start the game by creating balls in the screen
        [self createBalls];
        createBallTimer= [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createBalls) userInfo:nil repeats:YES];
    }
    else{
        txts.text = [NSString stringWithFormat:@"%d", countdown];}
}

//crete balls in random places
-(void)createBalls{
    for (UIImage *image in balls) {
        //genarate random posiiotns
        int randomIndexX = arc4random() % [positionX count];
        int a=[[positionX objectAtIndex:randomIndexX]intValue];
        int randomIndexY = arc4random() % [positionY count];
        int b=[[positionY objectAtIndex:randomIndexY]intValue];
        //allocate the random co ordinates to imageview
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(a,b, sizeOfBalls, sizeOfBalls)];
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        imageView.tag = imageNum;
        [self.view addSubview:imageView];
        
        //add tap gesture to ball images
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapGesture];
        
        //no balls should overlap, changing the poition of the balls
        for (UIView *view in self.view.subviews){
            if (CGRectIntersectsRect(imageView.frame, view.frame) && ![view isEqual: imageView]){
                while(CGRectIntersectsRect(imageView.frame, view.frame) && ![view isEqual: imageView]){
                    int randX = arc4random() % [positionX count];
                    int x=[[positionX objectAtIndex:randX]intValue];
                    int randY = arc4random() % [positionY count];
                    int y=[[positionY objectAtIndex:randY]intValue];
                    [imageView setFrame:CGRectMake(x, y, imageView.frame.size.width, imageView.frame.size.height)];}}}
        //remove balls after time interval
        imageNum++;
        removeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(removeBalls) userInfo:nil repeats:NO];}
}

//remove all balls from the view
-(void)removeBalls{
    imageNum=0;
    for(int k=0;k<100;k++){
        imageView.tag=0;}
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];}}
}

//on tap, remove balls and update score
- (void)onImageTapped:(UITapGestureRecognizer*)recognizer{
    UIImageView *imgView = (UIImageView*) recognizer.view;
    imgView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         imgView.alpha = 0.1;
                         imgView.transform = CGAffineTransformMakeScale(1.3, 1.3);}
                     completion:^(BOOL finished){
                         [imgView removeFromSuperview];}];
    //update score after each touch
    int value =(int) imgView.tag;
    [self allocateScore:value];
}

//allocate the scores according to ball colors
-(void)allocateScore:(int) a{
    if(a>=0 && a<=redBalls){
        if(preTag>=0 && preTag<=redBalls){
            score = score+(1.5*1);}
        else{score = score+1;}}
    //pink balls
    else if(a>redBalls && a<=pinkBalls){
        if(preTag>=redBalls && preTag<=pinkBalls){
            score = score+(1.5*2);}
        else{score = score+2;}}
    //green balls
    else if(a>pinkBalls && a<=greenBalls){
        if(preTag>=pinkBalls && preTag<=greenBalls){
            score = score+(1.5*5);}
        else{score = score+5;}}
    //blue ball
    else if(a>greenBalls && a<=blueBalls){
        if(preTag>=greenBalls && preTag<=blueBalls){
            score = score+(1.5*8);}
        else{score = score+8;}}
    //black balls
    else if(a>blueBalls && a<=blackBalls){
        if(preTag>=blueBalls && preTag<=blackBalls){
            score = score+(1.5*10);}
        else{score = score+10;}}
    labelScore.text = [NSString stringWithFormat:@"%d", score];
    preTag = (int)a;
}

//shutdown the game and timers when timer is zero(0)
-(void) finishGame {
    countInterval--;
    labelTimer.text = [NSString stringWithFormat:@"%d", countInterval];
    if(countInterval==0){
        if(gameTimer){
            [gameTimer invalidate];
            gameTimer = nil;}
        if(countdownTimer){
            [countdownTimer invalidate];
            countdownTimer=nil;
            countdown=3;
            for (UIView *v in self.view.subviews) {
                if ([v isKindOfClass:[UITextField class]]) {
                    [v removeFromSuperview];}}}
        if(createBallTimer){
            [createBallTimer invalidate];
            createBallTimer = nil;}
        if(removeBallTimer){
            [removeBallTimer invalidate];
            removeBallTimer = nil;}
        [NSTimer scheduledTimerWithTimeInterval: 2
                                         target: self
                                       selector: @selector(alertView)
                                       userInfo: nil
                                        repeats: NO];}
}

//shows the final score of the user with restart and finish game option
-(void)alertView{
    //save player data
    @try {
        [[dbFile getSharedInstance]saveData: playerName: [NSString stringWithFormat:@"%d",score]];
    } @catch (NSException *exception) {
        NSLog(@"Score not saved");
    } @finally { }
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:playerName
                                 message:[NSString stringWithFormat:@"%d", score]
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* restartButton = [UIAlertAction
                                actionWithTitle:@"Restart"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [self viewDidLoad];
                                    [self viewWillAppear:YES];}];
    UIAlertAction* finishButton = [UIAlertAction
                               actionWithTitle:@"Finish"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   exit(0);}];
    [alert addAction:restartButton];
    [alert addAction:finishButton];
    [self presentViewController:alert animated:YES completion:nil];
}

//get the saved user data using keys
-(NSString*)getData:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *title = [defaults objectForKey:key];
    return title;
}

@end
