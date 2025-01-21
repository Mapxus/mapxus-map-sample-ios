# CHANGELOG

## v8.10.0 (2025-01-21)

### 🎉 New

* Add a "Outdoor Route Opacity" property to the "Route Style Setting" page to set the opacity of the outdoor route.

### 📝 Changes

* The SDK version has been upgraded to 7.2.0.

* All dependent libraries have been upgraded so as not to depend on the `libarclite` library. Consequently, the code segment of `IPHONEOS_DEPLOYMENT_TARGET` that modifies the dependent SDK in the Podfile should be removed.
