//
//  XAlignPattern.m
//  main
//
//  Created by QFish on 11/30/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#define kPatterns                          @"patterns"
#define kPatternID                         @"id"
#define kPatternType                       @"type"
#define kPatternHeadMode                   @"headMode"
#define kPatternTailMode                   @"tailMode"
#define kPatternMatchMode                  @"matchMode"
#define kPatternString                     @"string"
#define kPatternControl                    @"control"
#define kPatternControlString              @"string"
#define kPatternControlFoundString         @"foundString"
#define kPatternControlFormat			   @"format"
#define kPatternControlNotFoundFormat      @"notFoundFormat"
#define kPatternControlNeedTrim            @"needTrim"
#define kPatternControlNeedFormat          @"needFormat"
#define kPatternControlNeedFormatWhenFound @"needFormatWhenFound"
#define kPatternControlNeedPadding         @"needPadding"
#define kPatternControlPaddingString       @"paddingString"
#define kPatternControlIsMatchPadding      @"isMatchPadding"

#import "XAlignPattern.h"
#import "NSString+XAlign.h"

@implementation XAlignPadding

+ (NSString *)stringWithFormat:(NSString *)format
{
	// {padding * @" "}
	// {match.trim}
	// {match}
	// @" %@", {match}
	// 
	
	return nil;
}

@end

#pragma mark -

@implementation XAlignPattern

- (id)init
{
    self = [super init];
    if (self) {
		self.position = XAlignPositionLast;
    }
    return self;
}

- (NSString *)description
{
	return self.string;
}

@end

@interface XAlignPatternManager()
@property (nonatomic, strong) NSMutableDictionary * cache;
@end

@implementation XAlignPatternManager

DEF_SINGLETON( XAlignPatternManager );

- (id)init
{
    self = [super init];
    if (self) {
        self.cache = [NSMutableDictionary dictionary];
		self.specifiers = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - setup

+ (void)setupWithRawArray:(NSArray *)array
{
	[self setupSpecifiersWithRawArray:array];
}

#pragma mark - spectifier

+ (NSArray *)setupSpecifiersWithRawArray:(NSArray *)array
{
	if ( !array )
		return nil;
	
	for ( NSDictionary * item in array )
	{
		NSString * spec = item[@"specifier"];
		
		if ( spec )
		{
			[XAlignPatternManager sharedInstance].specifiers[spec] = item;
		}
	}
	
	return nil;
}

+ (NSDictionary *)rawPatternWithString:(NSString *)string
{
	NSDictionary * specifiers = [XAlignPatternManager sharedInstance].specifiers;
	
	for ( NSString * spec in specifiers.allKeys )
	{
		if ( NSNotFound != [string rangeOfString:spec].location )
		{
			return specifiers[spec];
		}
	}
	
	return nil;
}

+ (NSArray *)patternGroupMatchWithString:(NSString *)string
{
	NSDictionary * dict = [self rawPatternWithString:string];
	return [self patternGroupWithDictinary:dict];
}

#pragma mark - patternGroup

+ (NSArray *)patternGroupsWithContentsOfFile:(NSString *)name
{
	NSString * filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
	NSArray * rawArray = [NSArray arrayWithContentsOfFile:filePath];
    return [self patternGroupsWithRawArray:rawArray];
}

+ (NSArray *)patternGroupsWithRawArray:(NSArray *)array
{
	if ( !array )
		return nil;
	
	NSMutableArray * patternGroups = [NSMutableArray array];
	
	for ( NSDictionary * dict in array )
	{
		NSArray * patternGroup = [self patternGroupWithDictinary:dict];
		
		if ( patternGroup )
		{
			[patternGroups addObject:patternGroup];
		}
	}
	
	return patternGroups;
}

+ (NSArray *)patternGroupWithDictinary:(NSDictionary *)dictionary
{
	NSNumber * key = dictionary[kPatternID];
	
	if ( !key )
		return nil;
	
	NSMutableArray * patternGroup = [XAlignPatternManager sharedInstance].cache[key];
	
	if ( nil == patternGroup )
	{
		patternGroup = [NSMutableArray array];
		
		for ( NSDictionary * pattern in dictionary[kPatterns] )
		{
			NSString * string           = pattern[kPatternString];
			
			XAlignPaddingMode headMode  = [pattern[kPatternHeadMode] intValue];
			XAlignPaddingMode matchMode = [pattern[kPatternMatchMode] intValue];
			XAlignPaddingMode tailMode  = [pattern[kPatternTailMode] intValue];
			
            NSDictionary * control    = pattern[kPatternControl];
            BOOL needTrim             = [control[kPatternControlNeedTrim] boolValue];
            BOOL needFormat           = [control[kPatternControlNeedFormat] boolValue];
            BOOL needFormatWhenFound  = [control[kPatternControlNeedFormatWhenFound] boolValue];
            BOOL needPadding          = [control[kPatternControlNeedPadding] boolValue];
            BOOL isMatchPadding       = [control[kPatternControlIsMatchPadding] boolValue];
            NSString * controlString  = control[kPatternControlString];
            NSString * paddingString  = control[kPatternControlPaddingString];
            NSString * foundString    = control[kPatternControlFoundString];
            NSString * format		  = control[kPatternControlFormat];
            NSString * notFoundFormat = control[kPatternControlNotFoundFormat];

			XAlignPattern * p = [[XAlignPattern alloc] init];
			
			p.string    = string;
			p.headMode  = headMode;
			p.matchMode = matchMode;
			p.tailMode  = tailMode;
			p.control   = ^ NSString * ( NSUInteger padding, NSString * match )
			{
				if ( needFormat || needPadding || needFormatWhenFound )
				{
					NSString * result = match;
					
					if ( needTrim )
						result = result.xtrim;

					if ( needFormatWhenFound )
					{
						if ( NSNotFound == [match rangeOfString:foundString].location )
						{
							if ( notFoundFormat )
								result = [NSString stringWithFormat:notFoundFormat, result];
						}
						else
						{
							if ( format )
								result = [NSString stringWithFormat:format, result];
						}
					}
					else if ( needFormat )
					{
						result = [NSString stringWithFormat:format, result];
					}
					
					if ( needPadding )
					{
						if ( isMatchPadding ) {
							result = [result stringByPaddingToLength:padding withString:paddingString startingAtIndex:0];
						} else {
							result = [controlString stringByPaddingToLength:padding withString:paddingString startingAtIndex:0];
						}
					}
					
					return result;
				}

				return controlString;
			};
			
			[patternGroup addObject:p];
		}
		
		[XAlignPatternManager sharedInstance].cache[key] = patternGroup;
	}
	
	return patternGroup;
}

@end
