//
//  XAlignPluginConfig.m
//  XAlign
//
//  Created by QFish on 12/1/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#define kMenuFile              @"patterns"
#define kMenuType              @"type"
#define kMenuTitle             @"title"
#define kMenuSelector          @"selector"
#define kMenuShortcut          @"shortcut"
#define kMenuShortcutKey       @"key"
#define kMenuShortcutMask      @"mask"
#define kMenuShortcutMaskCmd   @"cmd"
#define kMenuShortcutMaskCtrl  @"ctrl"
#define kMenuShortcutMaskShift @"shift"
#define kMenuShortcutMaskShift @"shift"

#import "XAlignPlugin.h"
#import "XAlignPattern.h"
#import "XAlignPluginConfig.h"

@implementation XAlignPluginConfig

+ (NSArray *)items
{
	static NSArray * __items = nil;
	
	if ( __items == nil )
	{
		NSString * filePath = [[XAlignPlugin sharedInstance].bundle pathForResource:kMenuFile ofType:@"plist"];
		__items = [NSArray arrayWithContentsOfFile:filePath];
	}
	
	return __items;
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
            menuItem.title  = item[kMenuTitle];
			menuItem.representedObject = item;
			
            NSString * skey  = item[kMenuShortcut][kMenuShortcutKey];
            NSString * sMask = item[kMenuShortcut][kMenuShortcutMask];
			
			if ( skey && sMask )
			{
				[menuItem setKeyEquivalent:skey];
				
				NSUInteger keyMask = 0;
				if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskCmd].location )
					keyMask |= NSCommandKeyMask;
				if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskCtrl].location )
					keyMask |= NSControlKeyMask;
				if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskShift].location )
					keyMask |= NSShiftKeyMask;
				[menuItem setKeyEquivalentModifierMask:NSShiftKeyMask|NSCommandKeyMask];
			}

            NSString * selector = item[kMenuSelector];
            
            if ( selector )
            {
				SEL action = NSSelectorFromString(selector);
				menuItem.action = action;
            }
			
			[alignMenu addItem:menuItem];
		}
    }
}

+ (void)setupPatternManger
{
	[XAlignPatternManager setupWithRawArray:[XAlignPluginConfig items]];
}

@end
