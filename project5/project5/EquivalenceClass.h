//
//  EquivalenceClass.h
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquivalenceClass : NSObject

@property (strong, nonatomic) NSMutableDictionary *classes;

- (void)addWordToClass:(NSString *) word forLetter:(NSString *) letter;
- (NSString *)equivalenceClassForWord:(NSString *) word andLetter:(NSString *) letter;
// TODO: get largest class and locations of letter if letter is guessed
- (NSDictionary *)largestClassAndIndexes;
@end
