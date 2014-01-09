//
//  NSString+XAlign2.m
//  main
//
//  Created by QFish on 11/18/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import "NSString+XAlign.h"

#undef	____STEP_IIN
#define ____STEP_IIN(s)
#undef  ____STEP_OUT
#define ____STEP_OUT(s)

@interface XAlignLine : NSObject
@property (nonatomic, retain) NSMutableArray * partials;
+ (id)line;
- (NSString *)stringWithPaddings:(NSArray *)paddings patterns:(NSArray *)patterns;
@end

@implementation XAlignLine

+ (id)line
{
	return [[self alloc] init];
}

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		self.partials = [NSMutableArray array];
	}
	
	return self;
}

- (void)setupWithCount:(NSUInteger)count
{
	for ( int i=0; i<count; i++ )
	{
		[self.partials addObject:@""];
	}
}

- (int)sumOfPaddings:(NSArray *)paddings atRange:(NSRange)range
{
	int sum = 0;
	
	if ( NSMaxRange(range) > paddings.count )
		return 0;
	
	for ( NSUInteger i=range.location, j=1; j<=range.length; j++, i++)
	{
		sum += [paddings[i] intValue];
	}
	
	return sum;
}

- (NSString *)stringWithPaddings:(NSArray *)paddings patterns:(NSArray *)patterns
{
	NSMutableString * string = [NSMutableString string];
	
	for ( int i=0; i < self.partials.count; i++ )
	{
		NSString * partial = self.partials[i];
		NSUInteger padding = [paddings[i] integerValue];
		NSString * tempString = nil;
		
		if ( partial.length && -1 != padding )
		{
			/*
			 i: 0 1 2 3 4 5 6 7 8 9 10
			 -- --- --- --- --- ------
			 p:  0   1   2   3    4
			 */
			
			NSUInteger pIndex = 0;
			
			if ( i == self.partials.count - 1 )
			{
				pIndex = patterns.count - 1;
			}
			else
			{
				pIndex = i / 2;
			}
			
			XAlignPattern * pattern = patterns[pIndex];
			
			// build string
			// tail
			if ( i == self.partials.count )
			{
				if ( XAlignPaddingModeNone == pattern.tailMode )
					tempString = partial;
				else
					tempString = [partial stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
			}
			else
			{
				switch ( i % 2 )
				{
					case 0: // head
						if ( XAlignPaddingModeNone == pattern.headMode )
							tempString = partial;
						else
							tempString = [partial stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
						break;
					case 1: // match
						tempString = pattern.control(padding, partial);
						break;
				}
			}
		}
		else
		{
			tempString = @"";
		}
		
		[string appendString:tempString];
	}
	
	return string;
}

- (NSString *)description
{
	return [self.partials description];
}
@end

#pragma mark -

@implementation NSString (XAlign)

- (NSString *)xtrim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)xTailTrim
{
	NSError * error = nil;
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+$" options:NSRegularExpressionCaseInsensitive error:&error];
	
	if ( error )
		return self;
	
	NSArray * matches = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
	
	if ( 0 == matches.count )
		return self;
	
	return [self substringWithRange:NSMakeRange(0, [matches[0] range].location)];
}

- (NSUInteger)xlength
{
	return [self lengthWithTabWidth:kTabSize];
}

- (NSUInteger)lengthWithTabWidth:(NSUInteger)tabWidth
{
	const char * c = self.UTF8String;
    
    int count = 0;
    
    while ( *c )
	{
		if ( *c == '\t' )
			count += tabWidth;
		else
			count++;
        c++;
    }
    
    return count;
}

- (NSString *)stringByAligningWithPatterns:(NSArray *)patterns
{
	return [self stringByAligningWithPatterns:patterns partialCount:(patterns.count * 2 + 1)];
}

- (NSString *)stringByAligningWithPatterns:(NSArray *)patterns partialCount:(NSUInteger)partialCount
{
	NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ( lines.count <= 1 )
        return self;
	
	NSMutableArray * paddings     = [NSMutableArray array];
    NSMutableArray * processLines = [NSMutableArray array];
	
	for ( int j=0; j < partialCount; j++ )
	{
		[paddings addObject:@(-1)];
	}
	
	for ( NSString * line in lines )
    {
		NSString * trimLine = line.xTailTrim;
		
		XAlignLine * xline = nil;
		NSString * segment = trimLine;
		
		for ( int pIndex = 0; pIndex < patterns.count; pIndex++ )
		{
			XAlignPattern * pattern = patterns[pIndex];
			
			// separate the string by regex
			NSString * match = nil;
			NSArray * components = [segment componentsSeparatedByRegexPattern:pattern.string position:pattern.position match:&match];
			
			BOOL isMatched  = nil != match;
			BOOL isLastPattern = pIndex == patterns.count - 1;
			// check whether matched
			
			NSString * head = nil;
			NSString * tail = nil;
			
			if ( !isMatched )
			{
				if ( pattern.isOptional )
				{
                    head  = @"";
                    tail  = segment;
                    match = @"";
				}
				else
				{
					xline = nil;
					break;
				}
			}
			else
			{
				head = [components firstObject];
				tail = [components lastObject];
			}
			
			if ( nil == xline )
			{
				xline = [XAlignLine line];
				[xline setupWithCount:partialCount];
			}
			
			NSInteger headIndex  = pIndex * 2;
			NSInteger matchIndex = pIndex * 2 + 1;
			NSInteger tailIndex  = pIndex * 2 + 2;
			
			if ( isMatched )
			{
				____STEP_IIN( head )
				
				if ( head.length )
				{
					[self setPaddingForPartial:head
									   atIndex:headIndex
									ofPaddings:paddings
										  mode:pattern.headMode];
					// set head partial
					xline.partials[headIndex] = head;
				}
				
				____STEP_OUT( head )
				
				____STEP_IIN( match )

				if ( match.length )
				{
					// get index for match padding
					[self setPaddingForPartial:match
									   atIndex:matchIndex
									ofPaddings:paddings
										  mode:pattern.matchMode];
					// set match partial
					xline.partials[matchIndex] = match;
				}
				____STEP_OUT( match )
				
			}
			
			if ( isLastPattern )
			{
				[self setPaddingForPartial:tail
								   atIndex:tailIndex
								ofPaddings:paddings
									  mode:pattern.tailMode];
				
				xline.partials[tailIndex] = tail;
			}
			
			segment = tail; // for next loop
		}
		
		if ( !xline )
		{
			[processLines addObject:trimLine];
		}
		else
		{
			[processLines addObject:xline];
		}
	}
	
	NSMutableString * newLines = [NSMutableString string];
	
	for ( int i=0; i < processLines.count; i++ )
	{
		id line = processLines[i];
		
		if ( [line isKindOfClass:[NSString class]] )
		{
			[newLines appendString:line];
		}
		else if ( [line isKindOfClass:[XAlignLine class]] )
		{
		 	[newLines appendString:[line stringWithPaddings:paddings patterns:patterns]];
		}
		
		if ( i != processLines.count - 1 )
		{
			[newLines appendString:@"\n"];
		}
	}
	
	return newLines;
}

- (void)setPaddingForPartial:(NSString *)partial atIndex:(NSUInteger)index ofPaddings:(NSMutableArray *)paddings mode:(XAlignPaddingMode)mode
{
	NSInteger padding    = [paddings[index] integerValue];
	NSInteger newPadding = partial.xlength;
	switch ( mode )
	{
		case XAlignPaddingModeMin:
		{
			padding = padding == -1 ? NSNotFound : padding;
			paddings[index] = @( MIN( padding , newPadding ) );
		}
			break;
		case XAlignPaddingModeMax:
		{
			padding = padding == -1 ? -1 : padding;
			paddings[index] = @( MAX( padding , newPadding ) );
		}
			break;
		default:
			paddings[index] = @( newPadding );
			break;
	}
}

- (NSArray *)componentsSeparatedByRegexPattern:(NSString *)pattern position:(XAlignPosition)position match:(NSString **)match
{
	NSError * error = nil;
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
	
	if ( error )
	{
		NSLog( @"XAlign: pattern is illegal. error: %@", error );
		return nil;
	}
	
	NSArray * matches = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
	
	if ( 0 == matches.count )
		return nil;
	
	NSTextCheckingResult * matchResult = nil;
		
	switch ( position )
	{
		case XAlignPositionFisrt:
			matchResult = [matches firstObject];
			break;
		case XAlignPositionLast:
			matchResult = [matches lastObject];
			break;
			
		default:
			if ( position >= matches.count )
				matchResult = nil;
			else
				matchResult = matches[position-1];
			break;
	}
	
	if ( nil == match )
		return nil;
	
	*match = [self substringWithRange:[matchResult range]];
	
	NSRange headRange = NSMakeRange( 0, [matchResult range].location );
	NSRange tailRange = NSMakeRange( NSMaxRange([matchResult range]), self.length - NSMaxRange([matchResult range]) );
	
	NSString * head = [self substringWithRange:headRange] ?: @"";
	NSString * tail = [self substringWithRange:tailRange] ?: @"";
	
	return @[ head, tail ];
}

@end
