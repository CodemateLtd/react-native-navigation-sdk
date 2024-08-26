/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#import "AppDelegate.h"

#import <GoogleMaps/GoogleMaps.h>
#import <React/RCTBundleURLProvider.h>
#import <CarPlay/CarPlay.h>
#import <UIKit/UIKit.h>
#import "CarSceneDelegate.h"
#import "PhoneSceneDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.moduleName = @"SampleApp";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  NSString *api_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"API_KEY"];
  [GMSServices provideAPIKey:api_key];
  [GMSServices setMetalRendererEnabled:YES];
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  self.rootView = [[RCTRootView alloc] initWithBridge:bridge moduleName:self.moduleName initialProperties:nil];
  return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
  if ([connectingSceneSession.role isEqualToString:@"CPTemplateApplicationSceneSessionRoleApplication"]) {
    UISceneConfiguration *scene = [[UISceneConfiguration alloc] initWithName:@"CarPlay" sessionRole:connectingSceneSession.role];
    scene.delegateClass = [CarSceneDelegate class];
    return scene;
  } else {
    UISceneConfiguration *scene = [[UISceneConfiguration alloc] initWithName:@"Phone" sessionRole:connectingSceneSession.role];
    scene.delegateClass = [PhoneSceneDelegate class];
    return scene;
  }
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  return [self bundleURL];
}

- (NSURL *)bundleURL {
#if DEBUG
  return
      [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main"
                                 withExtension:@"jsbundle"];
#endif
}

@end
