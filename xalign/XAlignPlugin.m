//
//  XAlign.m
//  XAlign
//
//  Created by QFish on 11/16/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//
#import "XAlignPlugin.h"

#import "SharedXcode.h"
#import "NSString+XAlign.h"
#import "XAlignPluginConfig.h"

#ifdef	XDEBUG
#define XAlignLog( s ) NSLog( @"[XAlign]:%@", (s) );
#else
#define XAlignLog( s )
#endif

@interface XAlignPlugin()

@property (nonatomic, strong) NSString * selection;
@property (nonatomic, assign) NSRange selectedRange;
@end

static XAlignPlugin * __sharedPlugin = nil;

@implementation XAlignPlugin

DEF_SINGLETON( XAlignPlugin );

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    __sharedPlugin = [XAlignPlugin sharedInstance];
	__sharedPlugin.bundle = plugin;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(applicationDidFinishLaunching:)
         name:NSApplicationDidFinishLaunchingNotification
         object:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [XAlignPluginConfig setupMenu];
    [XAlignPluginConfig setupPatternManger];
}

#pragma mark - actions

- (void)updateSelection
{
    NSTextView * textView = [SharedXcode textView];
    
    if ( textView )
    {
        NSArray * selectedRanges = [textView selectedRanges];
        
        if ( selectedRanges.count == 0 )
            return;
        
        NSString * cacheText = textView.textStorage.string;
		
        self.selectedRange = [SharedXcode charaterRangeFromSelectedRange:[[selectedRanges objectAtIndex:0] rangeValue]];
        
		IDESourceCodeDocument * document = [SharedXcode sourceCodeDocument];
		if ( !document )
			return;
		
        if ( !self.selectedRange.length )
        {
            XAlignLog(@"has textview, no selecton");
            self.selection = nil;
            return;
        }
        
        self.selection = [cacheText substringWithRange:self.selectedRange];
        XAlignLog(@"has selection");
    }
    else
    {
        XAlignLog(@"no textview");
        self.selection     = nil;
        self.selectedRange = NSMakeRange(0, 0);
    }
}

- (void)autoAlign
{
    [self updateSelection];
	
	if ( !self.selection )
		return;
	
	NSArray * patternGroup = [XAlignPatternManager patternGroupMatchWithString:self.selection];
	
	if ( !patternGroup )
		return;
	
    NSString * replace = [self.selection stringByAligningWithPatterns:patternGroup];
	
    if ( replace )
    {
        [SharedXcode replaceCharactersInRange:self.selectedRange withString:replace];
    }
	
}

- (void)align:(NSMenuItem *)sender
{
    [self updateSelection];
	
	if ( !self.selection )
		return;
		
	NSArray * patternGroup = [XAlignPatternManager patternGroupWithDictinary:sender.representedObject];
	
	if ( !patternGroup )
		return;
	
    NSString * replace = [self.selection stringByAligningWithPatterns:patternGroup];
	
    if ( replace )
    {
        [SharedXcode replaceCharactersInRange:self.selectedRange withString:replace];
    }
}

- (void)showSetting:(id)sender
{
	if ( nil == self.settingWindow )
	{
		self.settingWindow = [[SettingWindowController alloc] initWithWindowNibName:@"SettingWindowController"];
	}
	
	[self.settingWindow showWindow:self.settingWindow];
}

@end
