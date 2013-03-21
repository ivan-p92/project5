//
//  EvilGameplay.h
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  Objects from this class represent an evil (unfair) hangman game.
//  This class implements all properties and methods from GamePlay-
//  Delegate and adds an additional method and property to deal with
//  equivalence classes.
//
//  Implements NSCoding to create save games.
//

#import <Foundation/Foundation.h>
#import "GameplayDelegate.h"
@class EquivalenceClass;

@interface EvilGameplay : NSObject <GameplayDelegate, NSCoding>

// This EquivalenceClass object is used to calculate the equivalence
// classes of all remaining words for the played letter.
@property (strong, nonatomic) EquivalenceClass *classes;

// This additional method puts the played letter at the right place
// in the user's progress string. It does so by looking at the given
// equivalence class.
- (void)updateCurrentProgressWithClass:(NSString *) equivalenceClass andLetter:(NSString *) letter;

@end
