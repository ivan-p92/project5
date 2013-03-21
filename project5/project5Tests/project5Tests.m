//
//  project5Tests.m
//  project5Tests
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "project5Tests.h"
#import "EvilGameplay.h"
#import "EquivalenceClass.h"
#import "History.h"
#import "GoodGameplay.h"

@interface project5Tests ()

@property (strong, nonatomic) EvilGameplay *evilGame;
@property (strong, nonatomic) GoodGameplay *fairGame;
@property (strong, nonatomic) EquivalenceClass *equivalenceClass;
@property (strong, nonatomic) History *highscores;

@end

@implementation project5Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEvilGame
{
    self.evilGame = [EvilGameplay alloc];
    
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

- (void)testGoodGameplay
{
    NSArray *words = [NSArray arrayWithObjects:
                      @"BEAR",
                      @"BOAR",
                      @"DEER",
                      @"DUCK",
                      @"HARE",
                      nil];
    
    self.fairGame = [[GoodGameplay alloc] initGameWithWords:words andGuesses:4];
    
    STAssertEqualObjects(nil, self.fairGame.words, @"Game word list not set to nil");
    STAssertEquals(4, self.fairGame.guesses, @"Number of guesses not set correctly");
    STAssertNotNil(self.fairGame.currentWord, @"No word was chosen at init");
    STAssertEquals(0, self.fairGame.currentGuess, @"Number of wrong guesses after init isn't zero");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@""], @"Guessed letters doesn't equal empty string at init");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"----"], @"User progress doesn't equal four hyphens");
    STAssertFalse(self.evilGame.playerWonGame, @"Player hasn't lost by default");
    
    // Override currentWord to DEER
    self.fairGame.currentWord = @"DEER";
    
    // Play a round for letter D and check that the properties have expected values
    STAssertTrue([self.fairGame playRoundForLetter:@"D"],@"Game not finished, should return YES");
    STAssertTrue([self.fairGame.currentWord isEqualToString:@"DEER"], @"Current word should still be DEER");
    STAssertEquals(3, self.fairGame.unknownLettersLeft, @"Number of unknown letters isn't equal to 3");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@"D"], @"Guessed letters should be equal to D");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"D---"], @"Current progress should be equal to D---");
    STAssertEquals(0, self.fairGame.currentGuess, @"There was no wrong guess, so currentGuess should still be 0");
    STAssertFalse(self.fairGame.playerWonGame, @"Player hasn't finished game yet so hasn't won yet");
    
    // Play a round for letter X and check that the properties have expected values
    STAssertTrue([self.fairGame playRoundForLetter:@"X"],@"Game not finished, should return YES");
    STAssertEquals(3, self.fairGame.unknownLettersLeft, @"Number of unknown letters isn't equal to 3");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@"DX"], @"Guessed letters should be equal to DX");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"D---"], @"Current progress should be equal to D---");
    STAssertEquals(1, self.fairGame.currentGuess, @"There was 1 wrong guess, so currentGuess should now be 1");
    STAssertFalse(self.fairGame.playerWonGame, @"Player hasn't finished game yet so hasn't won yet");
    
    // Play a round for letter E and check that the properties have expected values
    STAssertTrue([self.fairGame playRoundForLetter:@"E"],@"Game not finished, should return YES");
    STAssertEquals(1, self.fairGame.unknownLettersLeft, @"Number of unknown letters isn't equal to 1");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@"DXE"], @"Guessed letters should be equal to DXE");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"DEE-"], @"Current progress should be equal to DEE-");
    STAssertEquals(1, self.fairGame.currentGuess, @"Wrong guesses should still be 1");
    STAssertFalse(self.fairGame.playerWonGame, @"Player hasn't finished game yet so hasn't won yet");
    
    // Play a round for letter R and check that the properties have expected values
    STAssertFalse([self.fairGame playRoundForLetter:@"R"],@"Game is finished, should return NO");
    STAssertEquals(0, self.fairGame.unknownLettersLeft, @"Number of unknown letters isn't equal to 0");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@"DXER"], @"Guessed letters should be equal to DXER");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"DEER"], @"Current progress should be equal to DEER");
    STAssertEquals(1, self.fairGame.currentGuess, @"Wrong guesses should still be 1");
    STAssertTrue(self.fairGame.playerWonGame, @"Player should have won game");
    
    // Start a new game with just two allowed errors to check for correct
    // end of game if user loses.
    self.fairGame = [[GoodGameplay alloc] initGameWithWords:words andGuesses:2];
    self.fairGame.currentWord = @"DEER";
    
    // Play two rounds with wrong letters. Only check after second round.
    STAssertTrue([self.fairGame playRoundForLetter:@"X"], @"Game isn't finished yet, should return YES");
    STAssertFalse([self.fairGame playRoundForLetter:@"Q"], @"Player lost so game is finished, should return NO");
    STAssertEquals(4, self.fairGame.unknownLettersLeft, @"Number of unknown letters isn't equal to 4");
    STAssertTrue([self.fairGame.guessedLetters isEqualToString:@"XQ"], @"Guessed letters should be equal to XQ");
    STAssertTrue([self.fairGame.currentProgress isEqualToString:@"----"], @"Current progress should be equal to ----");
    STAssertEquals(2, self.fairGame.currentGuess, @"Wrong guesses should be 2");
    STAssertFalse(self.fairGame.playerWonGame, @"Player should have lost game");
}

