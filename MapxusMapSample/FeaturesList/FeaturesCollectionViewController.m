//
//  FeaturesCollectionViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "FeaturesCollectionViewController.h"
#import "FeatureCollectionViewCell.h"
#import "MenuViewController.h"
#import "Feature.h"
#import "ParamConfigInstance.h"

@interface FeaturesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MenuViewControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) NSArray *subList;
@property (nonatomic, assign) NSUInteger currentTitleIndex;
@end


@implementation FeaturesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group"]];
    self.navigationItem.titleView = titleImg;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(showMenu)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //单例实现保存数据
    [ParamConfigInstance shared];
    
    self.titleList = @[NSLocalizedString(@"Map Creation", nil),
                       NSLocalizedString(@"Map Interaction", nil),
                       NSLocalizedString(@"Map Editing", nil),
                       NSLocalizedString(@"Indoor Positioning", nil),
                       NSLocalizedString(@"Search Service", nil),
                       NSLocalizedString(@"Integration Cases", nil),];
 
    self.subList = @[@[[Feature createWithPageClassName:@"CreateMapByCodeViewController"
                                              imageName:@"CreateMapByCode"
                                                  title:NSLocalizedString(@"Create map with code", nil)
                                               subTitle:NSLocalizedString(@"Create map with code.", nil)],
                       [Feature createWithPageClassName:@"CreateMapByXibViewController"
                                              imageName:@"CreateMapByXib"
                                                  title:NSLocalizedString(@"Create map with xib", nil)
                                               subTitle:NSLocalizedString(@"Create map with Interface Builder.", nil)],
                       [Feature createWithPageClassName:@"CreateMapWithSceneViewController"
                                              imageName:@"CreateMapWithScene"
                                                  title:NSLocalizedString(@"Create map (Specify the initial building, floor and building adaptive margin)", nil)
                                               subTitle:NSLocalizedString(@"To Maximize the specified building indoor map by the setting margin range and switch to the setting floor.", nil)],
                       [Feature createWithPageClassName:@"CreateMapWithPOIViewController"
                                              imageName:@"CreateMapWithPOI"
                                                  title:NSLocalizedString(@"Create map (Specify the initial POI and zoom level)", nil)
                                               subTitle:NSLocalizedString(@"To show the specified POI in the centre of the map and show the map by the setting zoom level when creating map.", nil)],
                     ],
                     @[[Feature createWithPageClassName:@"IndoorControlsViewController"
                                              imageName:@"IndoorControls"
                                                  title:NSLocalizedString(@"Interaction of indoor map controller", nil)
                                               subTitle:NSLocalizedString(@"Location of indoor map controllers.", nil)],
                       [Feature createWithPageClassName:@"MapAppearanceViewController"
                                              imageName:@"MapAppearance"
                                                  title:NSLocalizedString(@"Map style setting", nil)
                                               subTitle:NSLocalizedString(@"Modify map style, mark language and control outdoor map hiding.", nil)],
                       [Feature createWithPageClassName:@"RoutePainterSettingViewController"
                                              imageName:@"RoutePainterSetting"
                                                  title:NSLocalizedString(@"Route Style Setting", nil)
                                               subTitle:NSLocalizedString(@"Modify route style.", nil)],
                       [Feature createWithPageClassName:@"SwitchingBuildingGesturesViewController"
                                              imageName:@"SwitchingBuildingGestures"
                                                  title:NSLocalizedString(@"Gesture interaction for switching buildings", nil)
                                               subTitle:NSLocalizedString(@"Setting gestures for switching buildings.", nil)],
                       [Feature createWithPageClassName:@"SwitchingModelViewController"
                                              imageName:@"FocusOnIndoorScene"
                                                  title:NSLocalizedString(@"Mask venue mode", nil)
                                               subTitle:NSLocalizedString(@"Through building switching, the unselected buildings will present a mask effect.", nil)],
                       [Feature createWithPageClassName:@"FocusOnIndoorSceneViewController"
                                              imageName:@"FocusOnIndoorScene"
                                                  title:NSLocalizedString(@"Method interaction (Switching indoor scenes)", nil)
                                               subTitle:NSLocalizedString(@"Use code settings to focus on indoor scenes.", nil)],
                       [Feature createWithPageClassName:@"ClickEventListeningViewController"
                                              imageName:@"ClickEventListening"
                                                  title:NSLocalizedString(@"Click event listener", nil)
                                               subTitle:NSLocalizedString(@"Listener for click or long on the map, and click POI event.", nil)],
                       [Feature createWithPageClassName:@"SceneChangedEventListeningViewController"
                                              imageName:@"SceneChangedEventListening"
                                                  title:NSLocalizedString(@"Indoor scene switching event listener", nil)
                                               subTitle:NSLocalizedString(@"Listener for indoor scene switching events.", nil)],
                       [Feature createWithPageClassName:@"IndoorSceneInAndOutListeningViewController"
                                              imageName:@"IndoorSceneInAndOutListening"
                                                  title:NSLocalizedString(@"Get in or leave indoor scene event listener", nil)
                                               subTitle:NSLocalizedString(@"Listener for get in indoor or leave indoor scene.", nil)],
                     ],
                     @[[Feature createWithPageClassName:@"IndoorMarkerViewController"
                                              imageName:@"IndoorMarker"
                                                  title:NSLocalizedString(@"Drawing markers by floor", nil)
                                               subTitle:NSLocalizedString(@"Only display the markers on current floor.", nil)],
                       [Feature createWithPageClassName:@"IndoorPolygonViewController"
                                              imageName:@"IndoorPolygon"
                                                  title:NSLocalizedString(@"Drawing polygons by floor", nil)
                                               subTitle:NSLocalizedString(@"Only display the polygon on current floor.", nil)],
                     ],
                     @[[Feature createWithPageClassName:@"DisplayLocationViewController"
                                              imageName:@"DisplayLocation"
                                                  title:NSLocalizedString(@"Indoor positioning", nil)
                                               subTitle:NSLocalizedString(@"Show the positioning location and different following mode.", nil)],
                     ],
                     @[[Feature createWithPageClassName:@"SearchVenueGlobalViewController"
                                              imageName:@"SearchBuildingGlobal"
                                                  title:NSLocalizedString(@"Search venue globally", nil)
                                               subTitle:NSLocalizedString(@"Search venue globally.", nil)],
                       [Feature createWithPageClassName:@"SearchVenueInBoundViewController"
                                              imageName:@"SearchBuildingInBound"
                                                  title:NSLocalizedString(@"Search venue in the specified area", nil)
                                               subTitle:NSLocalizedString(@"Search venue in the specified rectangular area.", nil)],
                       [Feature createWithPageClassName:@"SearchVenueNearbyViewController"
                                              imageName:@"SearchBuildingNearby"
                                                  title:NSLocalizedString(@"Search venue nearby", nil)
                                               subTitle:NSLocalizedString(@"Search venue in the specified circular area.", nil)],
                       [Feature createWithPageClassName:@"SearchVenueByIDViewController"
                                              imageName:@"SearchBuildingByID"
                                                  title:NSLocalizedString(@"Search venue by venue ID", nil)
                                               subTitle:NSLocalizedString(@"Search venue by venue ID.", nil)],
                       [Feature createWithPageClassName:@"SearchBuildingGlobalViewController"
                                              imageName:@"SearchBuildingGlobal"
                                                  title:NSLocalizedString(@"Search building globally", nil)
                                               subTitle:NSLocalizedString(@"Search building globally.", nil)],
                       [Feature createWithPageClassName:@"SearchBuildingInBoundViewController"
                                              imageName:@"SearchBuildingInBound"
                                                  title:NSLocalizedString(@"Search building in the specified area", nil)
                                               subTitle:NSLocalizedString(@"Search building in the specified rectangular area.", nil)],
                       [Feature createWithPageClassName:@"SearchBuildingNearbyViewController"
                                              imageName:@"SearchBuildingNearby"
                                                  title:NSLocalizedString(@"Search building nearby", nil)
                                               subTitle:NSLocalizedString(@"Search building in the specified circular area.", nil)],
                       [Feature createWithPageClassName:@"SearchBuildingByIDViewController"
                                              imageName:@"SearchBuildingByID"
                                                  title:NSLocalizedString(@"Search building by building ID", nil)
                                               subTitle:NSLocalizedString(@"Search building by building ID.", nil)],
                       [Feature createWithPageClassName:@"CategoryIncludeInSceneViewController"
                                              imageName:@"CategoryIncludeInScene"
                                                  title:NSLocalizedString(@"Get the POI categories by building or floor", nil)
                                               subTitle:NSLocalizedString(@"Get all the POI categories of the specified building or floor.", nil)],
                       [Feature createWithPageClassName:@"SearchCategoryInBoundViewController"
                                              imageName:@"CategoryIncludeInScene"
                                                  title:NSLocalizedString(@"Get POI categories by Bbox", nil)
                                               subTitle:NSLocalizedString(@"Get all POI categories of a specified region.", nil)],
                       [Feature createWithPageClassName:@"SearchPOIInSceneViewController"
                                              imageName:@"SearchPOIInScene"
                                                  title:NSLocalizedString(@"Search POI in the specified scene", nil)
                                               subTitle:NSLocalizedString(@"Search POI in the specified scene.", nil)],
                       [Feature createWithPageClassName:@"SearchPOIInBoundViewController"
                                              imageName:@"SearchPOIInBound"
                                                  title:NSLocalizedString(@"Search POI in the specified area", nil)
                                               subTitle:NSLocalizedString(@"Search POI in the specified retangular area.", nil)],
                       [Feature createWithPageClassName:@"SearchPOINearbyViewController"
                                              imageName:@"SearchPOINearby"
                                                  title:NSLocalizedString(@"Search POI nearby", nil)
                                               subTitle:NSLocalizedString(@"Search POI in the specified circular area.", nil)],
                       [Feature createWithPageClassName:@"SearchPOIByIDViewController"
                                              imageName:@"SearchPOIByID"
                                                  title:NSLocalizedString(@"Search POI by POI ID", nil)
                                               subTitle:NSLocalizedString(@"Search POI by POI ID.", nil)],
                     ],
    ];
  NSMutableArray *mArray = [[NSMutableArray alloc]initWithArray:self.subList];
  [mArray addObject:[self integrationCasesSublist]];
  self.subList = mArray;
  // Default to Select 0
  [self selectedMenuOnIndex:0];
}

