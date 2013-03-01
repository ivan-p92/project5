//
//  MainViewController.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "FlipsideViewController.h"
#import "GameplayDelegate.h"
@class History;


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate>

#pragma mark - UI properties
@property (weak, nonatomic) IBOutlet UILabel *currentProgress;
@property (weak, nonatomic) IBOutlet UILabel *guessedLetters;
@property (weak, nonatomic) IBOutlet UILabel *guessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *alerts;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *keyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;


#pragma mark - Game properties
@property (strong, nonatomic) id <GameplayDelegate> game;
@property (strong, nonatomic) History *highscores;
@property (nonatomic) BOOL evilMode;
@property (nonatomic) NSUInteger wordLength;
@property (nonatomic) NSUInteger guesses;

#pragma mark - UI methods
- (IBAction)showInfo:(id)sender;
- (IBAction)dissmissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;
- (IBAction)startNewGameButtonPressed:(UIButton *)sender;
- (void)updateViewBeforeNewGame;
- (void)updateLabels;

#pragma mark - Game methods
- (void)loadSettings;
- (void)newGame;
- (void)endGame;

@end
