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
#import "CarPlayViewController.h"

@implementation CarPlayViewController

- (instancetype)initWithWindow:(CPWindow *)window {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _window = window;

    // More CPMapTemplate initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  GMSMapViewOptions *options = [[GMSMapViewOptions alloc] init];
  //options.screen = _window.screen;
  options.frame = self.view.bounds;
  _mapView = [[GMSMapView alloc] initWithOptions:options];
  _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  //_mapView.settings.navigationHeaderEnabled = NO;
  //_mapView.settings.navigationFooterEnabled = NO;

  // Disable buttons: in CarPlay, no part of the map is clickable.
  // The app should instead place these buttons in the appropriate slots of the CarPlay template.
  //_mapView.settings.compassButton = NO;
  //_mapView.settings.recenterButtonEnabled = NO;

  //_mapView.shouldDisplaySpeedometer = NO;
  //_mapView.myLocationEnabled = YES;

  [self.view addSubview:_mapView];
}

- (void)mapTemplate:(CPMapTemplate *)mapTemplate panBeganWithDirection:(CPPanDirection)direction {
  NSLog(@"Panning direction: %ld", (long)direction);
}

- (void)mapTemplateDidBeginPanGesture:(CPMapTemplate *)mapTemplate {
  NSLog(@"Panning started on carplay!");
}

@end
