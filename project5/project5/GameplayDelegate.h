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

// all (remaining) words for evil and just one word for fair hangman
@property (strong, nonatomic) NSArray *words;

// current word to be guessed
@property (strong, nonatomic) NSString *currentWord;
@property (nonatomic) int unknownLettersLeft;
@property (strong, nonatomic) NSMutableString *guessedLetters;

// current string to show to user (e.g. HA---A-)
@property (strong, nonatomic) NSMutableString *currentProgress;

// number of allowed guesses and current number of guesses
@property (nonatomic) int guesses;
@property (nonatomic) int currentGuess;

// whether player won the game once it is finished
@property (nonatomic) BOOL playerWonGame;

// message to show after each letter
@property (strong, nonatomic) NSString *alert;


// start new game with given list of words (or word) and number of guesses
- (id)initGameWithWords:(NSArray*) words andGuesses:(int) guesses;

// returns NO if game is over
- (BOOL)playRoundForLetter:(NSString *) letter;

@end
