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
    
    int randomWordIndex = arc4random() % [self.words count];
    self.currentWord = (NSString*) [self.words objectAtIndex:randomWordIndex];
    self.currentProgress = [NSMutableString new];
    
    // change currentProgress into hyphens
    for (int i = 1; i <= self.unknownLettersLeft; i++) {
        [self.currentProgress appendString:@"-"];
    }
    NSLog(@"Word: %@", self.currentWord);
//    NSLog(@"StartString: %@", self.currentProgress);
    
    return self;
}

- (BOOL)playRoundForLetter:(NSString *)letter
{
    [self.guessedLetters appendString:letter];
    
    for (NSString *word in self.words) {
        [self.classes addWordToClass:word forLetter:letter];
    }
    
    // get new set of words and best equivalence class
    NSDictionary *result = [self.classes largestClassAndIndexes];
    
    self.words = [result objectForKey:@"newWords"];
    NSString *bestClass = [result objectForKey:@"largestClass"];
//    NSLog(@"New words: %@", self.words);
    
    int randomWordIndex = arc4random() % [self.words count];
    self.currentWord = (NSString*) [self.words objectAtIndex:randomWordIndex];
    
    [self updateCurrentProgressWithClass:bestClass andLetter:letter];
    
    // decrement number of letters left (if 0 then it wasn't found, so no change)
    if (![bestClass isEqual: @"0-"]) {
        NSArray *locations = [bestClass componentsSeparatedByString:@"-"];
        self.unknownLettersLeft -= [locations count] - 1;
        self.alert = @"Good choice!";
    }
    // if letter wasn't found, increment guesses
    else {
        self.alert = @"Wrong choice...";
        self.currentGuess++;
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

- (void)updateCurrentProgressWithClass:(NSString *)equivalenceClass andLetter:(NSString *)letter
{
    if (![equivalenceClass isEqual: @"0-"]) {
        NSUInteger location;
        NSArray *locations = [equivalenceClass componentsSeparatedByString:@"-"];
        for (int i = 0; i < [locations count] - 1; i++) {
            location = [[locations objectAtIndex:i] integerValue] - 1;
            [self.currentProgress replaceCharactersInRange:NSMakeRange(location, 1) withString:letter];
        }
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
    NSLog(@"Encoded EvilGameplay object");
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
    self.classes = [[EquivalenceClass alloc] init];
    NSLog(@"Decoded EvilGameplay object");
    
    return self;
}

@end
