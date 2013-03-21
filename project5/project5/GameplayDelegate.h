//
//  GameplayDelegate.h
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EquivalenceClass;

@protocol GameplayDelegate <NSObject>

// All (remaining) words for evil and just one word for fair hangman.
@property (strong, nonatomic) NSArray *words;

@property (strong, nonatomic) NSString *currentWord;
@property (nonatomic) int unknownLettersLeft;
@property (strong, nonatomic) NSMutableString *guessedLetters;

// Current string to show to user progress (e.g. HA---A-).
@property (strong, nonatomic) NSMutableString *currentProgress;

// Number of allowed guesses and current number of guesses.
@property (nonatomic) int guesses;
@property (nonatomic) int currentGuess;

// Whether player won the game once it is finished.
@property (nonatomic) BOOL playerWonGame;

// Message to show after each letter.
@property (strong, nonatomic) NSString *alert;


// Start new game with given list of words (or word) and number
// of allowed guesses.
- (id)initGameWithWords:(NSArray*) words andGuesses:(int) guesses;

// Plays a round with given letter. If the game is over returns NO,
// else returns YES.
- (BOOL)playRoundForLetter:(NSString *) letter;

@end
