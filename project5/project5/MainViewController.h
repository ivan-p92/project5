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
@class History;


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate>

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
@property (strong, nonatomic) id <GameplayDelegate> game;

// It is through this History object that highscores are retrieved and saved
@property (strong, nonatomic) History *highscores;

// Properties for the settings
@property (assign, nonatomic) BOOL evilMode;
@property (assign, nonatomic) NSUInteger wordLength;
@property (assign, nonatomic) NSUInteger guesses;

#pragma mark - UI methods
// Loads flip view
- (IBAction)showInfo:(id)sender;

- (IBAction)dissmissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;
- (IBAction)startNewGameButtonPressed:(UIButton *)sender;

// Disables keyboard button and hides keyboard before new game is loaded
- (void)updateViewBeforeNewGame;

- (void)updateLabelsWithAlert:(NSString *)alert;

#pragma mark - Game methods
- (void)loadSettings;
- (void)newGame;

// Performs actions after game over (e.g. show highscores)
- (void)endGame;

@end
