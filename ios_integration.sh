output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="14.7"

# Pass --simulatorif building for simulator
flutter build ios integration_test/app_test.dart --release

pushd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
popd

pushd $product
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
popd

gcloud firebase test ios run --test "build/ios_integ/Build/Products/ios_tests.zip" \
  --device model=iphone11pro,version=$dev_target,orientation=portrait \
  --timeout 3m \
  --results-bucket=attendance-app-ccc41.appspot.com \
  --results-dir=ios_integration_test_results