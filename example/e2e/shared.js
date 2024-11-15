/**
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

import { device, element, system, waitFor, by } from 'detox';

export const initializeNavigationPage = async () => {
  await device.launchApp({ newInstance: true });
  await element(by.text('Navigation')).tap();
  if (device.getPlatform() === 'ios') {
    await system.element(by.system.label('Allow While Using App')).tap();
    await waitFor(element(by.text("YES, I'M IN")))
      .toBeVisible()
      .withTimeout(10000);
    await element(by.text("YES, I'M IN")).tap();
  } else if (device.getPlatform() === 'android') {
    await waitFor(element(by.text('GOT IT')))
      .toBeVisible()
      .withTimeout(10000);
    await element(by.text('GOT IT')).tap();
  }
};

export const agreeToTermsAndConditions = async () => {
  if (device.getPlatform() === 'ios') {
    await waitFor(element(by.text("YES, I'M IN")))
      .toBeVisible()
      .withTimeout(10000);
    await element(by.text("YES, I'M IN")).tap();
  } else if (device.getPlatform() === 'android') {
    await waitFor(element(by.text('GOT IT')))
      .toBeVisible()
      .withTimeout(10000);
    await element(by.text('GOT IT')).tap();
  }
};

export const waitForStepNumber = async number => {
  await waitFor(element(by.id('test_status_label')))
    .toHaveText(`Test status: Step #${number}`)
    .withTimeout(10000);
};

export const waitForTestToFinish = async () => {
  await waitFor(element(by.id('test_status_label')))
    .toHaveText(`Test status: Finished`)
    .withTimeout(10000);
};

export const initializeIntegrationTestsPage = async () => {
  await device.launchApp({ newInstance: true });
  await element(by.text('Integration Tests')).tap();
};

export const selectTestByName = async name => {
  await element(by.text('Tests')).tap();
  await element(by.text(name)).tap();
};
