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
	[self testEqualSign];
//	[self test2];
//	[self test3];
//	[self test4];
//	[self test5];
	
	NSArray * pgs = [XAlignPatternManager patternGroupsWithContentsOfFile:@"patterns"];
	NSString * replace = [[self testFile:@"equalSign.txt"] stringByAligningWithPatterns:pgs[0]];

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

- (void)testEqualSign
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*";
    p1.matchMode = XAlignPaddingModeMin;
    p1.tailMode  = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [@"" stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.position = XAlignPositionFisrt;
	p2.string = @"\\s*(?<=[\\w\\s])[\\|\\+\\-\\*]?=(?=[\\w\\s])\\s*"; // just '=', exclude sth like '==' etc.
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" = ";
	};
	
	XAlignPattern * p3 = [[XAlignPattern alloc] init];
	p3.isOptional = YES;
	p3.string = @"\\s*//.*$";
	p3.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	XAlignPattern * p4 = [[XAlignPattern alloc] init];
	p4.isOptional = YES;
	p4.string = @"\\s*/\\*.*$";
	p4.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	NSArray * patterns = @[p1, p2, p3, p4];
	
	NSString * replace = [[self testFile:@"equalSign.txt"] stringByAligningWithPatterns:patterns];
    NSLog( @"\n%@", replace );
}

- (void)test2
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*";
	p1.tailMode = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"";
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.string = @"\\s+";
	p2.tailMode = XAlignPaddingModeMax;
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	XAlignPattern * p3 = [[XAlignPattern alloc] init];
	p3.isOptional = YES;
	p3.string = @"\\s*//.*$";
	p3.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	XAlignPattern * p4 = [[XAlignPattern alloc] init];
	p4.isOptional = YES;
	p4.string = @"\\s*/\\*.*$";
	p4.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	NSArray * patterns = @[p1, p2, p3, p4];
	
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
	XAlignPattern * p0 = [[XAlignPattern alloc] init];
    p0.string    = @"^\\s*@property\\s*";
	p0.tailMode = XAlignPaddingModeMax;
    p0.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"@property ";
	};
	
//	XAlignPattern * p1 = [[XAlignPattern alloc] init];
//    p1.string    = @"\\(.*\\)";
//	p1.matchMode  = XAlignPaddingModeMax;
//    p1.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
//		return match.xtrim;
//	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.string   = @"(?<=\\))\\s*(?=\\w)";
	p2.tailMode = XAlignPaddingModeMax;
    p2.control  = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	XAlignPattern * p3 = [[XAlignPattern alloc] init];
	p3.isOptional = YES;
    p3.string    = @"\\s+\\*";
    p3.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" *";
	};

	XAlignPattern * p4_1 = [[XAlignPattern alloc] init];
	p4_1.isOptional = YES;
    p4_1.string     = @"(?<!\\*)\\s*\\w+;";
    p4_1.control    = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@"   %@", match.xtrim];
	};

	XAlignPattern * p4_2 = [[XAlignPattern alloc] init];
	p4_2.isOptional = YES;
    p4_2.string     = @"(?<=\\*)\\s*\\w+;";
    p4_2.control    = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};

	XAlignPattern * p5 = [[XAlignPattern alloc] init];
	p5.isOptional = YES;
	p5.string = @"\\s*//.*$";
	p5.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	XAlignPattern * p6 = [[XAlignPattern alloc] init];
	p6.isOptional = YES;
	p6.string = @"\\s*/\\*.*$";
	p6.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	NSArray * patterns = @[p0, p2, p3, p4_1, p4_2, p5, p6];
	
	NSString * replace = [[self testFile:@"4.txt"] stringByAligningWithPatterns:patterns];
	
    NSLog( @"\n%@", replace );
}

@end
