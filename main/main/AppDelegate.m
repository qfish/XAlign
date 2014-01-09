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

static XAlignPattern * kPatternSpace   = nil;
static XAlignPattern * kPatternComment = nil;

@implementation AppDelegate

+ (void)initialize
{
	kPatternSpace = [[XAlignPattern alloc] init];
	kPatternSpace.position = XAlignPositionFisrt;
	kPatternSpace.string = @"\\s+";
	kPatternSpace.isOptional = YES;
	kPatternSpace.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" ";
	};
	
	kPatternComment = [[XAlignPattern alloc] init];
    kPatternComment.headMode   = XAlignPaddingModeMax;
    kPatternComment.isOptional = YES;
    kPatternComment.string     = @"[(\\s* //)(\\s*/\\*)].*$";
    kPatternComment.control    = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	[self testEqualSign];
	[self testEqualSign2];
//	[self testPatterns:0 file:@"EqualSign.txt"];
	
	[self testDefine2];
//	[self testPatterns:1 file:@"Define.txt"];

//	[self testProperty];
	[self testProperty2];
//	[self testPatterns:2 file:@"Property.txt"];

//	[self testVariable];
//	[self testPatterns:3 file:@"Variable.txt"];
	
//	[self testDictionary];
//	[self testPatterns:4 file:@"Dictionary.txt"];
	
//	NSString * cmd = [NSString stringWithFormat:@"open %@", [[NSBundle mainBundle] pathForResource:@"patterns.plist" ofType:nil]];
//	
//	system( cmd.UTF8String );
}

#pragma mark -

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


#pragma mark - patterns tests

- (void)testPatterns:(NSUInteger)index file:(NSString *)file
{
	NSArray * pgs = [XAlignPatternManager patternGroupsWithContentsOfFile:@"patterns"];
	NSString * replace = [[self testFile:file] stringByAligningWithPatterns:pgs[index]];
    NSLog( @"\n%@", replace );
}

#pragma mark - method tests

- (void)testEqualSign2
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*(?!/)";
    p1.matchMode = XAlignPaddingModeMin;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [@"" stringByPaddingToLength:padding withString:@" " startingAtIndex:0];
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.headMode = XAlignPaddingModeMax;
	p2.tailMode = XAlignPaddingModeMax;
	p2.position = XAlignPositionFisrt;
	p2.string = @"\\s*(?<=[\\w\\s])[\\|\\+\\-\\*]?=(?=[\\w\\s])\\s*"; // just '=', exclude sth like '==' etc.
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @" = ";
	};
	
	XAlignPattern * pComment = [[XAlignPattern alloc] init];
    pComment.headMode = XAlignPaddingModeMax;
    pComment.tailMode = XAlignPaddingModeMax;
    pComment.isOptional = YES;
    pComment.string     = @"\\s*[(//)(/\\*)].*$";
    pComment.control    = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	NSArray * patterns = @[p1, p2, pComment];
	NSString * replace = [[self testFile:@"EqualSign.txt"] stringByAligningWithPatterns:patterns];
	NSLog( @"\n%@", replace );
}

- (void)testDefine2
{
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.string    = @"^\\s*[#\\w]+";
    p1.matchMode = XAlignPaddingModeMax;
	p1.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		NSString * result = [match.xtrim stringByPaddingToLength:padding withString:@"=" startingAtIndex:0];
		return [NSString stringWithFormat:@"<%@>", result];
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
	p2.matchMode = XAlignPaddingModeMax;
	p2.position = XAlignPositionFisrt;
	p2.string = @"\\w+";
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		NSString * result = [match.xtrim stringByPaddingToLength:padding withString:@"=" startingAtIndex:0];
		return [NSString stringWithFormat:@"<%@>", result];
	};
	
	XAlignPattern * p3 = [[XAlignPattern alloc] init];
	p3.matchMode = XAlignPaddingModeMax;
	p3.position = XAlignPositionFisrt;
	p3.isOptional = YES;
	p3.string = @".*";
	p3.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		NSString * result = [match.xtrim stringByPaddingToLength:padding withString:@"=" startingAtIndex:0];
		return [NSString stringWithFormat:@"<%@>", result];
	};
	
	NSArray * patterns = @[p1, kPatternSpace, p2, kPatternSpace, p3, kPatternComment];
	NSString * replace = [[self testFile:@"Define.txt"] stringByAligningWithPatterns:patterns];
	NSLog( @"\n%@", replace );
	
}

- (void)testProperty2
{
	XAlignPattern * p0 = [[XAlignPattern alloc] init];
    p0.string   = @"^\\s*@property\\s*";
    p0.control  = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return @"@property ";
	};
	
	XAlignPattern * p1 = [[XAlignPattern alloc] init];
    p1.matchMode = XAlignPaddingModeMax;
    p1.string   = @"\\(.*\\)\\s*";
    p1.control  = ^ NSString * ( NSUInteger padding, NSString * match ) {
		NSString * result = [match.xtrim stringByPaddingToLength:padding withString:@"=" startingAtIndex:0];
		return [NSString stringWithFormat:@"%@ ", result];
	};
	
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.headMode = XAlignPaddingModeMax;
    p2.string    = @"[\\s\\*]+(?=\\w+;)";
    p2.control   = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	XAlignPattern * pComment = [[XAlignPattern alloc] init];
    pComment.headMode   = XAlignPaddingModeMax;
    pComment.isOptional = YES;
    pComment.string     = @"[(\\s* //)(\\s*/\\*)].*$";
    pComment.control    = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return [NSString stringWithFormat:@" %@", match.xtrim];
	};
	
	NSArray * patterns = @[p0, p1, p2, pComment];
	NSString * replace = [[self testFile:@"Property.txt"] stringByAligningWithPatterns:patterns];
	NSLog( @"\n%@", replace );
}

- (void)testVariable
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
	
	NSString * replace = [[self testFile:@"Variable.txt"] stringByAligningWithPatterns:patterns];
		
    NSLog( @"\n%@", replace );
}

- (void)testDictionary
{
	XAlignPattern * p2 = [[XAlignPattern alloc] init];
    p2.string    = @"\\s*\\w+";
	p2.headMode = XAlignPaddingModeMax;
	p2.control = ^ NSString * ( NSUInteger padding, NSString * match ) {
		return match.xtrim;
	};
	
	NSArray * patterns = @[p2];
	
	NSString * replace = [[self testFile:@"Dictionary.txt"] stringByAligningWithPatterns:patterns];
	
    NSLog( @"\n%@", replace );
}

@end