- (NSArray*)integrationCasesSublist{
  NSMutableArray *array = [[NSMutableArray alloc]initWithArray:@[
    [Feature createWithPageClassName:@"SurroundingIdentificationViewController" imageName:@"SurroundingIdentification" title:NSLocalizedString(@"Surrounding environment recognition", nil) subTitle:NSLocalizedString(@"Make a virtual location and identify POI information around the location.", nil)],
    [Feature createWithPageClassName:@"RouteViewController" imageName:@"Route" title:NSLocalizedString(@"Route planning and navigation", nil) subTitle:NSLocalizedString(@"Search the route between the starting point and end point, and show the road adsorption.", nil)]]
  ];
  if(![PARAM_CONFIG_FILE containsString:@"jp"])
  {
    [array addObject:[Feature createWithPageClassName:@"ShowVisualViewController" imageName:@"ShowVisual" title:NSLocalizedString(@"Visual map", nil) subTitle:NSLocalizedString(@"Integration of Visual map.", nil)]];
  }
  [array addObject:[Feature createWithPageClassName:@"SearchIntegrateViewController" imageName:@"SearchIntegrate" title:NSLocalizedString(@"Explore building", nil) subTitle:NSLocalizedString(@"Common case of POI search in the building.", nil)]];
  return array;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        if (self.dataList.count > 1) {
            NSInteger page = self.collectionView.contentOffset.x / self.view.bounds.size.width;
            self.pageControl.currentPage = page;
        }
    }
    
}

#pragma mark - event respond
- (void)showMenu
{
    [MenuViewController presentMenuViewControllerOnViewController:self withDelegate:self andTitles:self.titleList defaultSelect:self.currentTitleIndex];
}

#pragma mark - MenuViewControllerDelegate
- (void)selectedMenuOnIndex:(NSInteger)index
{
    self.currentTitleIndex = index;
    self.dataList = self.subList[index];
    self.pageControl.numberOfPages = self.dataList.count;
    [self.collectionView reloadData];
}

- (void)dismissComplete
{
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.dataList.count > indexPath.item) {
        Feature *m = self.dataList[indexPath.item];
        [cell refreshData:m];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Feature *m = self.dataList[indexPath.row];
    UIViewController *page = (UIViewController *)[[NSClassFromString(m.pageClassName) alloc] init];
    [page setTitle:m.title];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
