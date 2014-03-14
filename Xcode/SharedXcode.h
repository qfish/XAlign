//
//  SharedXcode.h
//  XAlign
//
//  Created by QFish on 11/16/13.
//  Copyright (c) 2013 net.qfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedXcode : NSObject
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)workspaceDocument;
+ (IDESourceCodeDocument *)sourceCodeDocument;
+ (void)logSelection:(NSRange)range;

// IDE
+ (NSTextView *)textView;
+ (NSRange)charaterRangeFromSelectedRange:(NSRange)range;
// Edit
+ (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;
// Settings
+ (long long)tabWidth;
//+ (NSDictionary *)defaultSetting;
//+ (void)setValue:(NSString *)value forSettingKey:(NSString *)key;

@end
