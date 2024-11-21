/* eslint-disable react-native/no-inline-styles */
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

import React, { useState, useMemo, useCallback } from 'react';
import { Button, Text, View } from 'react-native';
import Snackbar from 'react-native-snackbar';

import {
  type Circle,
  type LatLng,
  type MapViewCallbacks,
  type MapViewController,
  type Marker,
  type Polygon,
  type Polyline,
  MapView,
  useNavigation,
} from '@googlemaps/react-native-navigation-sdk';
import styles from '../styles';
import OverlayModal from '../helpers/overlayModal';
import {
  testMapInitialization,
  runTest3,
  testNavigationSessionInitialization,
} from './integration_tests/integration_test';

// Utility function for showing Snackbar
const showSnackbar = (text: string, duration = Snackbar.LENGTH_SHORT) => {
  Snackbar.show({ text, duration });
};

enum TestRunStatus {
  NotRunning = 'Not running',
  TestRunning = 'Running...',
  WaitForDetox = 'Wait For Detox...',
  Finished = 'Finished',
}

enum TestResult {
  None = 'None',
  Success = 'Success',
  Failure = 'Failure',
}

const IntegrationTestsScreen = () => {
  const [mapViewController, setMapViewController] =
    useState<MapViewController | null>(null);
  const [isOverlayOpen, setIsOverlayOpen] = useState(false);
  const [activeTestId, setActiveTestId] = useState('');
  const [testStatus, setTestStatus] = useState<TestRunStatus>(
    TestRunStatus.NotRunning
  );
  const [testResult, setTestResult] = useState<TestResult>(TestResult.None);
  const { navigationController, addListeners, removeListeners } =
    useNavigation();
  const [detoxStepNumber, setDetoxStepNumber] = useState(0);
  const [failureMessage, setFailuremessage] = useState('');

  const onMapReady = useCallback(async () => {
    console.log('Map is ready, initializing navigator...');
    try {
      // await navigationController.init();
    } catch (error) {
      console.error('Error initializing navigator', error);
      showSnackbar('Error initializing navigator');
    }
  }, []);

  const mapViewCallbacks: MapViewCallbacks = useMemo(
    () => ({
      onMapReady: onMapReady,
      onMarkerClick: (marker: Marker) => {
        console.log('Map 1, onMarkerClick:', marker);
        mapViewController?.removeMarker(marker.id);
      },
      onPolygonClick: (polygon: Polygon) => {
        console.log('Map 1, onPolygonClick:', polygon);
        mapViewController?.removePolygon(polygon.id);
      },
      onCircleClick: (circle: Circle) => {
        console.log('Map 1, onCircleClick:', circle);
        mapViewController?.removeCircle(circle.id);
      },
      onPolylineClick: (polyline: Polyline) => {
        console.log('Map 1, onPolylineClick:', polyline);
        mapViewController?.removePolyline(polyline.id);
      },
      onMarkerInfoWindowTapped: (marker: Marker) => {
        console.log('Map 1, onMarkerInfoWindowTapped:', marker);
      },
      onMapClick: (latLng: LatLng) => {
        console.log('Map 1, onMapClick:', latLng);
      },
    }),
    [mapViewController, onMapReady]
  );

  const passTest = () => {
    setTestStatus(TestRunStatus.Finished);
    setTestResult(TestResult.Success);
  };

  const failTest = (message: string) => {
    setTestStatus(TestRunStatus.Finished);
    setTestResult(TestResult.Failure);
    setFailuremessage(message);
  };

  const setDetoxStep = (stepNumber: number) => {
    setDetoxStepNumber(stepNumber);
    setTestStatus(TestRunStatus.WaitForDetox);
  };

  const resetTestState = () => {
    setActiveTestId('');
    setTestResult(TestResult.None);
    setTestStatus(TestRunStatus.NotRunning);
    setDetoxStepNumber(0);
    setFailuremessage('');
  };

  const expectFalseError = (expectation: string) => {
    failTest(`Expected ${expectation} to be false but it was true`);
  };

  const expectTrueError = (expectation: string) => {
    failTest(`Expected ${expectation} to be true but it was false`);
  };

  const getTestTools = () => {
    return {
      navigationController,
      mapViewController,
      addListeners,
      removeListeners,
      passTest,
      failTest,
      setDetoxStep,
      expectFalseError,
      expectTrueError,
    };
  };

  const runTest = async (testId: string) => {
    setIsOverlayOpen(false);
    setActiveTestId(testId);
    setTestResult(TestResult.None);
    setTestStatus(TestRunStatus.TestRunning);
    switch (testId) {
      case 'testNavigationSessionInitialization':
        await testNavigationSessionInitialization(getTestTools());
        break;
      case 'testMapInitialization':
        await testMapInitialization(getTestTools());
        break;
      case 'test3':
        await runTest3();
        break;
      default:
        resetTestState();
        break;
    }
  };

  const testStatusString = useMemo(() => {
    if (testStatus === TestRunStatus.WaitForDetox) {
      return 'Step' + ' #' + detoxStepNumber;
    }
    return testStatus;
  }, [testStatus, detoxStepNumber]);

  return (
    <View style={[styles.container]}>
      <View style={{ flex: 1, margin: 5 }}>
        <MapView
          mapViewCallbacks={mapViewCallbacks}
          onMapViewControllerCreated={setMapViewController}
        />
      </View>
      <View style={{ flex: 3 }}>
        <Text>Selected testId: {activeTestId}</Text>
        <Text testID="test_status_label">Test status: {testStatusString}</Text>
        <Text testID="test_result_label">Test result: {testResult}</Text>
        <Text testID="failure_message_label">{failureMessage}</Text>
        <Button
          title="Reset"
          onPress={() => {
            resetTestState();
          }}
        />
      </View>
      <View style={styles.controlButtons}>
        <Button
          title="Tests"
          testID="tests_menu_button"
          onPress={() => {
            setIsOverlayOpen(true);
          }}
        />
      </View>
      <OverlayModal
        visible={isOverlayOpen}
        closeOverlay={() => {
          setIsOverlayOpen(false);
        }}
      >
        <Button
          title="testNavigationSessionInitialization"
          testID="testNavigationSessionInitialization"
          onPress={() => {
            runTest('testNavigationSessionInitialization');
          }}
        />
        <Button
          title="testMapInitialization"
          testID="testMapInitialization"
          onPress={() => {
            runTest('testMapInitialization');
          }}
        />
        <Button
          title="Test3"
          testID="Test3"
          onPress={() => {
            runTest('test3');
          }}
        />
      </OverlayModal>
    </View>
  );
};

export default IntegrationTestsScreen;
