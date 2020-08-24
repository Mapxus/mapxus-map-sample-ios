# mapxus-map-sample-ios
### The sample for MapxusBaseSDK、MapxusMapSDK、MapxusVisualSDK and MapxusComponentKit.

[English Version](./README.md)

* 地图创建

  1. 创建地图（代码）

     文件名：CreateMapByCodeViewController

     简介：通过代码创建地图

     详述：

     * 使用代码创建地图，并设置地图的中心地理坐标和缩放等级

  2. 创建地图（Interface Builder）

     文件名：CreateMapByXibViewController

     简介：通过Interface Builder文件创建地图

     详述：

     * 在xib上放置view控件创建地图
     * 设置地图的中心地理坐标和缩放等级

  3. 创建地图（指定初始建筑，楼层及建筑自适应边距）

     文件名：CreateMapWithSceneViewController

     简介：创建地图时在设置的边距范围内最大化显示指定的建筑并切换到设置楼层

     详述：

     * 使用指定的建筑ID、楼层及建筑自适应边距创建参数类MXMConfiguration实例
     * 通过生成的MXMConfiguration实例初始化地图

  4. 创建地图（指定初始POI及地图缩放等级）

     文件名：CreateMapWithPOIViewController

     简介：创建地图时在地图中心显示指定的POI，并设置地图缩放等级

     详述：

     * 使用指定的POI、地图缩放等级创建参数类MXMConfiguration实例
     * 通过生成的MXMConfiguration实例初始化地图

* 地图交互

  1. 室内地图控件交互

     文件名：IndoorControlsViewController

     简介：室内地图控件的位置

     详述：

     * 设置是否一直隐藏室内地图控件
     * 设置室内地图控件位置：左边，右边，左上角，右上角，左下角，右下角

  2. 修改地图外观

     文件名：MapAppearanceViewController

     简介：选择地图样式、标注语言及控制室外地图隐藏

     详述：

     * 设置是否隐藏室外地图
     * 更换地图样式
     * 更换地图标注语言

  3. 切换建筑的手势交互

     文件名：SwitchingBuildingGesturesViewController

     简介：设置切换建筑手势

     详述：

     * 设置是否支持点击屏幕切换建筑
     * 设置是否支持室内建筑移动到屏幕中心区域自动切换建筑

  4. 方法交互（切换室内场景）

     文件名：FocusOnIndoorSceneViewController

     简介：代码设置聚焦的室内场景

     详述：

     * 设置地图聚焦的建筑与楼层
     * 设置聚焦效果：不缩放、通过动画缩放、无动画缩放
     * 设置建筑自适应边距

  5. 事件交互（监听点击）

     文件名：ClickEventListeningViewController

     简介：监听单击、长按地图事件，单击POI事件

     详述：

     * 单击地图POI，触发`- mapView:didSingleTappedOnPOI:atCoordinate:onFloor:inBuilding:`回调方法
     * 单击地图空白，触发`-mapView:didSingleTappedOnMapBlank:onFloor:inBuilding:`回调方法
     * 长按地图，触发`-mapView:didLongPressedAtCoordinate:onFloor:inBuilding:`回调方法

  6. 事件交互（监听室内场景切换）

     文件名：SceneChangedEventListeningViewController

     简介：监听室内场景切换事件。

     详述：

     * 切换室内场景时，触发`-mapView:didChangeFloor:atBuilding:`回调方法

  7. 事件交互（监听进出室内场景）

     文件名：IndoorSceneInAndOutListeningViewController

     简介：监听进出室内场景事件

     详述：

     * 进出室内场景时，触发`-mapView:indoorMapWithIn:building:floor:`方法

* 地图上绘制

  1. 按楼层绘制标注

     文件名：IndoorMarkerViewController

     简介：当前场景只显示对应楼层的标注
     
     详述：
     
     * 创建多个不同楼层的MXMPointAnnotation实例，并添加到地图上
     
  2. 按楼层绘制多边形
  
   文件名：IndoorPolygonViewController
  
   简介：当前场景只显示对应楼层的绘制多边形
  
   详述：
  
   * 创建layer实例
  
   * 添加layer到mapview
     * 监听楼层切换，过滤layer数据
  
* 室内定位效果展示

  1. 室内定位效果展示

     文件名：DisplayLocationViewController

     简介：展示室内定位及地图跟随的效果
     
     详述：
     
     * 实时显示当前定位经纬度，楼层与水平精度
     * 切换不同的定位跟随模式

