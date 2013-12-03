//
//  AppDelegate.h
//  main
//
//  Created by QFish on 11/17/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong) NSWindowController * settingWindow;
@property (assign) IBOutlet NSTextView * input;
@property (assign) IBOutlet NSTextView * output;

- (IBAction)format:(id)sender;
- (IBAction)selectFormatter:(id)sender;

@end
