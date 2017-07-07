//
//  UIViewController+ViewController.m
//  bubbleGame
//
//  Created by Quazi Ridwan Hasib on 16/4/17.
//  Copyright © 2017 Quazi Ridwan Hasib. All rights reserved.
//

#import "ViewController.h"
#import "GamePlay.h"

@implementation ViewController : UIViewController

@synthesize userName;
@synthesize startButton;


- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//start button action
- (IBAction)startButton:(id)sender {
    [self shouldPerformSegueWithIdentifier:@"startSegue" sender:self];
}

//save the username
-(void)setName:(NSString*)name :(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:key];
    [defaults synchronize];
}

//if there is no username typed, then it will not start game but it will ask for username
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSString *names = self.userName.text;
    if ([identifier isEqualToString:@"startSegue"]){
        if (names.length==0){
            [self showAlert];
            return NO;}
        else{
            [self setName:names:@"name"];
            return YES;}}
    return YES;
}

//alert to write tell the user to write names
-(void)showAlert{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:[NSString stringWithFormat:@"Please Write Your Name"]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
