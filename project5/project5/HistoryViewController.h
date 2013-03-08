//
//  HistoryViewController.h
//  project5
//
//  Created by Ivan Plantevin on 08-03-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryViewController;
@class MainViewController;

@protocol HistoryViewControllerDelegate

- (void)historyViewControllerdidFinish:(HistoryViewController *) controller;

@end

@interface HistoryViewController : UIViewController

@property (weak, nonatomic) MainViewController <HistoryViewControllerDelegate> *delegate;

// The label properties for scores, words and wrong guesses (errors)
@property (weak, nonatomic) IBOutlet UILabel *scoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorsLabel;

// Method for switching back to main view
- (IBAction)done:(UIBarButtonItem *)sender;

@end
