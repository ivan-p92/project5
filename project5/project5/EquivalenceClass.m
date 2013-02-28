//
//  EquivalenceClass.m
//  Evil Test
//
//  Created by Ivan Plantevin on 22-02-13.
//  Copyright (c) 2013 Ivan Plantevin. All rights reserved.
//

#import "EquivalenceClass.h"

@implementation EquivalenceClass

- (id)init
{
    self = [super init];
    self.classes = [NSMutableDictionary new];
    return self;
}

- (void)addWordToClass:(NSString *)word forLetter:(NSString *)letter
{
    NSString *equivalenceClass = [self equivalenceClassForWord:word andLetter:letter];
//    NSLog(@"Word: %@, Letter:%@, Class:%@", word, letter, equivalenceClass);
    
    NSMutableArray *class = nil;
    // add word to dictionary with this class
    class = [self.classes objectForKey:equivalenceClass];
    if (class == nil) {
        //NSLog(@"Make class: %@, with word: %@", equivalenceClass, word);
        class = [NSMutableArray arrayWithObject:word];
        [self.classes setObject:class forKey:equivalenceClass];
    }
    else {
        //NSLog(@"Add to class:%@", word);
        [class addObject:word];
    }

}


- (NSString *)equivalenceClassForWord:(NSString *)word andLetter:(NSString *)letter
{
    // assume letter doesn't appear in word
    BOOL letterFound = NO;
    NSMutableString *equivalenceClass = [NSMutableString new];
    NSMutableString *mutableWord = [word mutableCopy];
    NSRange range;
    
    // get range of occurence and continue until all occurences have been found
    do {
        range = [mutableWord rangeOfString:letter];
        
        // if the letter is found, append location to class string
        // and replace the letter with zero so that next occurence
        // can be found
        if (range.location != NSNotFound) {
            letterFound = YES;
            [equivalenceClass appendString:[NSString stringWithFormat:@"%ld-", (unsigned long)range.location + 1]];
            [mutableWord replaceCharactersInRange:range withString:@"0"];
        }
    } while (range.location != NSNotFound);
    
    if (!letterFound) {
        [equivalenceClass appendString:@"0-"];
    }
    
    return (NSString *) equivalenceClass;
}

- (NSDictionary *)largestClassAndIndexes
{
    NSUInteger largestNumberOfWords = 0;
    NSMutableArray *largestClasses = nil;
    NSArray *class;
    
    for (NSString *key in self.classes) {
        class = [self.classes objectForKey:key];
        if ([class count] > largestNumberOfWords) {
            largestNumberOfWords = [class count];
            largestClasses = [NSMutableArray arrayWithObject:key];
        } else if ([class count] == largestNumberOfWords) {
            [largestClasses addObject:key];
        }
    }
    
    
    NSString *largestClass;
    
    // now select class 0 if tie and present
    if ([largestClasses count] > 1) {
        NSLog(@"Tie!");
        
        // 0 is present
        if([largestClasses indexOfObject:@"0-"] != NSNotFound) {
            largestClass = @"0-";
        }
        // else pick random majority class
        else {
            NSUInteger index = arc4random() % [largestClasses count];
            largestClass = [largestClasses objectAtIndex:index];
        }
    }
    // else just convert the class to NSUInteger
    else {
        largestClass = [largestClasses objectAtIndex:0];
    }
    
    NSDictionary *result = @{
        @"largestClass": largestClass,
        @"newWords": [self.classes objectForKey:largestClass]
    };
    
    // IMPORTANT: resets classes dictionary
    self.classes = [NSMutableDictionary new];
    
    return result;
}

@end
