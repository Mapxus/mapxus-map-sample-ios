# mapxus-map-sample-ios
### The sample for MapxusBaseSDK、MapxusMapSDK、MapxusVisualSDK and MapxusComponentKit.

[中文说明](./README_CN.md)

* Map Creation

  1. Create map with code

     file name：CreateMapByCodeViewController

     summary：Create map with code.

     detail：

     * Create a map using code and set the map's central geographic coordinates and zoom level.

  2. Create map with Interface Builder

     file name：CreateMapByXibViewController

     summary：Create map with Interface Builder.

     detail：

     * Placing view on xib to create map.
     * Set the central geographic coordinates and zoom level of the map.

  3. Create map (Specify the initial building, floor and building adaptive margin)

     file name：CreateMapWithSceneViewController

     summary：To Maximize the specified building indoor map by the setting margin range and switch to the setting floor.

     detail：

     * Create a parameter class MXMConfiguration instance with the specified building ID, floor and building adaptive margins.
     * Initialize the map with the generated MXMConfiguration instance.

  4. Create map (Specify the initial POI and zoom level)

     file name：CreateMapWithPOIViewController

     summary：To show the specified POI in the centre of the map and show the map by the setting zoom level when creating map.

     detail：

     * Create a parameter class MXMConfiguration instance using the specified POI, map zoom level.
     * Initialize the map with the generated MXMConfiguration instance.

* Map Interaction

  1. Interaction of indoor map controller

     file name：IndoorControlsViewController

     summary：Location of indoor map controllers.

     detail：

     * Set whether the indoor map control is always hidden.
     * Set indoor map control positions: left, right, top-left, top-right, bottom-left, bottom-right.

  2. Map style setting

     file name：MapAppearanceViewController

     summary：Modify map style, mark language and control outdoor map hiding.

     detail：

     * Set whether to hide the outdoor map.
     * Change map style.
     * Change mark language.

  3. Gesture interaction for switching buildings

     file name：SwitchingBuildingGesturesViewController

     summary：Setting gestures for switching buildings.

     detail：

     * Set whether or not to support tapping the screen to switch buildings.
     * Set whether or not the indoor building moves to the center of the screen to automatically switch between buildings.

  4. Method interaction (Switching indoor scenes)

     file name：FocusOnIndoorSceneViewController

     summary：Use code settings to focus on indoor scenes.

     detail：

     * Set the building and floor the map focuses on
     * Set focus effect: no zoom, zoom by animation, zoom without animation.
     * Setting Architectural Adaptive Margins.

  5. Click event listener

     file name：ClickEventListeningViewController

     summary：Listener for click or long on the map, and click POI event.

     detail：

     * Click on the POI to trigger the `- mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:` callback method.
     * Click on a map blank to trigger the `-mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:` callback method.
     * Press and hold the map to trigger the `-mapView:didLongPressedAtCoordinate:onFloor:inBuilding:` callback method.
     
6. Indoor scene switching event listener
  
   file name：SceneChangedEventListeningViewController
  
   summary：Listener for indoor scene switching events.
  
   detail：
  
   * Triggers the `-mapView:didChangeFloor:atBuilding:` callback method when switching to an indoor scene.
  
7. Get in or leave indoor scene event listener
  
   file name：IndoorSceneInAndOutListeningViewController
  
   summary：Listener for get in indoor or leave indoor scene.
  
   detail：
  
   * Triggers the `-mapView:doorMapWithIn:building:floor:` method when entering or exiting the indoor scene.
  
* Map Editing

  1. Drawing markers by floor

     file name：IndoorMarkerViewController

     summary：Only display the markers on current floor.
     
     detail：
     
     * Create multiple instances of MXMPointAnnotation on different floors and add them to the map.
     
  2. Drawing polygons by floor
  
   file name：IndoorPolygonViewController
  
   summary：Only display the polygon on current floor.
  
   detail：
  
   * Creating a Layer Instance.
  
   * Add layer to mapview.
     * Listen to floor switch, filter layer data.
  
* Indoor Positioning

  1. Indoor positioning

     file name：DisplayLocationViewController

     summary：Show the positioning location and different following mode.
     
     detail：
     
     * Real-time display of current position latitude, longitude, floor and level accuracy.
     * Switching between different position-following modes.

