//
//  History.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  A History object manages the list of high scores. It loads list,
//  calculates and adds scores and can reset the list.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

// First score of |scores| is lowest score and each object
// in |words| and |guesses| corresponds to a score.
@property (strong, nonatomic) NSMutableArray *scores;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) NSMutableArray *guesses;
@property (strong, nonatomic) NSNumber *mostRecentScore;

// Returns path to highscores.plist.
- (NSString *)highscoresPath;

// Loads high scores from highscores.plist in /Documents/.
- (void)loadHighScores;

// Creates new highscores.plist in /Documents/.
- (void)createHighScoresAtPath:(NSString *)path;

// Calculates score for a word and number of errors and saves it if
// it is a new high score.
// Returns YES if the score was a new high and NO if it wasn't.
- (BOOL)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses;

// Used by calculateAndSaveScoreWithWord to update highscores.plist.
- (void)updateHighScoresWithScore:(NSNumber *)score word:(NSString *)word guesses:(NSNumber *)guesses;

// Resets all high scores to zero.
- (void)resetHighScores;

@end
