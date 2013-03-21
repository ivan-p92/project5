//
//  History.m
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "History.h"

@implementation History

- (id)init
{
    self = [super init];
    
    // Load scores into properties when initializing.
    [self loadHighScores];
    
    return self;
}

- (NSString *)highscoresPath
{
    // Get path to file highscores.plist in /Documents/ directory.
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:@"highscores.plist"];
}

- (void)loadHighScores
{
    NSString *path = [self highscoresPath];
    
    // If the file exists, load the scores into |highScores|, else
    // create a new highscores.plist file.
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *scoresAndInfo = [NSDictionary dictionaryWithContentsOfFile:path];
        
        self.scores = [[scoresAndInfo objectForKey:@"scores"] mutableCopy];
        self.words = [[scoresAndInfo objectForKey:@"words"] mutableCopy];
        self.guesses = [[scoresAndInfo objectForKey:@"guesses"] mutableCopy];
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
    NSNumber *zero = [NSNumber numberWithInt:0];
    
    // Create array of scores (all zero) and
    // create array of details (all empty string).
    for (NSUInteger i = 1; i <= numberOfEntries; i++) {
        [scoresArray addObject:zero];
        [wordsArray addObject:@""];
        [guessesArray addObject:@""];
    }
    
    NSDictionary *highscores = @{
                                 @"scores": scoresArray,
                                 @"words": wordsArray,
                                 @"guesses": guessesArray
                                 };
    
    // Write the highscores dictionary to /Documents/highscores.plist.
    [highscores writeToFile:path atomically:YES];
    NSLog(@"Highscore.plist has been created, loading it again");
    
    // Load the new scores into the |highScores| property
    [self loadHighScores];
}

- (BOOL)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses
{
    // Calculate score using  (27 - guesses) * (25 - wordLength).
    NSUInteger score = (27 - guesses) * (25 - [word length]);
    
    self.mostRecentScore = [NSNumber numberWithInt:score];
    
    BOOL scoreIsHighScore = NO;
    
    // If it is a high score, update the list using -updateHighScoresWithScore:word:guesses:.
    if (score > [[self.scores objectAtIndex:0] integerValue]) {
        scoreIsHighScore = YES;
        NSNumber *newScore = [NSNumber numberWithInt:score];
        [self updateHighScoresWithScore:newScore word:word guesses:[NSNumber numberWithInt:guesses]];
    }
    
    return scoreIsHighScore;
}

- (void)updateHighScoresWithScore:(NSNumber *)score word:(NSString *)word guesses:(NSNumber *)guesses
{
    // Find index of new score by finding index of next highest score.
    NSUInteger index = 1;
    for (; index < [self.scores count]; index++) {
        // Next score is higher than the new score, so stop.
        if ([[self.scores objectAtIndex:index] integerValue] >= [score integerValue]) {
            break;
        }
    } // end for
    
    // Insert score at the new index and then remove the first item in the list,
    // thereby removing the lowest high score.
    [self.scores insertObject:score atIndex:index];
    [self.scores removeObjectAtIndex:0];
    
    // The same process for the word and number of wrong guesses.
    [self.words insertObject:[word lowercaseString] atIndex:index];
    [self.words removeObjectAtIndex:0];
    [self.guesses insertObject:guesses atIndex:index];
    [self.guesses removeObjectAtIndex:0];
    
    // Now save the scores and info to the /Documents/highscores.plist file.
    NSString *path = [self highscoresPath];
    
    NSDictionary *highscores = @{
                                 @"scores": self.scores,
                                 @"words": self.words,
                                 @"guesses": self.guesses
                                 };
    
    // Write the highscores dictionary to /Documents/highscores.plist
    [highscores writeToFile:path atomically:YES];
}

- (void)resetHighScores
{
    NSString *path = [self highscoresPath];
    
    [self createHighScoresAtPath:path];
}

@end
