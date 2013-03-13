//
//  History.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

// first score of |scores| is lowest score and each object
// in |words| and |guesses| corresponds to a score
@property (strong, nonatomic) NSMutableArray *scores;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) NSMutableArray *guesses;
@property (strong, nonatomic) NSNumber *mostRecentScore;

// returns path to highscores.plist
- (NSString *)highscoresPath;

// loads high scores from highscores.plist in /Documents
- (void)loadHighScores;

// create highscores.plist in /Documents
- (void)createHighScoresAtPath:(NSString *)path;

// calculate score for a game and save it if it is a high score
- (BOOL)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses;

// Used by calculateAndSaveScoreWithWord to update highscores.plist
- (void)updateHighScoresWithScore:(NSNumber *)score word:(NSString *)word guesses:(NSNumber *)guesses;

// Resets all high scores to zero
- (void)resetHighScores;

@end
