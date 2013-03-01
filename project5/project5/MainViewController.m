//
//  MainViewController.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "MainViewController.h"
#import "EvilGameplay.h"
#import "GoodGameplay.h"
#import "GameplayDelegate.h"
#import "History.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadSettings];
    [self initUI];
    NSLog(@"View did load");
}

- (void)viewDidAppear:(BOOL)animated
{
    [self newGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI methods

- (void) initUI
{
    self.currentProgress.text = @"------abcdefg---";
    self.guessedLetters.text = @"Letters Played:\n ";
    self.guessesLeft.text = [NSString stringWithFormat:@"Guesses Left:\n%d of %d", self.guesses, self.guesses];
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

- (IBAction)startNewGameButtonPressed:(UIButton *)sender
{
    [self updateViewBeforeNewGame];
    
    // wait a bit so that view updates
    [self performSelector:@selector(newGame) withObject:self afterDelay:0.5];
}

- (void)updateViewBeforeNewGame
{
    NSLog(@"Updating view before game loading..");
    [self.keyboardButton setEnabled:NO];
    [self.startNewGameButton setEnabled:NO];
    self.alerts.text = @"Loading Game...";
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

- (void)loadSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.wordLength = [defaults integerForKey:@"wordLength"];
    if (self.wordLength == 0) {
        NSLog(@"No existing user settings. Creating them.");
        self.wordLength = 7;
        self.guesses = 6;
        self.evilMode = YES;
        [defaults setInteger:self.wordLength forKey:@"wordLength"];
        [defaults setInteger:self.guesses forKey:@"guesses"];
        [defaults setBool:self.evilMode forKey:@"evilMode"];
        [defaults synchronize];
    }
    else {
        self.guesses = [defaults integerForKey:@"guesses"];
        self.evilMode = [defaults boolForKey:@"evilMode"];
        NSLog(@"Settings:\nWord length: %d\nGuesses: %d\nEvil mode: %@", self.wordLength, self.guesses, self.evilMode?@"YES":@"NO");
    }
}

/**
 * New game with loaded settings
 * Settings don't have to be loaded again
 */
- (void)newGame
{
    NSLog(@"New Game is being started..");
    NSLog(@"%@",[self.textField isFirstResponder]?@"YES":@"NO");
    // disable UI buttons and resign keyboard
    
    
    // load the words
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *words = [NSArray arrayWithContentsOfFile:path];
//    NSLog(@"Words:\n%@", words);
//    self.game = [EvilGameplay alloc];
//    
//    [self.game initGameWithWords: andGuesses:]
    
    self.alerts.text = @"Guess the Word!";
    [self.textField becomeFirstResponder];
    [self.keyboardButton setEnabled:YES];
    [self.startNewGameButton setEnabled:YES];
}

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

    // reload settings
    [self loadSettings];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setKeyboardButton:nil];
    [self setStartNewGameButton:nil];
    [super viewDidUnload];
}
@end
