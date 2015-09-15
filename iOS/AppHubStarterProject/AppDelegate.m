/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppHub/AppHub.h>
#import "AppDelegate.h"

#import "RCTBridge.h"
#import "RCTJavaScriptLoader.h"
#import "RCTRootView.h"

@interface AppDelegate() <RCTBridgeDelegate, UIAlertViewDelegate>

@end

@implementation AppDelegate {
  RCTBridge *_bridge;
}

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // TODO: replace "APPLICATION ID" with your ApplicationID from the AppHub dashboard.
  [AppHub setApplicationID:@"APPLICATION ID"];
  
  _bridge = [[RCTBridge alloc] initWithDelegate:self
                                  launchOptions:launchOptions];
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:_bridge
                                                   moduleName:@"AppHubStarterProject"];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  // Register a callback for when a new build becomes available.
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(newBuildDidBecomeAvailable:)
                                               name:AHBuildManagerDidMakeBuildAvailableNotification
                                             object:nil];
  
  return YES;
}

#pragma mark - RCTBridgeDelegate

- (NSURL *)sourceURLForBridge:(__unused RCTBridge *)bridge
{
  NSURL *sourceURL;
  
  /**
   * Loading JavaScript code - uncomment the one you want.
   *
   * OPTION 1
   * Load from development server. Start the server from the repository root:
   *
   * $ npm start
   *
   * To run on device, change `localhost` to the IP address of your computer
   * (you can get this by typing `ifconfig` into the terminal and selecting the
   * `inet` value under `en0:`) and make sure your computer and iOS device are
   * on the same Wi-Fi network.
   */
  
//  sourceURL = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];
  
  /**
   * OPTION 2 - AppHub
   *
   * Load cached code and images from AppHub. Use this when deploying to test 
   * users and the App Store.
   *
   * Make sure to re-generate the static bundle by navigating to your Xcode project
   * folder and running
   *
   * $ curl 'http://localhost:8081/index.ios.bundle' -o main.jsbundle
   *
   * then add the `main.jsbundle` file to your project.
   */

  AHBuild *build = [[AppHub buildManager] currentBuild];
  sourceURL = [build.bundle URLForResource:@"main"
                             withExtension:@"jsbundle"];
  
  return sourceURL;
}

- (void)loadSourceForBridge:(RCTBridge *)bridge
                  withBlock:(RCTSourceLoadBlock)loadCallback
{
  [RCTJavaScriptLoader loadBundleAtURL:[self sourceURLForBridge:bridge]
                            onComplete:loadCallback];
}

#pragma mark - NSNotificationCenter

-(void) newBuildDidBecomeAvailable:(NSNotification *)notification {
  // Show an alert view when a new build becomes available. The user can choose to "Update" the app, or "Cancel".
  // If the user presses "Cancel", their app will update when they close the app.
  
  AHBuild *build = notification.userInfo[AHBuildManagerBuildKey];
  NSString *alertMessage = [NSString stringWithFormat:@"There's a new update available.\n\nUpdate description:\n\n %@", build.buildDescription];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great news!"
                                                  message:alertMessage
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"Update", nil];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    // Show the alert on the main thread.
    [alert show];
  });
}

#pragma mark - UIAlertViewDelegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    // The user pressed "update".
    [_bridge reload];
  }
}

@end