pushd android
flutter build apk
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=integration_test/app_test.dart
popd

gcloud auth activate-service-account --key-file=attendance-app-ccc41-cbdbf60e6fd4.json

gcloud --quiet config set project attendance-app-ccc41

gcloud firebase test android run --type instrumentation \
    --app build/app/outputs/apk/debug/app-debug.apk \
    --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
    --use-orchestrator \
    --device-ids=Pixel3,b0q \
    --os-version-ids=30,33 \
    --orientations=portrait \
    --timeout 3m \
    --results-bucket=attendance-app-ccc41.appspot.com \
    --results-dir=android_integration_test_results