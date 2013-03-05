//
//  History.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property (strong, nonatomic) NSMutableDictionary *highScores;

// loads high scores from highscores.plist in /Documents
- (void)loadHighScores;

// create highscores.plist in /Documents
- (void)createHighScoresAtPath:(NSString *)path;

// calculate score for a game and save it if it is a high score
- (void)calculateAndSaveScoreWithWord:(NSString *)word andGuesses:(NSUInteger)guesses;

// Used by calculateAndSaveScoreWithWord to update highscores.plist
- (void)updateHighScoresWithScore:(NSUInteger)score andInfo:(NSString *)info;

@end
