//
//  XAlignPluginConfig.h
//  XAlign
//
//  Created by QFish on 12/1/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMenuTitle             @"title"
#define kMenuSelector          @"selector"
#define kMenuShortcut          @"shortcut"
#define kMenuShortcutKey       @"key"
#define kMenuShortcutMask      @"mask"
#define kMenuShortcutMaskAlt   @"alt"
#define kMenuShortcutMaskCmd   @"cmd"
#define kMenuShortcutMaskCtrl  @"ctrl"
#define kMenuShortcutMaskShift @"shift"

#define kSettingFile           @"setting"
#define kPatternsFile          @"patterns"

@interface XAlignPluginConfig : NSObject

AS_SINGLETON( XAlignPluginConfig );

@property (nonatomic, assign) NSMenuItem * keyMenuItem;

+ (void)setupMenu;
+ (void)setupPatternManger;
+ (void)setKeyShortcut:(NSDictionary *)keyShortcut;

+ (NSDictionary *)keyShortcut;

@end
