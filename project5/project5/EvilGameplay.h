//
//  EvilGameplay.h
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameplayDelegate.h"
@class EquivalenceClass;

@interface EvilGameplay : NSObject <GameplayDelegate, NSCoding>

@property (strong, nonatomic) EquivalenceClass *classes;

- (void)updateCurrentProgressWithClass:(NSString *) equivalenceClass andLetter:(NSString *) letter;

@end
