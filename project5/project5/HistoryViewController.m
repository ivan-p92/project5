//
//  HistoryViewController.m
//  project5
//
//  Created by Ivan Plantevin on 08-03-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "HistoryViewController.h"
#import "MainViewController.h"
#import "History.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI
{
    // Make strings with scores, words and wrong guesses (errors)
    NSArray *reverseScores = [[self.delegate.highscores.scores reverseObjectEnumerator] allObjects];
    NSArray *reverseWords = [[self.delegate.highscores.words reverseObjectEnumerator] allObjects];
    NSArray *reverseErrors = [[self.delegate.highscores.guesses reverseObjectEnumerator] allObjects];
    
    NSString *scores = [reverseScores  componentsJoinedByString:@"\n"];
    NSString *words = [reverseWords componentsJoinedByString:@"\n"];
    NSString *errors = [reverseErrors componentsJoinedByString:@"\n"];
    
    // Set the three labels text
    self.scoresLabel.text = scores;
    self.wordsLabel.text = words;
    self.errorsLabel.text = errors;
    
    // Fit their size to their content
    [self.scoresLabel sizeToFit];
    [self.wordsLabel sizeToFit];
    [self.errorsLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
    // return to main view
    [self.delegate historyViewControllerdidFinish:self];
}
- (IBAction)resetHighScores:(UIButton *)sender
{
    [self.delegate.highscores resetHighScores];
    [self initUI];
}
@end
