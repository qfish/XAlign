//
//  XAlignPlugin.h
//  XAlignPlugin
//
//  Created by QFish on 11/16/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAlignPlugin : NSObject

AS_SINGLETON( XAlignPlugin );

@property (nonatomic, assign) NSBundle * bundle;
@property (nonatomic, strong) NSWindowController * helpWindow;

- (void)showHelp;
- (void)autoAlign;
- (void)align:(NSMenuItem *)sender;

@end
