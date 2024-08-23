/**
 * Copyright 2023 Google LLC
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

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.facebook.react.bridge.UiThreadUtil;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.Polygon;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.libraries.navigation.NavigationView;
import com.google.android.libraries.navigation.StylingOptions;
import com.google.android.libraries.navigation.SupportNavigationFragment;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class NavViewFragment extends Fragment implements INavigationViewController {
  private static final String TAG = "NavViewFragment";
  private MapViewController mMapViewController;
  private GoogleMap mGoogleMap;
  private SupportNavigationFragment mNavFragment;
  private INavigationViewCallback navigationViewCallback;
  private StylingOptions mStylingOptions;

  private List<Marker> markerList = new ArrayList<>();
  private List<Polyline> polylineList = new ArrayList<>();
  private List<Polygon> polygonList = new ArrayList<>();
  private List<GroundOverlay> groundOverlayList = new ArrayList<>();
  private List<Circle> circleList = new ArrayList<>();

  private NavigationView.OnRecenterButtonClickedListener onRecenterButtonClickedListener = new NavigationView.OnRecenterButtonClickedListener() {
    @Override
    public void onRecenterButtonClick() {
      if (navigationViewCallback != null) navigationViewCallback.onRecenterButtonClick();
    }
  };

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    mMapViewController = new MapViewController();
  }

  @Override
  @SuppressLint("MissingPermission")
  public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
    super.onCreateView(inflater, parent, savedInstanceState);
    return inflater.inflate(R.layout.fragment_nav_view, parent, false);
  }

  @SuppressLint("MissingPermission")
  @Override
  public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);

    mNavFragment = (SupportNavigationFragment) getChildFragmentManager().findFragmentById(R.id.navigation_fragment2);

    mNavFragment.setNavigationUiEnabled(NavModule.getInstance().getNavigator() != null);

    mNavFragment.getMapAsync(googleMap -> {
      mGoogleMap = googleMap;
      mMapViewController.initialize(googleMap, () -> requireActivity());

      // Setup map listeners with the provided callback
      if (navigationViewCallback != null) {
        mMapViewController.setupMapListeners(navigationViewCallback);
      }

      // Notify that the map is ready
      if (navigationViewCallback != null) {
        navigationViewCallback.onMapReady();
      }

      navigationViewCallback.onMapReady();

      mNavFragment.setNavigationUiEnabled(NavModule.getInstance().getNavigator() != null);
      mNavFragment.addOnRecenterButtonClickedListener(onRecenterButtonClickedListener);
    });
  }

  public MapViewController getMapController() {
    return mMapViewController;
  }

  public void setMapStyle(String url) {
    mMapViewController.setMapStyle(url);
  }

  public void applyStylingOptions() {
    if (mStylingOptions != null) {
      mNavFragment.setStylingOptions(mStylingOptions);
    }
  }

  public void setStylingOptions(StylingOptions stylingOptions) {
    mStylingOptions = stylingOptions;
  }

  public void setNightModeOption(int jsValue) {
    if (mNavFragment == null) {
      return;
    }

    mNavFragment.setForceNightMode(EnumTranslationUtil.getForceNightModeFromJsValue(jsValue));
  }

  public void setRecenterButtonEnabled(boolean isEnabled) {
    if (mNavFragment == null) {
      return;
    }

    mNavFragment.setRecenterButtonEnabled(isEnabled);
  }


  public void setTrafficIncidentCards(boolean isOn) {
    if (mGoogleMap != null) {
      mNavFragment.setTrafficIncidentCardsEnabled(isOn);
    }
  }

  public void setHeaderEnabled(boolean isOn) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setHeaderEnabled(isOn);
    });
  }

  public void setFooterEnabled(boolean isOn) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setEtaCardEnabled(isOn);
    });
  }

  public void showRouteOverview() {
    mNavFragment.showRouteOverview();
  }


  /**
   * Method to set the navigation view callback
   */
  public void setNavigationViewCallback(INavigationViewCallback callback) {
    this.navigationViewCallback = callback;

    // Ensure map listeners are set up if the map is already initialized
    if (mGoogleMap != null) {
      mMapViewController.setupMapListeners(callback);
    }
  }


  /**
   * Toggles the visibility of the Trip Progress Bar UI. This is an EXPERIMENTAL FEATURE.
   */
  public void setTripProgressBarUiEnabled(boolean isOn) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setTripProgressBarEnabled(isOn);
    });
  }

  /**
   * Toggles the visibility of speed limit icon
   *
   * @param isOn
   */
  public void setSpeedLimitIconEnabled(boolean isOn) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setSpeedLimitIconEnabled(isOn);
    });
  }

  /**
   * Toggles whether the Navigation UI is enabled.
   */
  public void setNavigationUiEnabled(boolean isOn) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setNavigationUiEnabled(isOn);
    });
  }

  public void setSpeedometerEnabled(boolean isEnable) {
    if (mNavFragment == null) {
      return;
    }

    UiThreadUtil.runOnUiThread(() -> {
      mNavFragment.setSpeedometerEnabled(isEnable);
    });
  }

  @Override
  public void onDestroy() {
    super.onDestroy();
    if (mNavFragment != null) {
      mNavFragment.onDestroy();
    }
    cleanup();
  }

  @Override
  public void onDestroyView() {
    super.onDestroyView();

    if (mNavFragment != null) {
      mNavFragment.onDestroyView();
    }

    cleanup();
  }

  public GoogleMap getGoogleMap() {
    return mGoogleMap;
  }

  private void cleanup() {
    mNavFragment.removeOnRecenterButtonClickedListener(onRecenterButtonClickedListener);
  }
}
