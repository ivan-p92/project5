//
//  GoodGameplay.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "GoodGameplay.h"

@implementation GoodGameplay

@synthesize words = _words;
@synthesize currentWord = _currentWord;
@synthesize unknownLettersLeft = _unknownLettersLeft;
@synthesize guessedLetters = _guessedLetters;
@synthesize currentProgress = _currentProgress;
@synthesize guesses = _guesses;
@synthesize currentGuess = _currentGuess;
@synthesize playerWonGame = _playerWonGame;
@synthesize alert = _alert;

- (id)init
{
    self = [super init];
    NSArray *words = [NSArray arrayWithObject:@"FOO"];
    return [self initGameWithWords:words andGuesses:2];
}

- (id)initGameWithWords:(NSArray *)words andGuesses:(int)guesses
{
    NSLog(@"Good game init.");
    self = [super init];
    
    NSUInteger randomIndex = arc4random() % [words count];
    self.currentWord = [words objectAtIndex:randomIndex];
    self.guesses = guesses;
    self.currentGuess = 0;
    self.unknownLettersLeft = [self.currentWord length];
    self.guessedLetters = [NSMutableString stringWithString:@""];
    
    self.currentProgress = [[NSMutableString alloc] init];
    
    // change currentProgress into hyphens
    for (int i = 1; i <= self.unknownLettersLeft; i++) {
        [self.currentProgress appendString:@"-"];
    }
    NSLog(@"Word: %@", self.currentWord);
    
    return self;
}

- (BOOL)playRoundForLetter:(NSString *)letter
{
    [self.guessedLetters appendString:letter];
    
    BOOL letterWasFound = NO;
    
    NSRange letterLocation;
    NSMutableString *word = [self.currentWord mutableCopy];
    
    do {
        letterLocation = [word rangeOfString:letter];
        // letter was found, so update currentProgress and other properties
        if (letterLocation.location != NSNotFound) {
            self.unknownLettersLeft--;
            letterWasFound = YES;
            [word replaceCharactersInRange:letterLocation withString:@"0"];
            [self.currentProgress replaceCharactersInRange:letterLocation withString:letter];
        }
    } while (letterLocation.location != NSNotFound);
    
    if (letterWasFound) {
        self.alert = @"Good choice!";
    }
    else {
        self.currentGuess++;
        self.alert = @"Wrong choice...";
    }
    
    if (self.unknownLettersLeft == 0) {
        self.playerWonGame = YES;
        return NO;
    } else if (self.currentGuess == self.guesses) {
        self.playerWonGame = NO;
        return NO;
    } else {
        return YES;
    }
}

# pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.words forKey:@"words"];
    [aCoder encodeObject:self.currentWord forKey:@"currentWord"];
    [aCoder encodeInteger:self.unknownLettersLeft forKey:@"unknownLettersLeft"];
    [aCoder encodeObject:self.guessedLetters forKey:@"guessedLetters"];
    [aCoder encodeObject:self.currentProgress forKey:@"currentProgress"];
    [aCoder encodeInteger:self.guesses forKey:@"guesses"];
    [aCoder encodeInteger:self.currentGuess forKey:@"currentGuess"];
    [aCoder encodeBool:self.playerWonGame forKey:@"playerWonGame"];
    [aCoder encodeObject:self.alert forKey:@"alert"];
    NSLog(@"Encoded GoodGameplay object");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.words = [aDecoder decodeObjectForKey:@"words"];
    self.currentWord = [aDecoder decodeObjectForKey:@"currentWord"];
    self.unknownLettersLeft = [aDecoder decodeIntegerForKey:@"unknownLettersLeft"];
    self.guessedLetters = [aDecoder decodeObjectForKey:@"guessedLetters"];
    self.currentProgress = [aDecoder decodeObjectForKey:@"currentProgress"];
    self.guesses = [aDecoder decodeIntegerForKey:@"guesses"];
    self.currentGuess = [aDecoder decodeIntegerForKey:@"currentGuess"];
    self.playerWonGame = [aDecoder decodeBoolForKey:@"playerWonGame"];
    self.alert = [aDecoder decodeObjectForKey:@"alert"];
    NSLog(@"Decoded GoodGameplay object");
    
    return self;
}

@end
