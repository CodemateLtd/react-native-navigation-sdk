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
#import <Foundation/Foundation.h>
#import <CarPlay/CarPlay.h>
#import "CarSceneDelegate.h"
#import "NavModule.h"
#import "NavAutoModule.h"

@implementation CarSceneDelegate

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController toWindow:(CPWindow *)window {
  self.interfaceController = interfaceController;
  self.carWindow = window;

  self.mapTemplate = [[CPMapTemplate alloc] init];
  
  CPBarButton *customButton = [[CPBarButton alloc] initWithTitle:@"Custom Event" handler:^(CPBarButton * _Nonnull button) {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary[@"sampleDataKey"] = @"sampleDataContent";
    [[NavAutoModule getOrCreateSharedInstance] onCustomNavigationAutoEvent:@"sampleEvent" data:dictionary];
  }];
  
  self.mapTemplate.leadingNavigationBarButtons = @[customButton];
   
  self.navViewController = [[NavViewController alloc] init];
  self.carWindow.rootViewController = self.navViewController;
  [self.interfaceController setRootTemplate:self.mapTemplate animated:YES completion:nil];
  [NavModule registerNavigationSessionReadyCallback:^{
    [self attachSession];
  }];
  [NavModule registerNavigationSessionDisposedCallback:^{
    self->_sessionAttached = NO;
  }];
  [NavAutoModule registerNavAutoModuleReadyCallback:^{
    [self registerViewController];
  }];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene
didDisconnectInterfaceController:(CPInterfaceController *)interfaceController {
  [self unRegisterViewController];
  self.interfaceController = nil;
  self.carWindow = nil;
  self.mapTemplate = nil;
  self.navViewController = nil;
  self.viewControllerRegistered = NO;
  self.sessionAttached = NO;
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
  [self attachSession];
  [self registerViewController];
}

- (void)attachSession {
  if ([NavModule sharedInstance] != nil && [[NavModule sharedInstance] hasSession] && !_sessionAttached) {
    [self.navViewController attachToNavigationSession:[[NavModule sharedInstance] getSession]];
    [self.navViewController setHeaderEnabled:NO];
    [self.navViewController setRecenterButtonEnabled:NO];
    [self.navViewController setFooterEnabled:NO];
    [self.navViewController setSpeedometerEnabled:NO];
    _sessionAttached = YES;
  }
}

- (void)registerViewController {
  if ([NavAutoModule sharedInstance] != nil && !_viewControllerRegistered) {
    [[NavAutoModule sharedInstance] registerViewController:self.navViewController];
    _viewControllerRegistered = YES;
  }
}

- (void)unRegisterViewController {
  if ([NavAutoModule sharedInstance] != nil && _viewControllerRegistered) {
    [[NavAutoModule sharedInstance] unRegisterViewController];
    _viewControllerRegistered = NO;
  }
}


@end
