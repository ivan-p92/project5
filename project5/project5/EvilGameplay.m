//
//  EvilGameplay.m
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "EvilGameplay.h"
#import "EquivalenceClass.h"

@implementation EvilGameplay

@synthesize words = _words;
@synthesize currentWord = _currentWord;
@synthesize unknownLettersLeft = _unknownLettersLeft;
@synthesize currentProgress = _currentProgress;
@synthesize guesses = _guesses;
@synthesize currentGuess = _currentGuess;
@synthesize playerWonGame = _playerWonGame;
@synthesize guessedLetters = _guessedLetters;
@synthesize alert = _alert;

- (id)init
{
    self = [super init];
    
    // Normally, this init isn't called.
    NSArray *words = [NSArray arrayWithObject:@"FOO"];
    return [self initGameWithWords:words andGuesses:2];
}

- (id)initGameWithWords:(NSArray *)words andGuesses:(int)guesses
{
    NSLog(@"Evil game init.");
    self = [super init];
    
    self.classes = [[EquivalenceClass alloc] init];
    self.words = words;
    self.guesses = guesses;
    self.currentGuess = 0;
    self.unknownLettersLeft = [[self.words objectAtIndex:0] length];
    self.guessedLetters = [NSMutableString stringWithString:@""];
    
    // Pick een random word from the available words.
    int randomWordIndex = arc4random() % [self.words count];
    self.currentWord = (NSString*) [self.words objectAtIndex:randomWordIndex];
    self.currentProgress = [NSMutableString new];
    
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
    
    for (NSString *word in self.words) {
        [self.classes addWordToClass:word forLetter:letter];
    }
    
    // Get new set of words and best equivalence class.
    NSDictionary *result = [self.classes largestClassAndIndexes];
    
    self.words = [result objectForKey:@"newWords"];
    NSString *bestClass = [result objectForKey:@"largestClass"];
    
    // Choose a new random word from the remaining words.
    int randomWordIndex = arc4random() % [self.words count];
    self.currentWord = (NSString*) [self.words objectAtIndex:randomWordIndex];
    
    // Update progress string if the letter was found.
    if (![bestClass isEqual: @"0-"]) {
        [self updateCurrentProgressWithClass:bestClass andLetter:letter];
        self.alert = @"Good choice!";
    }
    // If letter wasn't found, increment wrong guesses
    else {
        self.alert = @"Wrong choice...";
        self.currentGuess++;
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

- (void)updateCurrentProgressWithClass:(NSString *)equivalenceClass andLetter:(NSString *)letter
{
    // Get the locations and decrease the number of letters remaining to guess.
    NSUInteger location;
    NSArray *locations = [equivalenceClass componentsSeparatedByString:@"-"];
    self.unknownLettersLeft -= [locations count] - 1;
    
    // Put the letter at the right places in the progress string.
    for (int i = 0; i < [locations count] - 1; i++) {
        location = [[locations objectAtIndex:i] integerValue] - 1;
        [self.currentProgress replaceCharactersInRange:NSMakeRange(location, 1) withString:letter];
    }
}

# pragma mark - NSCoding methods

// Encodes the game.
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
    NSLog(@"Encoded EvilGameplay object");
}

// Decodes a game.
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
    self.classes = [[EquivalenceClass alloc] init];
    NSLog(@"Decoded EvilGameplay object");
    
    return self;
}

@end
