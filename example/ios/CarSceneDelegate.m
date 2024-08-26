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

  // Create and present your CarPlay templates here
  CPListItem *listItem = [[CPListItem alloc] initWithText:@"Item 1" detailText:@"Detail Text"];
  CPListSection *section = [[CPListSection alloc] initWithItems:@[listItem]];
  CPListTemplate *listTemplate = [[CPListTemplate alloc] initWithTitle:@"Example" sections:@[section]];

  [self.interfaceController setRootTemplate:listTemplate animated:YES];
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene
didDisconnectInterfaceController:(CPInterfaceController *)interfaceController {

}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene didBecomeActive:(CPTemplateApplicationScene *)scene {
  // Handle becoming active if necessary
}

- (void)templateApplicationScene:(CPTemplateApplicationScene *)templateApplicationScene willResignActive:(CPTemplateApplicationScene *)scene {
  // Handle resigning active if necessary
}


@end
