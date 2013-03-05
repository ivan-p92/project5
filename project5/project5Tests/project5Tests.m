//
//  project5Tests.m
//  project5Tests
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "project5Tests.h"
#import "EvilGameplay.h"

@interface project5Tests ()

@property EvilGameplay *evilGame;

@end

@implementation project5Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.evilGame = [EvilGameplay alloc];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEvilGame
{
    NSArray *words = [NSArray arrayWithObjects:
                      @"BEAR",
                      @"BOAR",
                      @"DEER",
                      @"DUCK",
                      @"HARE",
                      nil];
    
    STAssertNotNil(words, @"Word list not found");
    
    // Initialize new evil hangman game
    self.evilGame = [self.evilGame initGameWithWords: words andGuesses:5];
    STAssertEqualObjects(words, self.evilGame.words, @"Game word list not set correctly");
    STAssertEquals(5, self.evilGame.guesses, @"Number of guesses not set correctly");
    STAssertNotNil(self.evilGame.currentWord, @"No word was chosen at init");
    STAssertNotNil(self.evilGame.classes, @"Object of type EquivalenceClass should not be nil");
    STAssertEquals(0, self.evilGame.currentGuess, @"Number of wrong guesses after init isn't zero");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@""], @"Guessed letters doesn't equal empty string at init");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"----"], @"User progress doesn't equal four hyphens");
    STAssertFalse(self.evilGame.playerWonGame, @"Player hasn't lost by default");
    
    // Play a round for the letter D, which should be incorrect letter,
    // resulting in words list: BEAR, BOAR, HARE
    // Note that all playRoundForLetter calls are tested for truth,
    // to verify that the method only returns NO when the game is finished
    STAssertTrue([self.evilGame playRoundForLetter:@"D"], @"Game is not finished so playRoundForLetters should return YES");
    
    // Check that it was indeed treated as incorrect guess
    STAssertEquals(1, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"----"], @"User progress doesn't equal four hyphens");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@"D"], @"Played letter wasn't added to guessed letters");
    
    // Check that the new list of words equals the expected one
    NSArray *newWords = [NSArray arrayWithObjects:
                         @"BEAR",
                         @"BOAR",
                         @"HARE",
                         nil];
    STAssertTrue([self.evilGame.words isEqualToArray:newWords], @"List of new words doesn't match BEAR, BOAR, HARE");
    
    // Now play a round for letter B, which should give new words BEAR and BOAR,
    // resulting in user progress: "B---" and no increase in wrong guess
    STAssertTrue([self.evilGame playRoundForLetter:@"B"], @"Game is not finished so playRoundForLetters should return YES");
    STAssertEquals(1, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"B---"], @"User progress doesn't match B---");
    newWords = [NSArray arrayWithObjects:@"BEAR",@"BOAR", nil];
    STAssertTrue([self.evilGame.words isEqualToArray:newWords], @"List of new words doesn't match BEAR, BOAR");
    
    // Play a round for letter X, not in list of words, resulting in no change
    // of words list and progress, increase of wrong guesses by 1
    // string of guessed letters should now equal "DBX"
    STAssertTrue([self.evilGame playRoundForLetter:@"X"], @"Game is not finished so playRoundForLetters should return YES");
    STAssertEquals(2, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"B---"], @"User progress doesn't match B---");
    STAssertTrue([self.evilGame.words isEqualToArray:newWords], @"List of new words doesn't match BEAR, BOAR");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@"DBX"], @"Played letters doesn't match DBX");
    
    // Now play the letter O. The algorithm should choose BEAR as new word.
    STAssertTrue([self.evilGame playRoundForLetter:@"O"], @"Game is not finished so playRoundForLetters should return YES");
    STAssertEquals(3, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"B---"], @"User progress doesn't match B---");
    newWords = [NSArray arrayWithObject:@"BEAR"];
    STAssertTrue([self.evilGame.words isEqualToArray:newWords], @"List of new words doesn't match BEAR");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@"DBXO"], @"Played letters doesn't match DBXO");
    
    // Two rounds are now played for E and for A
    STAssertTrue([self.evilGame playRoundForLetter:@"E"], @"Game is not finished so playRoundForLetters should return YES");
    STAssertTrue([self.evilGame playRoundForLetter:@"A"], @"Game is not finished so playRoundForLetters should return YES");
    STAssertEquals(3, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    STAssertTrue([self.evilGame.currentProgress isEqualToString:@"BEA-"], @"User progress doesn't match BEA-");
    STAssertTrue([self.evilGame.words isEqualToArray:newWords], @"List of new words doesn't match BEAR");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@"DBXOEA"], @"Played letters doesn't match DBXOEA");
    
    // The final letter, R, is played.
    // This should result in the player winning the game, resulting
    // in playRoundForLetter returning NO and playerWonGame being YES
    STAssertFalse([self.evilGame playRoundForLetter:@"R"], @"Game is finished so playRuondForLetter should return NO");
    STAssertTrue([self.evilGame.guessedLetters isEqualToString:@"DBXOEAR"], @"Played letters doesn't match DBXOEAR");
    STAssertTrue(self.evilGame.playerWonGame, @"Player should have won game");
    
    /////////////////////////////////////////////////
    
    // A new evil game is created, this time with only two allowed wrong guesses
    self.evilGame = [[EvilGameplay alloc] initGameWithWords:words andGuesses:2];
    
    // X is played as first letter, resulting in one wrong guess
    STAssertTrue([self.evilGame playRoundForLetter:@"X"], @"Game is not finished yet, playRoundForLetter should return YES");
    STAssertEquals(1, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
    
    // Y is played as second wrong letter, resulting in NO being
    // returned from playRoundForLetter
    STAssertFalse([self.evilGame playRoundForLetter:@"Y"], @"Game is over, playRoundForLetter should return NO");
    STAssertFalse(self.evilGame.playerWonGame, @"Player should have lost");
    STAssertEquals(2, self.evilGame.currentGuess, @"Current number of wrong guesses doesn't match expected value");
}

@end
