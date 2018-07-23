//
//  FeaturesCollectionViewController.m
//  MapxusMapSample
//
//  Created by Chenghao Guo on 2018/5/11.
//  Copyright © 2018年 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

@import HandyFrame;
#import "FeaturesCollectionViewController.h"
#import "FeatureCollectionViewCell.h"
#import "MenuViewController.h"
#import "Feature.h"
#import "SimpleMapViewController.h"
#import "XibBuildViewController.h"
#import "BuildingAndFloorChangeViewController.h"
#import "POIClickViewController.h"
#import "CameraChangeViewController.h"
#import "RestrictMapPanningViewController.h"
#import "DrawMarkerViewController.h"
#import "DrawCustomMarkerViewController.h"
#import "AnimateMapCameraViewController.h"
#import "DrawPolygonViewController.h"
#import "DrawPolygonWithHolesViewController.h"
#import "AnimateMarkerPositionViewController.h"
#import "RoutePlanningViewController.h"
#import "SearchBuildingNearbyViewController.h"
#import "SearchBuildingInBoundViewController.h"
#import "SearchBuildingByIdViewController.h"
#import "SearchBuildingGlobalViewController.h"
#import "SearchPOINearbyViewController.h"
#import "SearchPOIInBoundViewController.h"
#import "SearchPOIDetailByIdViewController.h"
#import "SearchPOIInBuildingViewController.h"
#import "DefaultStylesViewController.h"
#import "DisplayLocationViewController.h"


@interface FeaturesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MenuViewControllerDelegate, UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, assign) NSUInteger currentTitleIndex;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

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
    
    self.titleList = @[NSLocalizedString(@"Getting Started", nil),
                       NSLocalizedString(@"Styles", nil),
                       NSLocalizedString(@"Annotations", nil),
                       NSLocalizedString(@"Camera", nil),
                       NSLocalizedString(@"Listener", nil),
                       NSLocalizedString(@"Search Service", nil),
                       NSLocalizedString(@"Display location", nil)];
    // 默认选择第一项
    [self selectedMenuOnIndex:0];
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
#pragma mark end





#pragma mark - MenuViewControllerDelegate
- (void)selectedMenuOnIndex:(NSInteger)index
{
    self.currentTitleIndex = index;
    
    switch (index) {
        case 0:
            self.dataList = [Feature gettingStartedList];
            break;
        case 1:
            self.dataList = [Feature stylesList];
            break;
        case 2:
            self.dataList = [Feature annotationsList];
            break;
        case 3:
            self.dataList = [Feature cameraList];
            break;
        case 4:
            self.dataList = [Feature listenerList];
            break;
        case 5:
            self.dataList = [Feature searchServicesList];
            break;
        case 6:
            self.dataList = [Feature locationList];
            break;
        default:
            break;
    }
    self.pageControl.numberOfPages = self.dataList.count;
    [self.collectionView reloadData];
}

- (void)dismissComplete
{
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}
#pragma mark end





#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
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


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Feature *m = self.dataList[indexPath.row];
    switch (m.identifie) {
        case FeatureTypeSimpleMapView:
        {
            SimpleMapViewController *vc = [[SimpleMapViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDynamicallyBuild:
        {
            XibBuildViewController *vc = [[XibBuildViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeBuildingAndFloorChange:
        {
            BuildingAndFloorChangeViewController *vc = [[BuildingAndFloorChangeViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypePOIClickListener:
        {
            POIClickViewController *vc = [[POIClickViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeCameraChange:
        {
            CameraChangeViewController *vc = [[CameraChangeViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDrawMarker:
        {
            DrawMarkerViewController *vc = [[DrawMarkerViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDrawCustomMarkerIcon:
        {
            DrawCustomMarkerViewController *vc = [[DrawCustomMarkerViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeAnimateTheMapCamera:
        {
            AnimateMapCameraViewController *vc = [[AnimateMapCameraViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeRestrictMapPanning:
        {
            RestrictMapPanningViewController *vc = [[RestrictMapPanningViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDrawPolygon:
        {
            DrawPolygonViewController *vc = [[DrawPolygonViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDrawPolygonWithHoles:
        {
            DrawPolygonWithHolesViewController *vc = [[DrawPolygonWithHolesViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeAnimateMarkerPosition:
        {
            AnimateMarkerPositionViewController *vc = [[AnimateMarkerPositionViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeRoutePlanning:
        {
            RoutePlanningViewController *vc = [[RoutePlanningViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchBuildingNearby:
        {
            SearchBuildingNearbyViewController *vc = [[SearchBuildingNearbyViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchBuildingInBound:
        {
            SearchBuildingInBoundViewController *vc = [[SearchBuildingInBoundViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchBuildingDetailById:
        {
            SearchBuildingByIdViewController *vc = [[SearchBuildingByIdViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchBuildingGlobal:
        {
            SearchBuildingGlobalViewController *vc = [[SearchBuildingGlobalViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchPOINearby:
        {
            SearchPOINearbyViewController *vc = [[SearchPOINearbyViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchPOIInBound:
        {
            SearchPOIInBoundViewController *vc = [[SearchPOIInBoundViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchPOIDetailById:
        {
            SearchPOIDetailByIdViewController *vc = [[SearchPOIDetailByIdViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeSearchPOIInBuilding:
        {
            SearchPOIInBuildingViewController *vc = [[SearchPOIInBuildingViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeDefaultStyles:
        {
            DefaultStylesViewController *vc = [[DefaultStylesViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case FeatureTypeShowLocation:
        {
            DisplayLocationViewController *vc = [[DisplayLocationViewController alloc] init];
            vc.nameStr = m.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
