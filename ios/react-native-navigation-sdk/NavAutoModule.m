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

#import "NavAutoModule.h"

@implementation NavAutoModule

RCT_EXPORT_MODULE(NavAutoModule);

// Static instance of the NavAutoModule to allow access from another modules.
static NavAutoModule *sharedInstance = nil;

static NavAutoModuleReadyCallback _navAutoModuleReadyCallback;

+ (id)allocWithZone:(NSZone *)zone {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  _navAutoModuleReadyCallback();
  return sharedInstance;
}

// Method to get the shared instance
+ (instancetype)sharedInstance {
  return sharedInstance;
}

- (void)registerViewController:(NavViewController *)vc {
  self.viewController = vc;
}

+ (void)registerNavAutoModuleReadyCallback:(NavAutoModuleReadyCallback)callback {
  _navAutoModuleReadyCallback = [callback copy];
}

RCT_EXPORT_METHOD(addMarker
                  : (nonnull NSNumber *)reactTag markerOptions
                  : (NSDictionary *)markerOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addMarker:markerOptions
                         result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(addPolyline
                  : (nonnull NSNumber *)reactTag polylineOptions
                  : (NSDictionary *)polylineOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addPolyline:polylineOptions
                           result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(addPolygon
                  : (nonnull NSNumber *)reactTag polygonOptions
                  : (NSDictionary *)polygonOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addPolygon:polygonOptions
                          result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(addCircle
                  : (NSDictionary *)circleOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addCircle:circleOptions
                         result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(addPolyline
                  : (NSDictionary *)polylineOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addPolyline:polylineOptions
                           result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(addPolygon
                  : (NSDictionary *)polygonOptions resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController addPolygon:polygonOptions
                          result:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(removeMarker: (NSString *)markerId) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController removeMarker:markerId];
    }
  });
}

RCT_EXPORT_METHOD(removePolygon: (NSString *)polygonId) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController removePolygon:polygonId];
    }
  });
}

RCT_EXPORT_METHOD(removePolyline: (NSString *)polylineId) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController removePolyline:polylineId];
    }
  });
}

RCT_EXPORT_METHOD(removeCircle: (NSString *)circleId) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController removeCircle:circleId];
    }
  });
}

RCT_EXPORT_METHOD(setIndoorEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setIndoorEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setTrafficEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setTrafficEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setCompassEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setCompassEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setMyLocationButtonEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setMyLocationEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setMyLocationEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setMyLocationEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setRotateGesturesEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setRotateGesturesEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setScrollGesturesEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setScrollGesturesEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setScrollGesturesEnabledDuringRotateOrZoom: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setScrollGesturesEnabledDuringRotateOrZoom:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setZoomLevel
                  : (nonnull NSNumber *)level resolver
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setZoomLevel:level];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(setTiltGesturesEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setTiltGesturesEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setZoomGesturesEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setZoomGesturesEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(setBuildingsEnabled: (BOOL *)enabled) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController setBuildingsEnabled:enabled];
    }
  });
}

RCT_EXPORT_METHOD(getCameraPosition
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController getCameraPosition:^(NSDictionary *result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(getMyLocation
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController getMyLocation:^(NSDictionary * _Nullable result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(getUiSettingsLocation
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController getUiSettings:^(NSDictionary * _Nullable result) {
        resolve(result);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(isMyLocationEnabled
                  : (RCTPromiseResolveBlock)resolve rejecter
                  : (RCTPromiseRejectBlock)reject) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController isMyLocationEnabled:^(BOOL result) {
        resolve([NSNumber numberWithBool:result]);
      }];
    } else {
      reject(@"no_view_controller", @"No viewController found", nil);
    }
  });
}

RCT_EXPORT_METHOD(moveCamera: (NSDictionary *)cameraPosition) {
  dispatch_async(dispatch_get_main_queue(), ^{
    if (self->_viewController) {
      [self->_viewController moveCamera:cameraPosition];
    }
  });
}


@end
