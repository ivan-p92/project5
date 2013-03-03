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
	
    // Set values according to settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [self.evilMode setOn:[defaults boolForKey:@"evilMode"]];
    
    NSUInteger wordLength = [defaults integerForKey:@"wordLength"];
    [self.wordLengthSlider setValue:wordLength];
    self.wordLength.text = [NSString stringWithFormat:@"%d", wordLength];
    
    NSUInteger guesses = [defaults integerForKey:@"guesses"];
    [self.guessesSlider setValue:guesses];
    self.guesses.text = [NSString stringWithFormat:@"%d", guesses];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    // Return to main view
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)evilModeChanged:(UISwitch *)sender
{
    // Change evilmode setting
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL evilMode = sender.isOn;
    [defaults setBool:evilMode forKey:@"evilMode"];
    [defaults synchronize];
    NSLog(@"Evil mode saved: %@", evilMode?@"YES":@"NO");
}

- (IBAction)wordLengthChanged:(UISlider *)sender
{
    // Update label with current value
    NSUInteger wordLength = lroundf(sender.value);
    self.wordLength.text = [NSString stringWithFormat:@"%d", wordLength];
}

- (IBAction)guessesChanged:(UISlider *)sender
{
    // Update label with current value
    NSUInteger guesses = lround(sender.value);
    self.guesses.text = [NSString stringWithFormat:@"%d", guesses];
}

- (IBAction)saveWordLength:(UISlider *)sender
{
    // Get and save new word length
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger wordLength = lroundf(sender.value);
    [defaults setInteger:wordLength forKey:@"wordLength"];
    [defaults synchronize];
    NSLog(@"New word length saved: %d", wordLength);
}

- (IBAction)saveGuesses:(UISlider *)sender
{
    // Get and save new number of allowed wrong guesses
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger guesses = lroundf(sender.value);
    [defaults setInteger:guesses forKey:@"guesses"];
    [defaults synchronize];
    NSLog(@"New guesses saved: %d", guesses);
}

- (void)viewDidUnload {
    [self setEvilMode:nil];
    [self setWordLengthSlider:nil];
    [self setGuessesSlider:nil];
    [super viewDidUnload];
}
@end
