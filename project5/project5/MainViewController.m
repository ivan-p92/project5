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
    self.currentProgress.text = @"hangman";
    self.guessedLetters.text = @"Letters played:\n ";
    self.guessesLeft.text = [NSString stringWithFormat:@"Guesses left:\n%d of %d", self.guesses, self.guesses];
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
    self.alerts.text = @"Loading new game...";
}

- (void)updateLabels
{
    self.currentProgress.text = [self.game.currentProgress lowercaseString];
    self.alerts.text = @"Guess the word!";
    self.guessesLeft.text = [NSString stringWithFormat:@"Guesses left:\n%d of %d", self.guesses - self.game.currentGuess, self.guesses];
    
    if ([self.game.guessedLetters isEqualToString:@""]) {
        self.guessedLetters.text = @"Letters played:\n ";
    }
    else {
        self.guessedLetters.text = [NSString stringWithFormat:@"Letters played:\n%@", [self.game.guessedLetters lowercaseString]];
    }
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
    
    // load the words
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *allWords = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *words = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < [allWords count]; index++) {
        if ([[allWords objectAtIndex:index] length] == self.wordLength) {
            [words addObject:[allWords objectAtIndex:index]];
        }
    }
    
    // make new evil or good game
    self.game = [EvilGameplay alloc];
    
    self.game = [self.game initGameWithWords:words andGuesses:self.guesses];
    
    // set labels
    [self updateLabels];
    
    [self.textField becomeFirstResponder];
    [self.keyboardButton setEnabled:YES];
    [self.startNewGameButton setEnabled:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *letter = [string uppercaseString];
     
    // now check whether it is a letter
    NSRange location = [letter rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    if (location.location == NSNotFound) {
        NSLog(@"Invalid character!");
        self.alerts.text = @"Invalid character!";
    }
    else if ([self.game.guessedLetters rangeOfString:letter].location == NSNotFound){
        NSLog(@"Play round will be called with: %@", letter);
        
        BOOL notYetFinished = [self.game playRoundForLetter:letter];
        NSLog(@"Word in mind: %@", self.game.currentWord);
        if (notYetFinished) {
            [self updateLabels];
        }
        else {
            [self endGame];
        }
    }
    else {
        NSLog(@"Letter already played...");
        self.alerts.text = @"You already played this letter!";
    }

    // never change contents of text field
    return NO;
}

- (void)endGame
{
    [self.keyboardButton setEnabled:NO];
    [self.textField resignFirstResponder];
    
    if (self.game.playerWonGame) {
        self.currentProgress.text = [self.game.currentProgress lowercaseString];
        self.alerts.text = @"Congratulations, you won!";
    }
    else {
        self.currentProgress.text = [self.game.currentWord lowercaseString];
        self.alerts.text = @"Unfortunately, you lost..";
    }
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
