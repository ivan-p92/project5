//
//  FlipsideViewController.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  This controller manages the flipside (settings) of hangman.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

// UI properties: two labels and corresponding sliders, one switch
@property (weak, nonatomic) IBOutlet UILabel *wordLength;
@property (weak, nonatomic) IBOutlet UILabel *guesses;
@property (weak, nonatomic) IBOutlet UISwitch *evilMode;
@property (weak, nonatomic) IBOutlet UISlider *wordLengthSlider;
@property (weak, nonatomic) IBOutlet UISlider *guessesSlider;

// Sent when the user wants to switch back to main view
- (IBAction)done:(id)sender;

// Methods mapped to valueChanged actions
- (IBAction)evilModeChanged:(UISwitch *)sender;
- (IBAction)wordLengthChanged:(UISlider *)sender;
- (IBAction)guessesChanged:(UISlider *)sender;

// Called when user lifts finger from sliders
- (IBAction)saveWordLength:(UISlider *)sender;
- (IBAction)saveGuesses:(UISlider *)sender;

@end
