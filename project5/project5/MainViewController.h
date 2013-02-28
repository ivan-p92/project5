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

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *currentProgress;
@property (weak, nonatomic) IBOutlet UILabel *guessedLetters;
@property (weak, nonatomic) IBOutlet UILabel *guessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *alerts;
@property (weak, nonatomic) IBOutlet UITextField *textField;

// game properties
@property (strong, nonatomic) id <GameplayDelegate> game;
@property (strong, nonatomic) History *highscores;

- (IBAction)showInfo:(id)sender;
- (IBAction)dissmissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;

@end
