//
//  GoodGameplay.h
//  project5
//
//  Created by Ivan Plantevin on 28-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//
//  Objects from this class represent a fair hangman game.
//  This class implements all properties and methods from GamePlay-
//  Delegate and doesn't add any methods or properties.
//
//  Implements NSCoding to create save games.
//

#import <Foundation/Foundation.h>
#import "GameplayDelegate.h"
@class EquivalenceClass;

@interface GoodGameplay : NSObject <GameplayDelegate, NSCoding>

@end
