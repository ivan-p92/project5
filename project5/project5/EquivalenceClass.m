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
    
    // Initialize empty dictionary
    self.classes = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)addWordToClass:(NSString *)word forLetter:(NSString *)letter
{
    // Get the equivalenceClass for the given word and letter.
    NSString *equivalenceClass = [self equivalenceClassForWord:word andLetter:letter];
    
    NSMutableArray *class = nil;
    
    // Add word to dictionary for this class
    class = [self.classes objectForKey:equivalenceClass];
    
    // If their are no words yet for this class, create a key-object pair for the class
    if (class == nil) {
        class = [NSMutableArray arrayWithObject:word];
        [self.classes setObject:class forKey:equivalenceClass];
    }
    // If the class already exists, simply add the word to it
    else {
        [class addObject:word];
    }

}


- (NSString *)equivalenceClassForWord:(NSString *)word andLetter:(NSString *)letter
{
    // Assume letter doesn't appear in word.
    BOOL letterFound = NO;
    
    NSMutableString *equivalenceClass = [NSMutableString new];
    NSUInteger wordLength = [word length];
    NSRange searchRange = NSMakeRange(0, wordLength);
    NSRange matchRange;
    
    // Get range of occurence and continue until all occurences have been found
    do {
        matchRange = [word rangeOfString:letter options:0 range:searchRange];
        
        // If the letter is found, append location to |equivalenceClass|
        // and update the searchRange to search from the latest match to the
        // end of the word.
        if (matchRange.location != NSNotFound) {
            letterFound = YES;
            
            [equivalenceClass appendString:[NSString stringWithFormat:@"%ld-", (unsigned long)matchRange.location + 1]];
            
            // If the matched letter is the last letter of the word, stop the search.
            if (matchRange.location == wordLength - 1) {
                break;
            }
            // If not, update |searchRange| to look for next match.
            else {
                searchRange = NSMakeRange(matchRange.location + 1, wordLength - (matchRange.location + 1));
            }
        }
    } while (matchRange.location != NSNotFound);
    
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
        // Get the array of words for given class
        class = [self.classes objectForKey:key];
        
        // If the number of words is larger than the current largest
        // number of words, initialize |largestClassess| to array
        // with only the new equivalence class.
        if ([class count] > largestNumberOfWords) {
            largestNumberOfWords = [class count];
            largestClasses = [NSMutableArray arrayWithObject:key];
        }
        // If the number of words is equal to the current largest
        // number of words, the equivalence class is added to the
        // |largestClasses| array.
        else if ([class count] == largestNumberOfWords) {
            [largestClasses addObject:key];
        }
    }
    
    
    NSString *largestClass;
    
    // If there is a tie and class 0- is among the largest classes,
    // it is selected. If not, a random class is selected among the
    // largest classes.
    if ([largestClasses count] > 1) {
        if([largestClasses indexOfObject:@"0-"] != NSNotFound) {
            largestClass = @"0-";
        }
        else {
            NSUInteger index = arc4random() % [largestClasses count];
            largestClass = [largestClasses objectAtIndex:index];
        }
    }
    // If there isn't a tie, just pick the equivalence class.
    else {
        largestClass = [largestClasses objectAtIndex:0];
    }
    
    // Dictionary that will be returned contains string representation
    // of best equivalence class along with array of all words belonging
    // to that class.
    NSDictionary *result = @{
        @"largestClass": largestClass,
        @"newWords": [self.classes objectForKey:largestClass]
    };
    
    // IMPORTANT: resets classes dictionary
    self.classes = [[NSMutableDictionary alloc] init];
    
    return result;
}

@end
