//
//  XAlignPluginConfig.m
//  XAlign
//
//  Created by QFish on 12/1/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#define kPatternFile              @"patterns"
#define kPatternTitle             @"title"
#define kPatternShortcut          @"shortcut"
#define kPatternShortcutKey       @"key"
#define kPatternShortcutMask      @"mask"
#define kPatternShortcutMaskCmd   @"cmd"
#define kPatternShortcutMaskCtrl  @"ctrl"
#define kPatternShortcutMaskShift @"shift"

#import "XAlignPlugin.h"
#import "XAlignPattern.h"
#import "XAlignPluginConfig.h"

@implementation XAlignPluginConfig

+ (NSArray *)items
{
	NSString * filePath = [[XAlignPlugin sharedInstance].bundle pathForResource:kPatternFile ofType:@"plist"];
	return [NSArray arrayWithContentsOfFile:filePath];
}

+ (void)setupMenu
{
    NSMenuItem * editMenuItem   = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    NSMenuItem * formatMenuItem = [[editMenuItem submenu] itemWithTitle:@"Format"];
    NSMenuItem * alignMenuItem  = [[NSMenuItem alloc] initWithTitle:@"XAlign" action:nil keyEquivalent:@""];
    
    if ( editMenuItem )
    {
        NSInteger index = [[formatMenuItem menu] indexOfItem:formatMenuItem] + 1;
        [[editMenuItem submenu] insertItem:alignMenuItem atIndex:index];
        
        NSMenu * alignMenu = [[NSMenu alloc] init];
        [alignMenuItem setSubmenu:alignMenu];
		
		// sub menu items
		for ( NSDictionary * item in [XAlignPluginConfig items] )
		{
			NSMenuItem * menuItem = [[NSMenuItem alloc] init];
            menuItem.target = [XAlignPlugin sharedInstance];
            menuItem.title  = item[kPatternTitle];
			menuItem.representedObject = item;
			menuItem.action = @selector(align:);
			
            NSString * skey  = item[kPatternShortcut][kPatternShortcutKey];
            NSString * sMask = item[kPatternShortcut][kPatternShortcutMask];
			
			if ( skey && sMask )
			{
				[menuItem setKeyEquivalent:skey];
				
				NSUInteger keyMask = 0;
				if ( NSNotFound != [sMask rangeOfString:kPatternShortcutMaskCmd].location )
					keyMask |= NSCommandKeyMask;
				if ( NSNotFound != [sMask rangeOfString:kPatternShortcutMaskCtrl].location )
					keyMask |= NSControlKeyMask;
				if ( NSNotFound != [sMask rangeOfString:kPatternShortcutMaskShift].location )
					keyMask |= NSShiftKeyMask;
				[menuItem setKeyEquivalentModifierMask:NSShiftKeyMask|NSCommandKeyMask];
			}
			
			[alignMenu addItem:menuItem];
		}
        // help menu item
        NSMenuItem * helpMenuItem = [[NSMenuItem alloc] init];
		helpMenuItem.title  = @"Help";
		helpMenuItem.action = @selector(showHelp);
        helpMenuItem.target = [XAlignPlugin sharedInstance];
        [alignMenu addItem:helpMenuItem];
    }
}

@end
