#!/bin/sh
# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Script to format or check formatting for Java files in /android and /example/android

if [ "$1" = "--check" ]; then
    find android/src example/android/app/src -name "*.java" | xargs google-java-format --dry-run --set-exit-if-changed
else
    find android/src example/android/app/src -name "*.java" | xargs google-java-format -i
fi
