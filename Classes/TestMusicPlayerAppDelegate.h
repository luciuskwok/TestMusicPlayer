//
//  TestMusicPlayerAppDelegate.h
//  TestMusicPlayer
//
//  Created by Lucius Kwok on 7/12/10.
//  Copyright Felt Tip Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestMusicPlayerViewController;

@interface TestMusicPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestMusicPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestMusicPlayerViewController *viewController;

@end

