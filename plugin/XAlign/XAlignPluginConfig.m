//
//  XAlignPluginConfig.m
//  XAlign
//
//  Created by QFish on 12/1/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

NSString * const kXAlignShortcut = @"net.qfish.xalign.shortcut";

#import "XAlignPlugin.h"
#import "XAlignPattern.h"
#import "XAlignPluginConfig.h"

@implementation XAlignPluginConfig

DEF_SINGLETON( XAlignPluginConfig );

+ (NSArray *)menus
{
	static NSArray * __menus = nil;
	
	if ( __menus == nil )
	{
		NSString * filePath = [[XAlignPlugin sharedInstance].bundle pathForResource:kSettingFile ofType:@"plist"];
		__menus = [NSArray arrayWithContentsOfFile:filePath];
	}
	
	return __menus;
}

+ (NSArray *)patterns
{
	static NSArray * __items = nil;
	
	if ( __items == nil )
	{
		NSString * filePath = [[XAlignPlugin sharedInstance].bundle pathForResource:kPatternsFile ofType:@"plist"];
		__items = [NSArray arrayWithContentsOfFile:filePath];
	}
	
	return __items;
}

+ (void)setKeyShortcut:(NSDictionary *)keyShortcut
{
//	NSLog( @"\n=====\n%@\n========\n", keyShortcut );

	[self setShortcut:keyShortcut menuItem:[XAlignPluginConfig sharedInstance].keyMenuItem];
	[[NSUserDefaults standardUserDefaults] setObject:keyShortcut forKey:kXAlignShortcut];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)keyShortcut
{
	NSDictionary * shortcut = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kXAlignShortcut];

//	NSLog( @"\n=====\n%@\n========\n", shortcut );
	
	if ( nil == shortcut )
	{
		shortcut = @{ @"mask": @"shift+cmd", @"key": @"x" };
		[[NSUserDefaults standardUserDefaults] setObject:shortcut forKey:kXAlignShortcut];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	return shortcut;
}

+ (void)setShortcut:(NSDictionary *)shortcut menuItem:(NSMenuItem *)menuItem
{
	NSString * skey  = shortcut[kMenuShortcutKey];
	NSUInteger sMask = [self sMaskWthShortcut:shortcut];
	
	if ( skey && sMask )
	{
		[menuItem setKeyEquivalent:skey];
		[menuItem setKeyEquivalentModifierMask:sMask];
	}
}

+ (NSUInteger)sMaskWthShortcut:(NSDictionary *)shortcut
{
	NSString * sMask = shortcut[kMenuShortcutMask];
	
	NSUInteger keyMask = 0;
	
	if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskAlt].location )
		keyMask |= NSAlternateKeyMask;
	if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskCmd].location )
		keyMask |= NSCommandKeyMask;
	if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskCtrl].location )
		keyMask |= NSControlKeyMask;
	if ( NSNotFound != [sMask rangeOfString:kMenuShortcutMaskShift].location )
		keyMask |= NSShiftKeyMask;
	
	return keyMask;
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
		for ( NSDictionary * item in [XAlignPluginConfig menus] )
		{
			NSMenuItem * menuItem = [[NSMenuItem alloc] init];
            menuItem.target = [XAlignPlugin sharedInstance];
            menuItem.title  = item[kMenuTitle];
			menuItem.representedObject = item;
			
			// TODO:
			if ( [item[@"isKeyMenuItem"] boolValue] )
			{
				[self setShortcut:[self keyShortcut] menuItem:menuItem];
				
				[XAlignPluginConfig sharedInstance].keyMenuItem = menuItem;
			}
			else
			{
				if ( item[kMenuShortcut] )
					[self setShortcut:item[kMenuShortcut] menuItem:menuItem];
			}
			
            NSString * selector = item[kMenuSelector];
            
            if ( selector )
				menuItem.action = NSSelectorFromString(selector);;
			
			[alignMenu addItem:menuItem];
		}
		
		// separator
        [alignMenu addItem:[NSMenuItem separatorItem]];
		
		// sub menu items
		for ( NSDictionary * item in [XAlignPluginConfig patterns] )
		{
			NSMenuItem * menuItem = [[NSMenuItem alloc] init];
            menuItem.target = [XAlignPlugin sharedInstance];
            menuItem.title  = item[kMenuTitle];
			menuItem.representedObject = item;
			
			[self setShortcut:item[kMenuShortcut] menuItem:menuItem];
			
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
	[XAlignPatternManager setupWithRawArray:[XAlignPluginConfig patterns]];
}

@end
