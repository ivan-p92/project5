//
//  MainViewController.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initUI];
    [self.textField becomeFirstResponder];
    NSLog(@"View did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI methods

- (void) initUI
{
    self.currentProgress.text = @"------ABCDEFG---";
    self.guessedLetters.text = @"Letters Played:\n ";
    self.guessesLeft.text = @"Guesses Left:\n ";
    self.textField.delegate = self;
}

- (IBAction)dissmissKeyboard:(id)sender
{
    [self.textField resignFirstResponder];
}

- (IBAction)showKeyboard:(id)sender
{
    [self.textField becomeFirstResponder];
}

/**
 * If not implemented, return key is considered invalid character
 * due to textfield:shouldChangeCharactersInRange:replacementString:
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  YES;
}


#pragma mark - Game methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"In replace string");
    NSString *letter = [string uppercaseString];
     
    // now check whether it is a letter
    NSRange location = [letter rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    if (location.location == NSNotFound) {
        NSLog(@"Invalid character!");
    } else {
        NSLog(@"Play round will be called with: %@", letter);
        // TO-DO: call playRoundForLetter method on game
    }
    
    // never change contents of text field
    return NO;
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
