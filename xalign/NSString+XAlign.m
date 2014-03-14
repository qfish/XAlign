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
		
		if ( partial.length )
		{
			/*
			 i: 0 1 2 3 4 5 6 7 8 9 10
                ----- --- --- --- ----
			 p:   0    1   2   3   4
			 */
			
			NSUInteger pIndex = i == 0 ? 0 : ( ( i + 1 ) / 2 - 1 );
			
			XAlignPattern * pattern = patterns[pIndex];
			
			// build string
			
			if ( 0 == i )
			{
				if ( XAlignPaddingModeNone == pattern.headMode )
					tempString = partial;
				else
					tempString = [partial stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
			}
			else
			{
				switch ( i % 2 )
				{
					case 0: // tail
						if ( XAlignPaddingModeNone == pattern.tailMode )
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
	
	return string.xtrimTail;
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

- (NSString *)xtrimTail
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
		NSString * trimLine = line.xtrimTail;
		
		XAlignLine * xline = nil;

		[trimLine processLine:&xline level:(int)(patterns.count - 1) patterns:patterns paddings:paddings];
		
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

- (void)processLine:(XAlignLine **)line level:(int)level patterns:(NSArray *)patterns paddings:(NSMutableArray *)paddings
{
	if ( level < 0 )
		return;
	
	XAlignPattern * pattern = patterns[level];
	
	NSString * match = nil;
	NSArray * components = [self componentsSeparatedByRegexPattern:pattern.string position:pattern.position match:&match];

	if ( !match )
	{
		if ( !pattern.isOptional )
		{
			*line = nil;
			return;
		}
		else
		{
			components = @[ self, @"" ];
			match = @"";
		}
	}
	
	if ( nil == *line )
		*line = [XAlignLine line];
	
	XAlignLine * xline = *line;
	
	NSString * head = [components firstObject];
	NSString * tail = [components  lastObject];
	
	[head processLine:line level:(level-1) patterns:patterns paddings:paddings];
	
____STEP_IIN( head )
	if ( 0 == level && head )
	{
		// add head partial
		[xline.partials addObject:head];
		// get index for match padding
		NSInteger headIndex      = level;
		NSInteger headPadding    = [paddings[headIndex] integerValue];
		NSInteger newMatchPadding = head.xlength;
		switch ( pattern.headMode )
		{
			case XAlignPaddingModeMin:
			{
				headPadding = headPadding == -1 ? NSNotFound : headPadding;
				paddings[headIndex] = @( MIN( headPadding , newMatchPadding ) );
			}
				break;
			case XAlignPaddingModeMax:
			{
				headPadding = headPadding == -1 ? -1 : headPadding;
				paddings[headIndex] = @( MAX( headPadding , newMatchPadding ) );
			}
				break;
			default:
				paddings[headIndex] = @( newMatchPadding );
				break;
		}
	}
____STEP_OUT( head )
	
____STEP_IIN( match )
	// add match partial
	[xline.partials addObject:match];
	// get index for match padding
    NSInteger matchIndex      = level * 2 + 1;
    NSInteger matchPadding    = [paddings[matchIndex] integerValue];
    NSInteger newMatchPadding = match.xlength;
	switch ( pattern.matchMode )
	{
		case XAlignPaddingModeMin:
		{
			matchPadding = matchPadding == -1 ? NSNotFound : matchPadding;
			paddings[matchIndex] = @( MIN( matchPadding , newMatchPadding ) );
		}
			break;
		case XAlignPaddingModeMax:
		{
			matchPadding = matchPadding == -1 ? -1 : matchPadding;
			paddings[matchIndex] = @( MAX( matchPadding , newMatchPadding ) );
		}
			break;
		default:
			paddings[matchIndex] = @( newMatchPadding );
			break;
	}
____STEP_OUT( match )
	
____STEP_IIN( tail )
	// add tail partial
	[xline.partials addObject:tail];
	// get index for match padding
	NSInteger tailIndex = level * 2 + 2;
	NSInteger tailPadding = [paddings[tailIndex] integerValue];
	NSInteger newTailPadding = tail.xlength;
	switch ( pattern.tailMode )
	{
		case XAlignPaddingModeMin:
		{
			tailPadding = tailPadding == -1 ? NSNotFound : tailPadding;
			paddings[tailIndex] = @( MIN( tailPadding , newTailPadding ) );
		}
			break;
		case XAlignPaddingModeMax:
		{
			tailPadding = tailPadding == -1 ? -1 : tailPadding;
			paddings[tailIndex] = @( MAX( tailPadding , newTailPadding ) );
		}
			break;
		default:
			paddings[tailIndex] = @( newTailPadding );
			break;
	}
	
____STEP_OUT( tail )
	
	//	NSLog( @"%d| head:%d| match:%d| tail:%d", level, level+1, level+2, level+3 );
	//	NSLog( @"\n  level:%d %@\n   head:%@\n   tail:%@\nmatch:%@", level, pattern, head, tail, match );
}

- (NSArray *)componentsSeparatedByRegexPattern:(NSString *)pattern position:(XAlignPosition)position match:(NSString **)match
{
	NSError * error = nil;
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
	
	if ( error )
	{
		NSLog( @"[NSString+XAlign](%s): pattern is illegal. error: %@", __PRETTY_FUNCTION__, error );
		return nil;
	}

	NSArray * matches = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
	
	if ( 0 == matches.count )
		return nil;
	
	NSTextCheckingResult * matchResult = nil;
	
//	for ( matchResult in matches )
//	{
//		NSLog( @"|||%@|||", [self substringWithRange:NSMakeRange(0, NSMaxRange([matchResult range]))]);
//	}
		
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