- (void)testEquivalenceClass
{
    // After initialization, the |classes| dictionary should not be nil
    self.equivalenceClass = [[EquivalenceClass alloc] init];
    STAssertNotNil(self.equivalenceClass.classes, @"|classes| dictionary should not be nil");
    
    // First, the method that determines the equivalence class for a given
    // word and letter will be tested
    NSString *class;
    
    // The equivalence class for BANANA should be "2-4-6-"
    class = [self.equivalenceClass equivalenceClassForWord:@"BANANA" andLetter:@"A"];
    STAssertTrue([class isEqualToString:@"2-4-6-"], @"Equivalence class for BANANA and A should be 2-4-6-");
    
    // When the letter isn't found, the class should be "0-"
    class = [self.equivalenceClass equivalenceClassForWord:@"BANANA" andLetter:@"X"];
    STAssertTrue([class isEqualToString:@"0-"], @"Equivalence class for BANANA and X should be 0-");
    
    
    // A dictionary is made to be compared to the one created by
    // EquivalenceClass
    NSMutableDictionary *classes = [[NSMutableDictionary alloc] init];
    NSArray *bananaArray = [NSArray arrayWithObject:@"BANANA"];
    NSArray *bearTearArray = [NSArray arrayWithObjects:@"BEAR",@"TEAR", nil];
    NSArray *beerArray = [NSArray arrayWithObject:@"BEER"];
    [classes setObject:bananaArray forKey:@"0-"];
    [classes setObject:bearTearArray forKey:@"2-"];
    [classes setObject:beerArray forKey:@"2-3-"];
    
    // With the following calls to the EquivalenceClass object,
    // the same dictionary should be obtained
    [self.equivalenceClass addWordToClass:@"BANANA" forLetter:@"E"];
    [self.equivalenceClass addWordToClass:@"BEAR" forLetter:@"E"];
    [self.equivalenceClass addWordToClass:@"TEAR" forLetter:@"E"];
    [self.equivalenceClass addWordToClass:@"BEER" forLetter:@"E"];
    
    // Equivalence check
    STAssertTrue([classes isEqualToDictionary:self.equivalenceClass.classes], @"Dictionary of equivalence classes doesn't match expected dictionary");
    
    // Final check: check whether largest equivalence class is 2-
    // and corresponding words BEAR and TEAR
    NSDictionary *largestClass = [self.equivalenceClass largestClassAndIndexes];
    STAssertTrue([[largestClass objectForKey:@"largestClass"] isEqual:@"2-"], @"Largest equivalence class should be 2-");
    STAssertTrue([[largestClass objectForKey:@"newWords"] isEqualToArray:bearTearArray], @"Words belonging to largest class should be BEAR and TEAR");
    
    // For more complex checks (in case of ties and such) it is easier
    // to test in testEvilGame
}

- (void)testHistory
{
    self.highscores = [[History alloc] init];
    
    // Set array of highscores manually to test for correct insertion
    NSMutableArray *scores = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i <= 50; i += 10) {
        [scores addObject:[NSNumber numberWithInt:i]];
    }
    self.highscores.scores = [scores mutableCopy];
    
    // Insert highscore of 5
    [self.highscores updateHighScoresWithScore:[NSNumber numberWithInt:5] word:@"Foo" guesses:[NSNumber numberWithInt:5]];
    [scores replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:5]];
    NSLog(@"New list should be:\n%@", scores);
    NSLog(@"Result of History object:\n%@", self.highscores.scores);
    STAssertTrue([scores isEqualToArray:self.highscores.scores], @"Insertion of score 5 wasn't successful");
    
    // Insert highscore 15. Should result in 10,15,20,30,40,50
    [scores replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:10]];
    [scores replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:15]];
    [self.highscores updateHighScoresWithScore:[NSNumber numberWithInt:15] word:@"Foo" guesses:[NSNumber numberWithInt:5]];
    NSLog(@"New list should be:\n%@", scores);
    NSLog(@"Result of History object:\n%@", self.highscores.scores);
    STAssertTrue([scores isEqualToArray:self.highscores.scores], @"Insertion of score 15 wasn't successful");
    
    // Test for inserting biggest score yet
    [scores removeObjectAtIndex:0];
    [scores addObject:[NSNumber numberWithInt:55]];
    [self.highscores updateHighScoresWithScore:[NSNumber numberWithInt:55] word:@"Foo" guesses:[NSNumber numberWithInt:5]];
    NSLog(@"New list should be:\n%@", scores);
    NSLog(@"Result of History object:\n%@", self.highscores.scores);
    STAssertTrue([scores isEqualToArray:self.highscores.scores], @"Insertion of score 55 wasn't successful");
}

@end
