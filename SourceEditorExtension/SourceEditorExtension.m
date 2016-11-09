//
//  SourceEditorExtension.m
//  SourceEditorExtension
//
//  Created by QFish on 03/11/2016.
//  Copyright © 2016 QFish. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "XAlignPattern.h"

@implementation SourceEditorExtension

- (void)extensionDidFinishLaunching
{
    // If your extension needs to do any work at launch, implement this optional method.
	[XAlignPatternManager launch];
}

//- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
//{
//    // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
//    return @[];
//}

@end
