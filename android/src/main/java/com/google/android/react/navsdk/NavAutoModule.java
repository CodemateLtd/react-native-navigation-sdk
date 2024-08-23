/**
 * Copyright 2024 Google LLC
 *
 * <p>Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of the License at
 *
 * <p>http://www.apache.org/licenses/LICENSE-2.0
 *
 * <p>Unless required by applicable law or agreed to in writing, software distributed under the
 * License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.react.navsdk;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.UiThreadUtil;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.libraries.navigation.StylingOptions;

import java.util.Map;

/**
 * This exposes a series of methods that can be called diretly from the React Native code. They have
 * been implemented using promises as it's not recommended for them to be synchronous.
 */
public class NavAutoModule extends ReactContextBaseJavaModule {
  public static final String REACT_CLASS = "NavAutoModule";
  private static final String TAG = "AndroidAutoModule";
  private static NavAutoModule instance;
  private static ModuleReadyListener moduleReadyListener;

  ReactApplicationContext reactContext;
  private MapViewController mMapViewController;
  private StylingOptions mStylingOptions;
  private INavigationViewController mNavigationViewController;

  public interface ModuleReadyListener {
    void onModuleReady();
  }

  public NavAutoModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    instance = this;
    if (moduleReadyListener != null) {
      moduleReadyListener.onModuleReady();
    }
  }

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  // Called by the AndroidAuto implementation. See SampleApp for example.
  public static synchronized NavAutoModule getInstance() {
    if (instance == null) {
      throw new IllegalStateException(REACT_CLASS + " instance is null");
    }
    return instance;
  }

  public static void setModuleReadyListener(ModuleReadyListener listener) {
    moduleReadyListener = listener;
    if (instance != null && moduleReadyListener != null) {
      moduleReadyListener.onModuleReady();
    }
  }

  public void androidAutoNavigationScreenInitialized(MapViewController mapViewController, INavigationViewController navigationViewController) {
    mMapViewController = mapViewController;
    mNavigationViewController = navigationViewController;
    if (mStylingOptions != null && mNavigationViewController != null) {
      mNavigationViewController.setStylingOptions(mStylingOptions);
    }
    // TODO: Send initialized message
  }

  public void androidAutoNavigationScreenDisposed() {
    mMapViewController = null;
    mNavigationViewController = null;

    // TODO: Send dispose message
  }

  public void setStylingOptions(Map<String, Object> stylingOptions) {
    mStylingOptions = new StylingOptionsBuilder.Builder(stylingOptions).build();
    if (mStylingOptions != null && mNavigationViewController != null) {
      mNavigationViewController.setStylingOptions(mStylingOptions);
    }
  }

  @ReactMethod
  public void addCircle(ReadableMap circleOptionsMap, final Promise promise) {
    UiThreadUtil.runOnUiThread(
      () -> {
        if (mMapViewController == null) {
          promise.reject(JsErrors.NO_MAP_ERROR_CODE, JsErrors.NO_MAP_ERROR_MESSAGE);
          return;
        }
        Circle circle =
          mMapViewController.addCircle(circleOptionsMap.toHashMap());

        promise.resolve(ObjectTranslationUtil.getMapFromCircle(circle));
      });
  }

  @ReactMethod
  public void getCameraPosition(final Promise promise) {
    UiThreadUtil.runOnUiThread(
      () -> {
        if (mMapViewController == null) {
          promise.reject(JsErrors.NO_MAP_ERROR_CODE, JsErrors.NO_MAP_ERROR_MESSAGE);
          return;
        }

        CameraPosition cp = mMapViewController.getGoogleMap().getCameraPosition();

        if (cp == null) {
          promise.resolve(null);
          return;
        }

        LatLng target = cp.target;
        WritableMap map = Arguments.createMap();
        map.putDouble("bearing", cp.bearing);
        map.putDouble("tilt", cp.tilt);
        map.putDouble("zoom", cp.zoom);
        map.putMap("target", ObjectTranslationUtil.getMapFromLatLng(target));

        promise.resolve(map);
      });
  }

  @ReactMethod
  public void setZoomLevel(final Integer level, final Promise promise) {
    UiThreadUtil.runOnUiThread(
      () -> {
        if (mMapViewController == null) {
          promise.reject(JsErrors.NO_MAP_ERROR_CODE, JsErrors.NO_MAP_ERROR_MESSAGE);
          return;
        }

        mMapViewController.setZoomLevel(level);
        promise.resolve(true);
      });
  }
}
