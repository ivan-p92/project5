//
//  MainViewController.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  This controller handles the gameplay of hangman
//

#import "FlipsideViewController.h"
#import "GameplayDelegate.h"
#import "HistoryViewController.h"
@class History;


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, HistoryViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

#pragma mark - UI properties
// Necessary labels, buttons and textfield
@property (weak, nonatomic) IBOutlet UILabel *currentProgress;
@property (weak, nonatomic) IBOutlet UILabel *guessedLetters;
@property (weak, nonatomic) IBOutlet UILabel *guessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *alerts;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *keyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;


#pragma mark - Game properties
// Holds an instance of GoodGameplay or EvilGameplay
@property (strong, nonatomic) id <GameplayDelegate, NSCoding> game;

// It is through this History object that highscores are retrieved and saved
@property (strong, nonatomic) History *highscores;

// Properties for the settings
@property (assign, nonatomic) BOOL evilMode;
@property (assign, nonatomic) NSUInteger wordLength;
@property (assign, nonatomic) NSUInteger guesses;

@property (assign, nonatomic) BOOL gameNotYetOver;
@property (assign, nonatomic) BOOL shouldStartNewGame;

#pragma mark - UI methods
// Initializes interface and changes appearance of default elements
- (void)initUI;

// Loads flip view
- (IBAction)showInfo:(id)sender;

// Loads high scores view
- (void)showHighScores;

// Enables the keyboard and new game buttons and shows the keyboard
- (void)enableButtons;

// To hide and show the keyboard
- (IBAction)dissmissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;

// Calls -newGame: to start new game with current settings
// after the button is pressed.
- (IBAction)startNewGameButtonPressed:(UIButton *)sender;
- (IBAction)highScoresButtonPressed:(UIButton *)sender;

// Disables keyboard button and hides keyboard before new game is loaded
- (void)updateViewBeforeNewGame;

// Updates the contents of the four labels. The given string will
// be put as content for |alerts| label
- (void)updateLabelsWithAlert:(NSString *)alert;

#pragma mark - Game methods
// Loads the settings and saves them into the three properties
// |evilMode|, |wordLength| and |guesses|
- (void)loadSettings;

// Called by -startNewGameButtonPressed to actually initialize a new
// game object with the latest settings
- (void)newGame;

// Performs actions after game over. Manages the updating of the
// high scores and shows appropriate alerts to the player.
- (void)endGame;

@end
