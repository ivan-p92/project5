//
//  History.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "History.h"

@interface History ()

@end

@implementation History

- (id)init
{
    self = [super init];
    
    [self loadHighScores];
    
    return self;
}

- (void)loadHighScores
{
    // Get path to file highscores.plist in /Documents directory
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"highscores.plist"];
    
    // If the file exists, load the scores into |highScores|, else
    // create a new highscores.plist file
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"Loading high scores from highscores.plist");
        NSDictionary *scoresAndInfo = [NSDictionary dictionaryWithContentsOfFile:path];
        
        self.scores = [[scoresAndInfo objectForKey:@"scores"] mutableCopy];
        self.words = [[scoresAndInfo objectForKey:@"words"] mutableCopy];
        NSLog(@"High scores and info:\n%@", scoresAndInfo);
    }
    else {
        NSLog(@"High scores don't exist yet, create new ones");
        [self createHighScoresAtPath:path];
    }
}

- (void)createHighScoresAtPath:(NSString *)path
{
    NSUInteger numberOfEntries = 10;
    NSMutableArray *scoresArray = [[NSMutableArray alloc] init];
    NSMutableArray *wordsArray = [[NSMutableArray alloc] init];
    NSMutableArray *guessesArray = [[NSMutableArray alloc] init];
    
    // Create array of scores (all zero) and
    // Create array of details (all empty string)
    for (NSUInteger i = 1; i <= numberOfEntries; i++) {
        [scoresArray addObject:[NSNumber numberWithInt:0]];
        [wordsArray addObject:@""];
        [guessesArray addObject:@""];
    }
    
    NSDictionary *highscores = @{
                                 @"scores": scoresArray,
                                 @"words": wordsArray,
                                 @"guesses": guessesArray
                                 };
    
    // Write the highscores dictionary to /Documents/highscores.plist
    [highscores writeToFile:path atomically:YES];
    NSLog(@"Highscore.plist has been created, loading it again");
    
    // Load the new scores into the |highScores| property
    [self loadHighScores];
}

- (void)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses
{
    // Calculate score using  (27 - guesses) * (25 - wordLength)
    NSUInteger intScore = (27 - guesses) * (25 - [word length]);
    NSNumber *score = [NSNumber numberWithInt:intScore];
    
    NSLog(@"The score is: %@", score);
    if (score > [self.scores objectAtIndex:0]) {
        NSLog(@"It is a new high score");
        [self updateHighScoresWithScore:score word:word guesses:[NSNumber numberWithInt:guesses]];
    }
    
}

- (void)updateHighScoresWithScore:(NSNumber *)score word:(NSString *)word guesses:(NSNumber *)guesses
{
    // Find index new score by finding index of next highest score
    NSUInteger index = 1;
    for (; index < [self.scores count]; index++) {
        if ([[self.scores objectAtIndex:index] integerValue] > [score integerValue]) {
            break;
        }
    } // end for
    
    // insert score at the new index and then remove the first item in the list,
    // thereby removing the lowest high score
    NSLog(@"Inserting %@ at %d", score, index);
    [self.scores insertObject:score atIndex:index];
    [self.scores removeObjectAtIndex:0];
}

- (void)resetHighScores
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"highscores.plist"];
    
    [self createHighScoresAtPath:path];
}

@end
