//
//  XAlignPlugin.h
//  XAlignPlugin
//
//  Created by QFish on 11/16/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import "blade.h"
#import <Foundation/Foundation.h>

#import "SettingWindowController.h"

@interface XAlignPlugin : NSObject

AS_SINGLETON( XAlignPlugin );

@property (nonatomic, assign) NSBundle * bundle;
@property (nonatomic, strong) NSWindowController * helpWindow;
@property (nonatomic, strong) SettingWindowController * settingWindow;

- (IBAction)showSetting:(id)sender;
- (void)autoAlign;
- (void)align:(NSMenuItem *)sender;

@end