* Search Service

  1. Search building globally

     file name：SearchBuildingGlobalViewController

     summary：Search building globally.

     detail：

     * Creating an instance of the search parameter class MXMBuildingSearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onBuildingSearchDone:response:` callback method.

  2. Search building in the specified area

     file name：SearchBuildingInBoundViewController

     summary：Search building in the specified rectangular area.

     detail：

     * Creating an instance of the search parameter class MXMBuildingSearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onBuildingSearchDone:response:` callback method.

  3. Search building nearby

     file name：SearchBuildingNearbyViewController

     summary：Search building in the specified circular area.

     detail：

       * Creating an instance of the search parameter class MXMBuildingSearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onBuildingSearchDone:response:` callback method.

  4. Search building by building ID

     file name：SearchBuildingByIDViewController

     summary：Search building by building ID.

     detail：

     * Creating an instance of the search parameter class MXMBuildingSearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onBuildingSearchDone:response:` callback method.

  5. Get the POI categories by building or floor

     file name：CategoryIncludeInSceneViewController

     summary：Get all the POI categories of the specified building or floor.

     detail：

     * Creating an instance of the search parameter class MXMPOICategorySearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOICategorySearchDone:response:` callback method.

  6. Search POI in the specified scene

     文件件名：SearchPOIInSceneViewController

     summary：Search POI in the specified scene.

     detail：

     * Creating an instance of the search parameter class MXMPOISearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOISearchDone:response:` callback method.

  7. Search POI in the specified area

     file name：SearchPOIInBoundViewController

     summary：Search POI in the specified retangular area.

     detail：

     * Creating an instance of the search parameter class MXMPOISearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOISearchDone:response:` callback method.

  8. Search POI nearby

     file name：SearchPOINearbyViewController

     summary：Search POI in the specified circular area.

     detail：

     * Creating an instance of the search parameter class MXMPOISearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOISearchDone:response:` callback method.

  9. Search POI by POI ID

     file name：SearchPOIByIDViewController

     summary：Search POI by POI ID.

     detail：

     * Creating an instance of the search parameter class MXMPOISearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOISearchDone:response:` callback method.

* 集成案例

  1. Surrounding environment recognition

     file name：SurroundingIdentificationViewController

     summary：Make a virtual location and identify POI information around the location.

     detail：

     * Set virtual location points.
     * Create an MXMReverseGeoCodeSearchOption parameter instance using simulated positioning and query the MXMGeoCodeSearch instance to locate the scene details.
     * Get scene details via the `-onGetReverseGeoCode:result:error: ` callback method.
     * Create an instance of the search parameter class MXMOrientationPOISearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Retrieve the search result by using the `-onOrientationPOISearchDone:response: ` callback method.

  2. Route planning and navigation

     file name：RouteViewController

     summary：Search the route between the starting point and end point, and show the road adsorption.

     detail：

     * Creating an instance of the search parameter class MXMRouteSearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onRouteSearchDone:response:` callback method.
     * Create an instance of MXMRoutePainter for route mapping.
     * Creating an instance of MXMRouteAdsorber for route adsorption.
     * Create an instance of MXMRouteShortener to follow a shortened route.
  
  3. Visual map

     file name：ShowVisualViewController

     summary：Integration of Visual map.

     detail：

     * Find out if the selected indoor scene has Visual map data.
     * Creating an instance of the search parameter class MXMVisualBuildingSearchOption.
     * Creating an instance of the search class MXMVisualSearch.
     * Get retrieval result by `-onGetVisualDataInBuilding:result:error:` callback method.
     * Create an instance of MXMVisualFlagPainter to plot information points on a map.
     * Create an instance of MXMVisualView to show Visual map.
  
  4. Explore building
  
     file name：SearchIntegrateViewController
  
     summary：Common case of POI search in the building.
  
     detail：
  
     * Select an interior building.      
     * Creating an instance of the search parameter class MXMPOICategorySearchRequest.
     * Create an instance of the search class MXMSearchAPI.
     * Get the search result by using the `-onPOICategorySearchDone:response:` callback method.
     * Creating an instance of MXMPOISearchRequest by specifying a category.
     * Get the search result by using the `-onPOISearchDone:response:` callback method.
     * Click on POI for details.


