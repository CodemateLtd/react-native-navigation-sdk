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

import { NativeModules } from 'react-native';
import type {
  CameraPosition,
  Circle,
  CircleOptions,
  MapType,
  MapViewController,
  Marker,
  MarkerOptions,
  Polygon,
  PolygonOptions,
  Polyline,
  PolylineOptions,
  UISettings,
} from '../maps';
import type { Location } from '../shared';
const { NavAutoModule } = NativeModules;

export const getMapViewAutoController = (): MapViewController => {
  return {
    setMapType: (mapType: MapType) => {
      NavAutoModule.setMapType(mapType);
    },
    setMapStyle: (mapStyle: string) => {
      NavAutoModule.setMapStyle(mapStyle);
    },
    setMapToolbarEnabled: (enabled: boolean) => {
      NavAutoModule.setMapToolbarEnabled(enabled);
    },
    clearMapView: () => {
      NavAutoModule.clearMapView();
    },

    addCircle: async (circleOptions: CircleOptions): Promise<Circle> => {
      return await NavAutoModule.addCircle(circleOptions);
    },

    addMarker: async (markerOptions: MarkerOptions): Promise<Marker> => {
      return await NavAutoModule.addMarker(markerOptions);
    },

    addPolyline: async (
      polylineOptions: PolylineOptions
    ): Promise<Polyline> => {
      return await NavAutoModule.addPolyline({
        ...polylineOptions,
        points: polylineOptions.points || [],
      });
    },

    addPolygon: async (polygonOptions: PolygonOptions): Promise<Polygon> => {
      return await NavAutoModule.addPolygon({
        ...polygonOptions,
        holes: polygonOptions.holes || [],
        points: polygonOptions.points || [],
      });
    },

    removeMarker: (_id: string) => {},

    removePolyline: (_id: string) => {},

    removePolygon: (_id: string) => {},

    removeCircle: (_id: string) => {},

    setIndoorEnabled: (_isOn: boolean) => {},

    setTrafficEnabled: (_isOn: boolean) => {},

    setCompassEnabled: (_isOn: boolean) => {},

    setMyLocationButtonEnabled: (_isOn: boolean) => {},

    setMyLocationEnabled: (_isOn: boolean) => {},

    setRotateGesturesEnabled: (_isOn: boolean) => {},

    setScrollGesturesEnabled: (_isOn: boolean) => {},

    setScrollGesturesEnabledDuringRotateOrZoom: (_isOn: boolean) => {},

    setZoomControlsEnabled: (_isOn: boolean) => {}, // TODO: What's this?

    setZoomLevel: (level: number) => {
      NavAutoModule.setZoomLevel(level);
    },

    setTiltGesturesEnabled: (_isOn: boolean) => {},

    setZoomGesturesEnabled: (_isOn: boolean) => {},

    setBuildingsEnabled: (_isOn: boolean) => {},

    getCameraPosition: async (): Promise<CameraPosition> => {
      return await NavAutoModule.getCameraPosition();
    },

    getMyLocation: async (): Promise<Location> => {
      return await NavAutoModule.getMyLocation();
    },

    getUiSettings: async (): Promise<UISettings> => {
      return await NavAutoModule.getUiSettings();
    },

    isMyLocationEnabled: async (): Promise<boolean> => {
      return await NavAutoModule.isMyLocationEnabled();
    },

    moveCamera: (_cameraPosition: CameraPosition) => {
      return NavAutoModule.moveCamera(_cameraPosition);
    },
  };
};
