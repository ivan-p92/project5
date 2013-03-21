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

// Tags for the three different UIAlertView objects
#define highScoreAlertView 1
#define wonAlertView 2
#define lostAlertView 3

@implementation MainViewController

#pragma mark - Init related methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    // |shouldStartNewGame| may be set to NO by -application:didFinishLoadingWithOptions:
    // in the AppDelegate if a savegame is found and loaded
    self.shouldStartNewGame = YES;
    
    // Instantiate high scores, they are loaded/created automatically
    self.highscores = [[History alloc] init];

    return self;
}

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
    // Start new game if necessary
    if (self.shouldStartNewGame) {
        self.shouldStartNewGame = NO;
        [self newGame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI methods

- (void)initUI
{
    // If a new game should be started, put placeholders in labels
    if (self.shouldStartNewGame) {
        self.currentProgress.text = @"hangman";
        self.guessedLetters.text = @"Letters played:\n ";
        self.guessesLeft.text = [NSString stringWithFormat:@"Wrong guesses left:\n%d of %d", self.guesses, self.guesses];
    }
    // If not, a saved game is reloaded
    else {
        // Update all labels. The save game has been unarchived into the |game|
        // property, so the player continues where he left off.
        [self updateLabelsWithAlert:@"Resume your game!"];
        
        [self enableButtons];
    }
    
    // Set the font of all navigation bars and ~buttons to Noteworthy
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{UITextAttributeFont:[UIFont fontWithName:@"Noteworthy" size:16]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeFont:[UIFont fontWithName:@"Noteworthy" size:12]} forState:UIControlStateNormal];
    
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

- (void)enableButtons
{
    [self.textField becomeFirstResponder];
    [self.keyboardButton setEnabled:YES];
    [self.startNewGameButton setEnabled:YES];
}

- (IBAction)startNewGameButtonPressed:(UIButton *)sender
{
    // Show loading message in the |alerts| label
    [self updateViewBeforeNewGame];
    
    // Wait a bit so that view updates
    [self performSelector:@selector(newGame) withObject:self afterDelay:0.1];
}

- (IBAction)highScoresButtonPressed:(UIButton *)sender
{
    [self showHighScores];
}

- (void)updateViewBeforeNewGame
{
    // Disables buttons and shows loading message
    [self.keyboardButton setEnabled:NO];
    [self.startNewGameButton setEnabled:NO];
    self.alerts.text = @"Loading new game...";
}

- (void)updateLabelsWithAlert:(NSString *)alert
{
    self.currentProgress.text = [self.game.currentProgress lowercaseString];
    self.alerts.text = alert;
    self.guessesLeft.text = [NSString stringWithFormat:@"Wrong guesses left:\n%d of %d", self.guesses - self.game.currentGuess, self.guesses];
    
    if ([self.game.guessedLetters isEqualToString:@""]) {
        // If the user didn't guess any letters, add a whitespace after newline
        // to force second line
        self.guessedLetters.text = @"Letters played:\n ";
    }
    else {
        self.guessedLetters.text = [NSString stringWithFormat:@"Letters played:\n%@", [self.game.guessedLetters lowercaseString]];
    }
}

// If not implemented, return key is considered invalid character
// due to textfield:shouldChangeCharactersInRange:replacementString:
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  YES;
}


#pragma mark - Game methods

- (void)loadSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.wordLength = [defaults integerForKey:@"wordLength"];
    
    // integerForKey returns 0 if no setting exists, so in that case
    // there were no settings yet.
    if (self.wordLength == 0) {
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

- (void)newGame
{
    self.gameNotYetOver = YES;
    NSLog(@"New Game is being started..");
    
    // Load the words
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *allWords = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *words = [[NSMutableArray alloc] init];
    
    // Only take words of desired length
    for (int index = 0; index < [allWords count]; index++) {
        if ([[allWords objectAtIndex:index] length] == self.wordLength) {
            [words addObject:[allWords objectAtIndex:index]];
        }
    }
    
    // Discard |allWords| to save memory
    allWords = nil;
    
    // Make new evil or good game according to setting
    self.game = nil;
    if (self.evilMode) {
        self.game = [EvilGameplay alloc];
    }
    else {
        self.game = [GoodGameplay alloc];
    }
    
    self.game = [self.game initGameWithWords:words andGuesses:self.guesses];
    
    [self updateLabelsWithAlert:@"Guess the word!"];
    
    [self enableButtons];
}

// Called whenever user pressed key on keyboard
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *letter = [string uppercaseString];
     
    // Now check whether it is a letter
    NSRange location = [letter rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    // If not a letter, show message
    // Else if not already played, play round
    // Else alert player that letter has already been played
    if (location.location == NSNotFound) {
        self.alerts.text = @"Invalid character!";
    }
    else if ([self.game.guessedLetters rangeOfString:letter].location == NSNotFound){
        // The game is over if -playRoundForLetter: returns NO
        self.gameNotYetOver = [self.game playRoundForLetter:letter];
        
        NSLog(@"Word in mind: %@", self.game.currentWord);
        
        if (self.gameNotYetOver) {
            [self updateLabelsWithAlert:self.game.alert];
        }
        else {
            [self endGame];
        }
    }
    else {
        self.alerts.text = @"You already played this letter!";
    }

    // never change content of text field
    return NO;
}

- (void)endGame
{
    // Once, the game is over, no interaction is possible so the keyboard is hidden
    // and its corresponding button disabled
    [self.keyboardButton setEnabled:NO];
    [self.textField resignFirstResponder];
    
    // If the player won, update labels, calculate score and show alert views
    if (self.game.playerWonGame) {
        self.currentProgress.text = [self.game.currentProgress lowercaseString];
        self.alerts.text = @"Congratulations, you won!";
        
        // If the player has a new high score, show the corresponding alert
        if ([self.highscores calculateAndSaveScoreWithWord:self.game.currentWord andGuesses:self.game.currentGuess]) {
            
            NSString *message = [NSString stringWithFormat:@"Your score is: %@\nThis is a new high score!", self.highscores.mostRecentScore];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New high score!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"View high scores", nil];
            alertView.tag = highScoreAlertView;
            
            [alertView show];
        }
        // If the player doesn't have a high score, show the corresponding alert
        else {
            NSString *message = [NSString stringWithFormat:@"Your score is: %@\nThis is no high score..", self.highscores.mostRecentScore];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You won!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertView.tag = wonAlertView;
            
            [alertView show];
        }
    }
    // If the player lost, update labels and show corresponding alert view
    else {
        self.currentProgress.text = [self.game.currentWord lowercaseString];
        self.guessesLeft.text = @"Wrong guesses left:\nnone";
        self.alerts.text = @"Unfortunately, you lost..";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"You lost.." message:@"Unfortunately, you lost..\nTry again!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = lostAlertView;
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Currently, only a tap on the high scores alert view should result in
    // an action (showing the high scores)
    if (alertView.tag == highScoreAlertView) {
        [self showHighScores];
    }
}


#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];

    // Reload settings
    [self loadSettings];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)showHighScores
{
    HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)historyViewControllerdidFinish:(HistoryViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [self setKeyboardButton:nil];
    [self setStartNewGameButton:nil];
    [super viewDidUnload];
}
@end
