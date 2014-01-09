//
//  XAlignPattern.h
//  main
//
//  Created by QFish on 11/30/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "blade.h"

typedef enum XAlignPosition{
    XAlignPositionFisrt = -1,
	XAlignPositionLast,
} XAlignPosition;

typedef enum XAlignPaddingMode {
	XAlignPaddingModeNone = 0,
	XAlignPaddingModeMin,
	XAlignPaddingModeMax,
} XAlignPaddingMode;

typedef NSString * (^XAlignPatternControlBlockU)(NSUInteger padding);
typedef NSString * (^XAlignPatternControlBlockUS)(NSUInteger padding, NSString * match);

@interface XAlignPattern : NSObject
@property (nonatomic, assign) BOOL isOptional;
@property (nonatomic, retain) NSString * string;
@property (nonatomic, assign) XAlignPosition position;
@property (nonatomic, assign) XAlignPaddingMode headMode;
@property (nonatomic, assign) XAlignPaddingMode matchMode;
@property (nonatomic, assign) XAlignPaddingMode tailMode;
@property (nonatomic, copy)   XAlignPatternControlBlockUS control;
@end

@interface XAlignPatternManager : NSObject

AS_SINGLETON( XAlignPatternManager );

@property (nonatomic, strong) NSMutableDictionary * specifiers;

+ (void)setupWithRawArray:(NSArray *)array;

+ (NSArray *)patternGroupsWithRawArray:(NSArray *)array;
+ (NSArray *)patternGroupsWithContentsOfFile:(NSString *)fileName;

+ (NSArray *)patternGroupMatchedWithString:(NSString *)string;
+ (NSArray *)patternGroupWithDictinary:(NSDictionary *)dictionary;

@end