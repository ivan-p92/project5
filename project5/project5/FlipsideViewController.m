//
//  FlipsideViewController.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)evilModeChanged:(UISwitch *)sender
{
    // change evilmode setting
}

- (IBAction)wordLengthChanged:(UISlider *)sender
{
    NSUInteger wordLength = lroundf(sender.value);
    self.wordLength.text = [NSString stringWithFormat:@"%d", wordLength];
}

- (IBAction)guessesChanged:(UISlider *)sender
{
    NSUInteger guesses = lround(sender.value);
    self.guesses.text = [NSString stringWithFormat:@"%d", guesses];
}

@end
