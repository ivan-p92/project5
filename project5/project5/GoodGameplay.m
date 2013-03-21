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
    
    // Generally, this init will never be called.
    NSArray *words = [NSArray arrayWithObject:@"FOO"];
    return [self initGameWithWords:words andGuesses:2];
}

- (id)initGameWithWords:(NSArray *)words andGuesses:(int)guesses
{
    NSLog(@"Good game init.");
    self = [super init];
    
    // Pick a random word from the list of words.
    NSUInteger randomIndex = arc4random() % [words count];
    self.currentWord = [words objectAtIndex:randomIndex];
    
    self.guesses = guesses;
    self.currentGuess = 0;
    self.unknownLettersLeft = [self.currentWord length];
    self.guessedLetters = [NSMutableString stringWithString:@""];
    self.words = nil;
    
    self.currentProgress = [[NSMutableString alloc] init];
    
    // Change currentProgress into hyphens.
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
    
    NSUInteger wordLength = [self.currentWord length];
    NSRange searchRange = NSMakeRange(0, wordLength);
    NSRange matchRange;
    
    // Look for occurrences of the played letter in the word.
    // Stops if last letter is a match or if no matches left.
    do {
        matchRange = [self.currentWord rangeOfString:letter options:0 range:searchRange];
        
        // Letter was found, so update currentProgress and other properties
        if (matchRange.location != NSNotFound) {
            self.unknownLettersLeft--;
            letterWasFound = YES;
            
            // Put the letter at the right place in the progress string.
            [self.currentProgress replaceCharactersInRange:matchRange withString:letter];
        
            // If the matched letter is the last letter of the word, stop the search.
            if (matchRange.location == wordLength - 1) {
                break;
            }
            // If not, update |searchRange| to look for next match.
            else {
                searchRange = NSMakeRange(matchRange.location + 1, wordLength - (matchRange.location + 1));
            }
            
        }
    } while (matchRange.location != NSNotFound);
    
    // Set the message that will be shown to the user.
    if (letterWasFound) {
        self.alert = @"Good choice!";
    }
    else {
        self.currentGuess++;
        self.alert = @"Wrong choice...";
    }
    
    // Check for end of game if all letters found...
    if (self.unknownLettersLeft == 0) {
        self.playerWonGame = YES;
        return NO;
    }
    // ... or if maximum number of wrong guesses has been reached.
    else if (self.currentGuess == self.guesses) {
        self.playerWonGame = NO;
        return NO;
    }
    // If the game hasn't ended yet, return YES.
    else {
        return YES;
    }
}

# pragma mark - NSCoding methods

// Encode the game.
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

// Decode a game.
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
