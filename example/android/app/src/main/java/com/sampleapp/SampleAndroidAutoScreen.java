/*
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.sampleapp;

import static java.lang.Double.max;

import android.annotation.SuppressLint;
import android.app.Presentation;
import android.graphics.Point;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;

import androidx.annotation.NonNull;
import androidx.car.app.AppManager;
import androidx.car.app.CarContext;
import androidx.car.app.Screen;
import androidx.car.app.SurfaceCallback;
import androidx.car.app.SurfaceContainer;
import androidx.car.app.model.Action;
import androidx.car.app.model.ActionStrip;
import androidx.car.app.model.CarIcon;
import androidx.car.app.model.Distance;
import androidx.car.app.model.Pane;
import androidx.car.app.model.PaneTemplate;
import androidx.car.app.model.Row;
import androidx.car.app.model.Template;
import androidx.car.app.navigation.model.Maneuver;
import androidx.car.app.navigation.model.NavigationTemplate;
import androidx.car.app.navigation.model.RoutingInfo;
import androidx.car.app.navigation.model.Step;
import androidx.core.graphics.drawable.IconCompat;

import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.libraries.mapsplatform.turnbyturn.model.NavInfo;
import com.google.android.libraries.mapsplatform.turnbyturn.model.StepInfo;
import com.google.android.libraries.navigation.NavigationViewForAuto;

import com.google.android.react.navsdk.NavInfoReceivingService;

public class SampleAndroidAutoScreen extends Screen implements SurfaceCallback {
  private static final String VIRTUAL_DISPLAY_NAME = "SampleAppNavScreen";
  private NavigationViewForAuto navigationView;
  private VirtualDisplay virtualDisplay;
  private Presentation presentation;
  private GoogleMap googleMap;
  private boolean navigationInitialized = true;
  private RoutingInfo currentRoutingInfo;

  public interface Listener {
    /**
     * Stops navigation.
     */
    void stopNavigation();
  }

  public SampleAndroidAutoScreen(
    @NonNull CarContext carContext) {

    super(carContext);

//    NavModule.getInstance().registerNavigationReadyListener((boolean ready) -> {
//      this.navigationInitialized = ready;
//      invalidate();
//    });

    carContext.getCarService(AppManager.class).setSurfaceCallback(this);
    NavInfoReceivingService.getNavInfoLiveData().observe(this, this::processNextStep);
  }


  private void processNextStep(NavInfo navInfo) {
    if (navInfo == null || navInfo.getCurrentStep() == null) {
      return;
    }

    /**
     *   Converts data received from the Navigation data feed
     *   into Android-Auto compatible data structures. For more information
     *   see the "Ensure correct maneuver types" below.
     */
    Step currentStep = buildStepFromStepInfo(navInfo.getCurrentStep());
    Distance distanceToStep = Distance.create(max(navInfo.getDistanceToCurrentStepMeters(),0), Distance.UNIT_METERS);

    currentRoutingInfo =
      new RoutingInfo.Builder().setCurrentStep(currentStep, distanceToStep).build();

    // Invalidate the current template which leads to another onGetTemplate call.
    invalidate();
  }

  private Step buildStepFromStepInfo(StepInfo stepInfo) {
    //IconCompat maneuverIcon =
    //  IconCompat.createWithBitmap(stepInfo.getManeuverBitmap());
    Maneuver.Builder
      maneuverBuilder = new Maneuver.Builder(
      stepInfo.getManeuver());
    //CarIcon maneuverCarIcon = new CarIcon.Builder(maneuverIcon).build();
    //maneuverBuilder.setIcon(maneuverCarIcon);
    Step.Builder stepBuilder =
      new Step.Builder()
        .setRoad(stepInfo.getFullRoadName())
        .setCue(stepInfo.getFullInstructionText())
        .setManeuver(maneuverBuilder.build());

//    if (stepInfo.getLanes() != null
//      && stepInfo.getLanesBitmap() != null) {
//      for (Lane lane : buildAndroidAutoLanesFromStep(stepInfo)) {
//        stepBuilder.addLane(lane);
//      }
//      IconCompat lanesIcon =
//        IconCompat.createWithBitmap(stepInfo.getLanesBitmap());
//      CarIcon lanesImage = new CarIcon.Builder(lanesIcon).build();
//      stepBuilder.setLanesImage(lanesImage);
//    }
    return stepBuilder.build();
  }

  private boolean isSurfaceReady(SurfaceContainer surfaceContainer) {
    return surfaceContainer.getSurface() != null
      && surfaceContainer.getDpi() != 0
      && surfaceContainer.getHeight() != 0
      && surfaceContainer.getWidth() != 0;
  }

  @Override
  public void onSurfaceAvailable(@NonNull SurfaceContainer surfaceContainer) {
    if (!isSurfaceReady(surfaceContainer)) {
      return;
    }
    virtualDisplay =
      getCarContext()
        .getSystemService(DisplayManager.class)
        .createVirtualDisplay(
          VIRTUAL_DISPLAY_NAME,
          surfaceContainer.getWidth(),
          surfaceContainer.getHeight(),
          surfaceContainer.getDpi(),
          surfaceContainer.getSurface(),
          DisplayManager.VIRTUAL_DISPLAY_FLAG_OWN_CONTENT_ONLY);
    presentation = new Presentation(getCarContext(), virtualDisplay.getDisplay());

    navigationView = new NavigationViewForAuto(getCarContext());
    navigationView.onCreate(null);
    navigationView.onStart();
    navigationView.onResume();

    presentation.setContentView(navigationView);
    presentation.show();

    navigationView.getMapAsync((GoogleMap googleMap) -> {
      this.googleMap = googleMap;
      invalidate();
    });
  }

  @Override
  public void onSurfaceDestroyed(@NonNull SurfaceContainer surfaceContainer) {
    navigationView.onPause();
    navigationView.onStop();
    navigationView.onDestroy();

    presentation.dismiss();
    virtualDisplay.release();
  }


  @Override
  public void onScroll(float distanceX, float distanceY) {
    if (googleMap == null) {
      return;
    }
    googleMap.moveCamera(CameraUpdateFactory.scrollBy(distanceX, distanceY));
  }

  @Override
  public void onScale(float focusX, float focusY, float scaleFactor) {
    if (googleMap == null) {
      return;
    }
    CameraUpdate update =
      CameraUpdateFactory.zoomBy((scaleFactor - 1),
        new Point((int) focusX, (int) focusY));
    googleMap.animateCamera(update); // map is set in onSurfaceAvailable.
  }

  @NonNull
  @Override
  @SuppressLint("MissingPermission")
  public Template onGetTemplate() {
    if (!navigationInitialized) {
      return new PaneTemplate.Builder(
        new Pane.Builder().addRow(
          new Row.Builder()
            .setTitle("Nav SampleApp")
            .addText("Initializing")
            .build()
        ).build()
      ).build();
    }

    NavigationTemplate.Builder navigationTemplateBuilder = new NavigationTemplate.Builder()
      .setActionStrip(new ActionStrip.Builder().addAction(
          new Action.Builder()
            .setTitle("Re-center")
            .setOnClickListener(
              () -> {
                if (googleMap == null)
                  return;
                googleMap.followMyLocation(GoogleMap.CameraPerspective.TILTED);
              }
            )
            .build()).addAction(
          new Action.Builder()
            .setTitle("Add circle")
            .setOnClickListener(
              () -> {
                if (googleMap == null)
                  return;

                CircleOptions options = new CircleOptions();
                options.strokeWidth(10);
                options.radius(100000);
                options.center(new LatLng(0, 0));
                googleMap.addCircle(options);
              }
            )
            .build())
        .build())
      .setMapActionStrip(new ActionStrip.Builder().addAction(Action.PAN).build());

    if (currentRoutingInfo != null) {
      navigationTemplateBuilder.setNavigationInfo(currentRoutingInfo);
    }

    return navigationTemplateBuilder.build();
  }
}


