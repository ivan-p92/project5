//
//  EquivalenceClass.h
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  This class is used to calculate the equivalence class of a given
//  word for a given letter. It also keeps track of all current
//  classes and the words belonging to them.
//

#import <Foundation/Foundation.h>

@interface EquivalenceClass : NSObject

// Dictionary that holds the words (objects) for each class (keys)
@property (strong, nonatomic) NSMutableDictionary *classes;

// Adds given word to the correct equivalence class for the given
// letter. The equivalence class is determined by calling
// -equivalenceClassForWord:andLetter:.
- (void)addWordToClass:(NSString *) word forLetter:(NSString *) letter;

// Given a word and a letter, determines the equivalence class
// of the word for that letter. Returns the string representation
// of the class.
- (NSString *)equivalenceClassForWord:(NSString *) word andLetter:(NSString *) letter;

// Returns a dictionary with two objects: a string for the largest
// equivalence class and an array with all words belonging to that
// class. If there is a tie, specific heuristics are followed.
- (NSDictionary *)largestClassAndIndexes;

@end
