//
//  AppDelegate.m
//  main
//
//  Created by QFish on 11/17/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+XAlign.h"
#import <CoreText/CoreText.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	[self test1];
//	[self test2];
//	[self test3];
//	[self test4];
//	[self test5];
	
	NSArray * pgs = [XAlignPatternManager patternGroupsWithContentsOfFile:@"patterns"];
	NSString * replace = [[self testFile:@"4.txt"] stringByAligningWithPatterns:pgs[2]];

    NSLog( @"\n%@", replace );
	
}

- (IBAction)format:(id)sender
{
//	NSString * input = self.input.string;
//	NSString * output = nil;
//	self.output.string = output;
}

- (IBAction)selectFormatter:(id)sender
{
	
}

- (void)showSettingWindow
{
	[self.settingWindow showWindow:self.settingWindow];
}

- (NSString *)testFile:(NSString *)name
{
	NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSString * string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	return string;
}

- (void)test1
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*";
    p1.matchMode = XAlignPaddingModeMin;
    p1.tailMode  = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [@"" stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.string = @"\\s*(?<=[\\w\\s])=(?=[\\w\\s])\\s*"; // just '=', exclude sth like '==' etc.
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" = ";
	};
	
	NSArray * patterns = @[p1, p2];
	
	NSString * replace = [[self testFile:@"1.txt"] stringByAligningWithPatterns:patterns];
    NSLog( @"\n%@", replace );
}

- (void)test2
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*#define\\s+";
	p1.tailMode = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"#define ";
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.string = @"(?<!#define\\*)\\s+(?![\\*/])";
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	NSArray * patterns = @[p1, p2];
	
	NSString * replace = [[self testFile:@"2.txt"] stringByAligningWithPatterns:patterns];
	
    NSLog( @"\n%@", replace );
}

- (void)test3
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*";
	p1.tailMode = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"\t";
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.string    = @"[\\s\\*]+";
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		if ( NSNotFound == [match rangeOfString:@"*"].location )
			return [NSString stringWithFormat:@" %@", match.xtrim];
		return [NSString stringWithFormat:@" %@ ", match.xtrim];
	};
	
	NSArray * patterns = @[p1, p2];
	
	NSString * replace = [[self testFile:@"3.txt"] stringByAligningWithPatterns:patterns];
		
    NSLog( @"\n%@", replace );
}

- (void)test4
{
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.string    = @"\\s*\\w+";
	p2.headMode = XAlignPaddingModeMax;
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return match.xtrim;
	};
	
	NSArray * patterns = @[p2];
	
	NSString * replace = [[self testFile:@"3.txt"] stringByAligningWithPatterns:patterns];
	
    NSLog( @"\n%@", replace );
}

- (void)test5
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"[\\s\\*]*\\w+";
    p1.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		if ( NSNotFound == [match rangeOfString:@"*"].location )
			return [NSString stringWithFormat:@"  %@", match.xtrim];
		return match.xtrim;
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.string   = @"(?<=\\w)\\s*";
    p2.matchMode = XAlignPaddingModeMax;
    p2.control  = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	XAlignPattern * p3 = [[XAlignPattern alloc] init];
    p3.string    = @"(?<=\\))\\s*(?=\\w)";
	p3.tailMode = XAlignPaddingModeMax;
    p3.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	XAlignPattern * p4 = [[XAlignPattern alloc] init];
    p4.string    = @"^\\s*@property\\s*";
	p4.tailMode = XAlignPaddingModeMax;
    p4.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"@property ";
	};
	
	NSArray * patterns = @[p4, p3, p2, p1];
	
	NSString * replace = [[self testFile:@"4.txt"] stringByAligningWithPatterns:patterns];
	
    NSLog( @"\n%@", replace );
}

@end
