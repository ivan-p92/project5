//
//  MainViewController.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentProgress;
@property (weak, nonatomic) IBOutlet UILabel *guessedLetters;
@property (weak, nonatomic) IBOutlet UILabel *guessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *alerts;
@property (weak, nonatomic) IBOutlet UITextField *textField;


- (IBAction)showInfo:(id)sender;
- (IBAction)dissmissKeyboard:(id)sender;
- (IBAction)showKeyboard:(id)sender;

@end
