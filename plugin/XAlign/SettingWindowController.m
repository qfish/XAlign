//
//  SettingWindowController.m
//  XAlign
//
//  Created by QFish on 12/3/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import "XAlignPluginConfig.h"
#import "SettingWindowController.h"

@interface SettingWindowController ()

@end

@implementation SettingWindowController

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSString * key = self.key.stringValue;
    NSString * mask = self.mask.stringValue;

	if ( key && mask )
	{
		NSDictionary * shortcut = @{ @"mask": mask, @"key": key };
		[XAlignPluginConfig setKeyShortcut:shortcut];
	}
	
	return YES;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	
	NSDictionary * shortcut = [XAlignPluginConfig keyShortcut];
	
	self.key.stringValue  = shortcut[kMenuShortcutKey];
	self.mask.stringValue = shortcut[kMenuShortcutMask];
}

@end
