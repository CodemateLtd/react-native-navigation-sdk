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

@implementation CarSceneDelegate

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didConnectInterfaceController:(CPInterfaceController *)interfaceController toWindow:(CPWindow *)window {
  self.interfaceController = interfaceController;
  self.carWindow = window;

  self.mapTemplate = [[CPMapTemplate alloc] init];
  self.mapViewController = [[CarPlayViewController alloc] initWithWindow:_carWindow];
  self.mapTemplate.mapDelegate = self.mapViewController;
  self.carWindow.rootViewController = self.mapViewController;
  [self.interfaceController setRootTemplate:self.mapTemplate animated:YES completion:nil];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene
didDisconnectInterfaceController:(CPInterfaceController *)interfaceController {
  self.interfaceController = nil;
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didBecomeActive:(CPTemplateApplicationScene *)scene {
  // Handle becoming active if necessary
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene willResignActive:(CPTemplateApplicationScene *)scene {
  // Handle resigning active if necessary
}


@end