* 地图数据检索

  1. 全球范围内搜索建筑

     文件名：SearchBuildingGlobalViewController

     简介：在全球范围内搜索建筑

     详述：

     * 创建检索参数类MXMBuildingSearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onBuildingSearchDone:response:`回调方法获取检索结果

  2. 指定矩形区域内搜索建筑

     文件名：SearchBuildingInBoundViewController

     简介：在指定的矩形区域内搜索建筑

     详述：

     * 创建检索参数类MXMBuildingSearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onBuildingSearchDone:response:`回调方法获取检索结果

  3. 在附近搜索建筑

     文件名：SearchBuildingNearbyViewController

     简介：在指定的圆形区域内搜索建筑

     详述：

       * 创建检索参数类MXMBuildingSearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onBuildingSearchDone:response:`回调方法获取检索结果

  4. 指定建筑ID搜索建筑

     文件名：SearchBuildingByIDViewController

     简介：按建筑ID搜索建筑

     详述：

     * 创建检索参数类MXMBuildingSearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onBuildingSearchDone:response:`回调方法获取检索结果

  5. 获取指定场景内包含的POI分类

     文件名：CategoryIncludeInSceneViewController

     简介：获取指定建筑或楼层内所有包含的POI类别

     详述：

     * 创建检索参数类MXMPOICategorySearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOICategorySearchDone:response:`回调方法获取检索结果

  6. 指定场景内搜索POI

     文件件名：SearchPOIInSceneViewController

     简介：在指定场景内搜索POI，获取指定建筑或楼层内所有的POI

     详述：

     * 创建检索参数类MXMPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOISearchDone:response:`回调方法获取检索结果

  7. 指定矩形区域内搜索POI

     文件名：SearchPOIInBoundViewController

     简介：在指定的矩形区域内搜索POI

     详述：

     * 创建检索参数类MXMPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOISearchDone:response:`回调方法获取检索结果

  8. 周边POI搜索

     文件名：SearchPOINearbyViewController

     简介：在指定圆形区域内搜索POI

     详述：

     * 创建检索参数类MXMPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOISearchDone:response:`回调方法获取检索结果

  9. 指定POI ID搜索

     文件名：SearchPOIByIDViewController

     简介：按POI ID搜索POI

     详述：

     * 创建检索参数类MXMPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOISearchDone:response:`回调方法获取检索结果

* 集成案例

  1. 周边环境识别

     文件名：SurroundingIdentificationViewController

     简介：制作虚拟定位并识别定位周边POI信息。

     详述：

     * 设置模拟定位点
     * 使用模拟定位创建MXMReverseGeoCodeSearchOption参数实例，通过MXMGeoCodeSearch实例查询定位所在场景详情
     * 通过`-onGetReverseGeoCode:result:error:`回调方法获取场景详情
     * 创建检索参数类MXMOrientationPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onOrientationPOISearchDone:response:`回调方法获取检索结果

  2. 路线规划与路线吸附

     文件名：RouteViewController

     简介：检索起始点间的路线，并实现路网吸附、缩短功能

     详述：

     * 创建检索参数类MXMRouteSearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onRouteSearchDone:response:`回调方法获取检索结果
     * 创建MXMRoutePainter的实例，进行线路绘制
     * 创建MXMRouteAdsorber的实例，进行路线吸附
     * 创建MXMRouteShortener的实例，进行定位跟随缩短路线
  
  3. Visual map

     文件名：ShowVisualViewController

     简介：介绍Visual的集成

     详述：

     * 查询选中室内场景是否有Visual map数据
     * 创建检索参数类MXMVisualBuildingSearchOption的实例
     * 创建检索类MXMVisualSearch的实例
     * 通过`-onGetVisualDataInBuilding:result:error:`回调方法获取检索结果
     * 创建MXMVisualFlagPainter的实例在地图上绘制信息点
     * 创建MXMVisualView的实例展示Visual map
  
  4. explore搜索
  
     文件名：SearchIntegrateViewController
  
     简介：介绍建筑内POI常见搜索的集成
  
     详述：
  
     * 选中某个室内建筑      
     * 创建检索参数类MXMPOICategorySearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOICategorySearchDone:response:`回调方法获取检索结果
     * 通过指定类别创建检索参数类MXMPOISearchRequest的实例
     * 创建检索类MXMSearchAPI的实例
     * 通过`-onPOISearchDone:response:`回调方法获取检索结果
     * 点击POI查看详情


