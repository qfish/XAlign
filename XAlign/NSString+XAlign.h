//
//  NSString+XAlign2.h
//  main
//
//  Created by QFish on 11/18/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#ifdef __XALIGN__
#import "SharedXcode.h"
#define kTabSize [SharedXcode tabWidth]
#else
#define kTabSize 4
#endif

#import "XAlignPattern.h"

@interface NSString (XAlign)
- (NSString *)xtrim;
- (NSString *)xtrimTail;
- (NSUInteger)xlength;
- (NSString *)stringByAligningWithPatterns:(NSArray *)patterns;
- (NSString *)stringByAligningWithPatterns:(NSArray *)patterns partialCount:(NSUInteger)count;
- (NSArray *)componentsSeparatedByRegexPattern:(NSString *)pattern position:(XAlignPosition)position match:(NSString **)match;
@end
