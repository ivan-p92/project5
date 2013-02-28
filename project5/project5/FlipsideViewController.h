//
//  FlipsideViewController.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

// UI properties
@property (weak, nonatomic) IBOutlet UILabel *wordLength;
@property (weak, nonatomic) IBOutlet UILabel *guesses;


- (IBAction)done:(id)sender;
- (IBAction)evilModeChanged:(UISwitch *)sender;
- (IBAction)wordLengthChanged:(UISlider *)sender;
- (IBAction)guessesChanged:(UISlider *)sender;

@end
