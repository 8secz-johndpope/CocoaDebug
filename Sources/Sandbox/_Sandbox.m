//
//  Example
//  man
//
//  Created by man on 11/11/2018.
//  Copyright © 2018 man. All rights reserved.
//

#import "_Sandbox.h"
#import "_SandboxViewController.h"

@interface _Sandbox ()

@property (strong, nonatomic) UINavigationController *homeDirectoryNavigationController;

@end

@implementation _Sandbox

@synthesize homeTitle = _homeTitle;

+ (_Sandbox *)shared {
    static _Sandbox *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[_Sandbox alloc] _init];
    });
    
    return _sharedInstance;
}

- (instancetype)_init {
    if (self = [super init]) {
        [self _config];
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)_config {
    _systemFilesHidden = YES;
    _homeFileURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    _extensionHidden = NO;
    _shareable = YES;
}

#pragma mark - Setters

- (void)setHomeTitle:(NSString *)title {
    if (![_homeTitle isEqualToString:title]) {
        _homeTitle = [title copy];
        [[self.homeDirectoryNavigationController.viewControllers firstObject] setTitle:_homeTitle];
    }
}

#pragma mark - Getters

- (NSString *)homeTitle {
    if (nil == _homeTitle) {
        _homeTitle = @"Sandbox";
    }
    
    return _homeTitle;
}

//liman
- (UINavigationController *)homeDirectoryNavigationController {
    _SandboxViewController *sandboxViewController = [[_SandboxViewController alloc] init];
    sandboxViewController.homeDirectory = YES;
    sandboxViewController.fileInfo = [[_MLBFileInfo alloc] initWithFileURL:self.homeFileURL];
    return [[UINavigationController alloc] initWithRootViewController:sandboxViewController];
}

@end
