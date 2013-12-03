//
//  SettingWindowController.h
//  XAlign
//
//  Created by QFish on 12/3/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingWindowController : NSWindowController<NSTextFieldDelegate>

@property (nonatomic, strong) IBOutlet NSTextField * key;
@property (nonatomic, strong) IBOutlet NSTextField * mask;

@end
