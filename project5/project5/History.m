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
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    // Create array of scores (all zero) and
    // create array of details (all empty string)
    for (NSUInteger i = 1; i <= numberOfEntries; i++) {
        [scoresArray addObject:[NSNumber numberWithInt:0]];
        [infoArray addObject:@""];
    }
    
    NSDictionary *highscores = @{
                                 @"scores": scoresArray,
                                 @"info": infoArray
                                 };
    
    // write the highscores dictionary to /Documents/highscores.plist
    [highscores writeToFile:path atomically:YES];
    NSLog(@"Highscore.plist has been created, loading it again");
    
    // load the new scores into the |highScores| property
    [self loadHighScores];
}

- (void)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses
{
    // TODO
}

- (void)updateHighScoresWithScore:(NSUInteger)score andInfo:(NSString *)info
{
    // TODO
}

@end
