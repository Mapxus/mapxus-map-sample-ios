//
//  MXMPulleyViewController.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/28.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPulleyViewController.h"
#import "MXMPassThroughScrollView.h"

static CGFloat kMXMDefaultCollapsedHeight = 68.0f; //默认收起大小
static CGFloat kMXMDefaultPartialRevealHeight = 264.0f; //默认部分展开大小

static CGFloat kMXMBounceOverflowMargin = 20.0f;
static CGFloat kMXMDefaultDimmingOpacity = 0.5f;

static CGFloat kMXMDefaultShadowOpacity = 0.1f;
static CGFloat kMXMDefaultShadowRadius = 3.0f;

@interface MXMPulleyViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate, MXMPassThroughScrollViewDelegate>
@property (nonatomic, assign) CGPoint lastDragTargetContentOffSet; //记录上次滑动位置
@property (nonatomic, assign) BOOL isAnimatingDrawerPosition;

@property (nonatomic, strong) UIPanGestureRecognizer *pan; //滑动手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer; //点击手势，用于蒙层点击

@property (nonatomic, strong) UIView *primaryContentContainer; //主要内容容器视图
@property (nonatomic, strong) UIView *drawerContentContainer; //抽屉内容容器视图
@property (nonatomic, strong) MXMPassThroughScrollView *drawerScrollView; //抽屉滚动视图
@property (nonatomic, strong) UIView *drawerShadowView; //阴影

@property (nonatomic, strong) UIVisualEffectView *drawerBackgroundVisualEffectView; //毛玻璃效果

@property (nonatomic, strong) UIView *backgroundDimmingView; //黑色蒙层

@property (nonatomic, strong, readwrite) UIViewController<MXMPulleyPrimaryDelegate> *primaryContentViewController; //主视图VC
@property (nonatomic, strong, readwrite) UIViewController<MXMPulleyDrawerDelegate> *drawerContentViewController; //抽屉视图VC

@property (nonatomic, strong) NSSet <NSNumber *> *supportedPostions;
@end

@implementation MXMPulleyViewController

- (instancetype)initWithPrimaryContentViewController:(UIViewController<MXMPulleyPrimaryDelegate> *)primaryContentViewController
                         drawerContentViewController:(UIViewController<MXMPulleyDrawerDelegate> *)drawerContentViewController {
    self = [super init];
    if (self) {
        self.primaryContentViewController = primaryContentViewController;
        self.drawerContentViewController = drawerContentViewController;
        [self addChildViewController:primaryContentViewController];
        [self addChildViewController:drawerContentViewController];
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lastDragTargetContentOffSet = CGPointZero;
    
    [self.drawerScrollView addSubview:self.drawerShadowView];
    
    if (self.drawerBackgroundVisualEffectView) {
        [self.drawerScrollView insertSubview:self.drawerBackgroundVisualEffectView aboveSubview:self.drawerShadowView];
        self.drawerBackgroundVisualEffectView.layer.cornerRadius = [self p_cornerRadius];
    }
    
    [self.drawerScrollView addSubview:self.drawerContentContainer];
    
    self.drawerScrollView.showsVerticalScrollIndicator = NO;
    self.drawerScrollView.showsHorizontalScrollIndicator = NO;
    self.drawerScrollView.bounces = NO;
    self.drawerScrollView.canCancelContentTouches = YES;
    self.drawerScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.drawerScrollView.touchDelegate = self;
    
    self.drawerShadowView.layer.shadowOpacity = kMXMDefaultShadowOpacity;
    self.drawerShadowView.layer.shadowRadius = kMXMDefaultShadowRadius;
    self.drawerShadowView.backgroundColor = [UIColor clearColor];
    
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    self.pan.delegate = self;
    [self.drawerScrollView addGestureRecognizer:self.pan];
    
    [self.view addSubview:self.primaryContentContainer];
    [self.view addSubview:self.backgroundDimmingView];
    [self.view addSubview:self.drawerScrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.primaryContentContainer addSubview:self.primaryContentViewController.view];
    [self.primaryContentContainer sendSubviewToBack:self.primaryContentViewController.view];
    
    [self.drawerContentContainer addSubview:self.drawerContentViewController.view];
    [self.drawerContentContainer sendSubviewToBack:self.drawerContentViewController.view];
    
    self.primaryContentContainer.frame = self.view.bounds;
    
    CGFloat safeAreaTopInset;
    CGFloat safeAreaBottomInset;
    
    if (@available(iOS 11.0, *)) {
        safeAreaTopInset = self.view.safeAreaInsets.top;
        safeAreaBottomInset = self.view.safeAreaInsets.bottom;
    } else {
        safeAreaTopInset = self.topLayoutGuide.length;
        safeAreaBottomInset = self.bottomLayoutGuide.length;
    }
    
    if (@available(iOS 11.0, *)) {
        self.drawerScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.drawerScrollView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
    }
    NSMutableArray <NSNumber *> *drawerStops = [[NSMutableArray alloc] init];
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionCollapsed)]) {
        [drawerStops addObject:@([self collapsedHeight])];
    }
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionPartiallyRevealed)]) {
        [drawerStops addObject:@([self partialRevealDrawerHeight])];
    }
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionOpen)]) {
        [drawerStops addObject:@(self.drawerScrollView.bounds.size.height - kMXMTopInset - safeAreaTopInset)];
    }
    
    CGFloat lowestStop = [[drawerStops valueForKeyPath:@"@min.floatValue"] floatValue];
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionOpen)]) {
        self.drawerScrollView.frame = CGRectMake(0, kMXMTopInset + safeAreaTopInset, self.view.bounds.size.width, self.view.bounds.size.height - kMXMTopInset - safeAreaTopInset);
    } else {
        CGFloat adjustedTopInset = [self.supportedPostions containsObject:@(MXMPulleyPositionPartiallyRevealed)] ? [self partialRevealDrawerHeight] : [self collapsedHeight];
        self.drawerScrollView.frame = CGRectMake(0, self.view.bounds.size.height - adjustedTopInset, self.view.bounds.size.width, adjustedTopInset);
    }
    
    self.drawerContentContainer.frame = CGRectMake(0, self.drawerScrollView.bounds.size.height - lowestStop, self.drawerScrollView.bounds.size.width, self.drawerScrollView.bounds.size.height + kMXMBounceOverflowMargin);
    
    if (self.drawerBackgroundVisualEffectView) {
        self.drawerBackgroundVisualEffectView.frame = self.drawerContentContainer.frame;
    }
    
    self.drawerShadowView.frame = self.drawerContentContainer.frame;
    
    self.drawerScrollView.contentSize = CGSizeMake(self.drawerScrollView.bounds.size.width, (self.drawerScrollView.bounds.size.height - lowestStop) + self.drawerScrollView.bounds.size.height - safeAreaBottomInset);
    
    self.backgroundDimmingView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height + self.drawerScrollView.contentSize.height);
    
    if ([self p_needsCornerRadius]) {
        CGFloat cornerRadius = [self p_cornerRadius];
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.drawerContentContainer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path;
        layer.frame = self.drawerContentContainer.bounds;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.backgroundColor = [UIColor clearColor].CGColor;
        self.drawerContentContainer.layer.mask = layer;
        self.drawerShadowView.layer.shadowPath = path;
        
        self.drawerScrollView.transform = CGAffineTransformIdentity;
        self.drawerContentContainer.transform = self.drawerScrollView.transform;
        self.drawerShadowView.transform = self.drawerScrollView.transform;
        
        [self p_maskBackgroundDimmingView];
    }
    
    [self.backgroundDimmingView setHidden:NO];
    
    [self setDrawerPosition:MXMPulleyPositionCollapsed animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != self.drawerScrollView) { return; }
    
    NSMutableArray <NSNumber *> *drawerStops = [[NSMutableArray alloc] init];
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionCollapsed)]) {
        [drawerStops addObject:@([self collapsedHeight])];
    }
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionPartiallyRevealed)]) {
        [drawerStops addObject:@([self partialRevealDrawerHeight])];
    }
    
    if ([self.supportedPostions containsObject:@(MXMPulleyPositionOpen)]) {
        [drawerStops addObject:@(self.drawerScrollView.bounds.size.height)];
    }
    
    CGFloat lowestStop = [[drawerStops valueForKeyPath:@"@min.floatValue"] floatValue];
    
    
    if ([self.drawerContentViewController respondsToSelector:@selector(drawerDraggingProgress:)]) {
        
        CGFloat safeAreaTopInset;
        
        if (@available(iOS 11.0, *)) {
            safeAreaTopInset = self.view.safeAreaInsets.top;
        } else {
            safeAreaTopInset = self.topLayoutGuide.length;
        }
        
        CGFloat spaceToDrag = self.drawerScrollView.bounds.size.height - safeAreaTopInset - lowestStop;
        
        CGFloat dragProgress = fabs(scrollView.contentOffset.y) / spaceToDrag;
        if (dragProgress - 1 > FLT_EPSILON) { //in case greater than 1
            dragProgress = 1.0f;
        }
        NSString *p = [NSString stringWithFormat:@"%.2f", dragProgress];
        [self.drawerContentViewController drawerDraggingProgress:p.floatValue];
    }
    
    //蒙层颜色变化
    if ((scrollView.contentOffset.y - [self p_bottomSafeArea]) > ([self partialRevealDrawerHeight] - lowestStop)) {
        CGFloat progress;
        CGFloat fullRevealHeight = self.drawerScrollView.bounds.size.height;
        
        if (fullRevealHeight == [self partialRevealDrawerHeight]) {
            progress = 1.0;
        } else {
            progress = (scrollView.contentOffset.y - ([self partialRevealDrawerHeight] - lowestStop)) / (fullRevealHeight - [self partialRevealDrawerHeight]);
        }
        self.backgroundDimmingView.alpha = progress * kMXMDefaultDimmingOpacity;
        [self.backgroundDimmingView setUserInteractionEnabled:YES];
    } else {
        if (self.backgroundDimmingView.alpha >= 0.01) {
            self.backgroundDimmingView.alpha = 0.0;
            [self.backgroundDimmingView setUserInteractionEnabled:NO];
        }
    }
    
    self.backgroundDimmingView.frame = [self p_backgroundDimmingViewFrameForDrawerPosition:scrollView.contentOffset.y + lowestStop];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.drawerScrollView) {
        
        [self setDrawerPosition:[self p_postionToMoveFromPostion:self.currentPosition lastDragTargetContentOffSet:self.lastDragTargetContentOffSet scrollView:self.drawerScrollView supportedPosition:self.supportedPostions] animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.drawerScrollView) {
        self.lastDragTargetContentOffSet = CGPointMake(targetContentOffset->x, targetContentOffset->y);
        *targetContentOffset = scrollView.contentOffset;
    }
}

#pragma mark - UIPanGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)getsutre {
    
    if (!self.shouldScrollDrawerScrollView) { return; }
    
    if (getsutre.state == UIGestureRecognizerStateChanged) {
        CGPoint old = [getsutre translationInView:self.drawerScrollView];
        if (old.y < 0) { return; }
        CGPoint p = CGPointMake(0, self.drawerScrollView.frame.size.height - old.y - [self collapsedHeight]);
        self.lastDragTargetContentOffSet = p;
        [self.drawerScrollView setContentOffset:p];
    } else if (getsutre.state == UIGestureRecognizerStateEnded) {
        self.shouldScrollDrawerScrollView = NO;
        [self setDrawerPosition:[self p_postionToMoveFromPostion:self.currentPosition lastDragTargetContentOffSet:self.lastDragTargetContentOffSet scrollView:self.drawerScrollView supportedPosition:self.supportedPostions] animated:YES];
    }
}

#pragma mark - MXMDrawerScrollViewDelegate
- (void)drawerScrollViewDidScroll:(UIScrollView *)scrollView {
    //当drawer中的scroll view 的contentOffset.y 为 0时，触发drawerScrollView滚动
    if (CGPointEqualToPoint(scrollView.contentOffset, CGPointZero)) {
        self.shouldScrollDrawerScrollView = YES;
        [scrollView setScrollEnabled:NO];
        
    } else {
        self.shouldScrollDrawerScrollView = NO;
        [scrollView setScrollEnabled:YES];
    }
}

#pragma mark - MXMPassThroughScrollViewDelegate
- (BOOL)shouldTouchPassThroughScrollView:(MXMPassThroughScrollView *)scrollView atPoint:(CGPoint)point {
    CGPoint p = [self.drawerContentContainer convertPoint:point fromView:scrollView];
    return !CGRectContainsPoint(self.drawerContentContainer.bounds, p);
}

- (UIView *)viewToReceiveTouchOnScrollView:(MXMPassThroughScrollView *)scrollView atPoint:(CGPoint)point {
    if (self.currentPosition == MXMPulleyPositionOpen && self.backgroundDimmingView) {
        return self.backgroundDimmingView;
    }
    return self.primaryContentContainer;
}

#pragma mark - Getter and Setter
- (void)setPrimaryContentViewController:(UIViewController<MXMPulleyPrimaryDelegate> *)primaryContentViewController {
    
    if (!primaryContentViewController) { return; }
    _primaryContentViewController = primaryContentViewController;
}

- (void)setDrawerContentViewController:(UIViewController<MXMPulleyDrawerDelegate> *)drawerContentViewController {
    if (!drawerContentViewController) { return; }
    _drawerContentViewController = drawerContentViewController;
}

- (UIView *)drawerContentContainer {
    if (!_drawerContentContainer) {
        _drawerContentContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _drawerContentContainer.backgroundColor = [UIColor clearColor];
    }
    return _drawerContentContainer;
}

- (UIView *)drawerShadowView {
    if (!_drawerShadowView) {
        _drawerShadowView = [[UIView alloc] init];
    }
    return _drawerShadowView;
}

- (UIView *)primaryContentContainer {
    if (!_primaryContentContainer) {
        _primaryContentContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _primaryContentContainer.backgroundColor = [UIColor clearColor];
    }
    return _primaryContentContainer;
}

- (MXMPassThroughScrollView *)drawerScrollView {
    if (!_drawerScrollView) {
        _drawerScrollView = [[MXMPassThroughScrollView alloc] initWithFrame:self.drawerContentContainer.bounds];
        _drawerScrollView.delegate = self;
    }
    return _drawerScrollView;
}

- (UIView *)backgroundDimmingView {
    if (!_backgroundDimmingView) {
        if ([self.drawerContentViewController respondsToSelector:@selector(backgroundDimmingView)]) {
            _backgroundDimmingView = [self.drawerContentViewController backgroundDimmingView];
        }
        [_backgroundDimmingView setUserInteractionEnabled:NO];
        _backgroundDimmingView.alpha = 0.0;
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_dimmingTapGestureRecognizer:)];
        [_backgroundDimmingView addGestureRecognizer:_tapGestureRecognizer];
    }
    return _backgroundDimmingView;
}

- (UIVisualEffectView *)drawerBackgroundVisualEffectView {
    if (!_drawerBackgroundVisualEffectView) {
        if ([self.drawerContentViewController respondsToSelector:@selector(drawerBackgroundVisualEffectView)]) {
            _drawerBackgroundVisualEffectView = [self.drawerContentViewController drawerBackgroundVisualEffectView];
        }
    }
    return _drawerBackgroundVisualEffectView;
}

- (CGFloat)collapsedHeight {
    CGFloat collapsedHeight = kMXMDefaultCollapsedHeight;
    
    if ([self.drawerContentViewController respondsToSelector:@selector(collapsedDrawerHeight)]) {
        collapsedHeight = [self.drawerContentViewController collapsedDrawerHeight];
    }
    
    return collapsedHeight;
}

- (CGFloat)partialRevealDrawerHeight {
    CGFloat partialRevealDrawerHeight = kMXMDefaultPartialRevealHeight;
    if ([self.drawerContentViewController respondsToSelector:@selector(partialRevealDrawerHeight)]) {
        partialRevealDrawerHeight = [self.drawerContentViewController partialRevealDrawerHeight];
    }
    return partialRevealDrawerHeight;
}

- (void)setCurrentPosition:(MXMPulleyPosition)currentPosition {
    _currentPosition = currentPosition;
    //通知外部位置变化
    [_drawerContentViewController drawerPositionDidChange:self];
}

- (NSSet<NSNumber *> *)supportedPostions {
    if (!_supportedPostions) {
        if ([_drawerContentViewController respondsToSelector:@selector(supportPulleyPosition)]) {
            _supportedPostions = [_drawerContentViewController supportPulleyPosition];
        }
        if (!_supportedPostions) { //外层未返回，使用默认
            NSArray *array = @[@(MXMPulleyPositionOpen), @(MXMPulleyPositionClosed), @(MXMPulleyPositionCollapsed), @(MXMPulleyPositionPartiallyRevealed)];
            _supportedPostions = [NSSet setWithArray:array];
        }
    }
    return _supportedPostions;
}

#pragma mark - Private Mehtods
- (void)p_maskBackgroundDimmingView {
    
    if (!self.backgroundDimmingView) { return; }
    
    CGFloat cornerRadius = [self p_cornerRadius];
    CGFloat cutoutHeight = 2 * cornerRadius;
    CGFloat maskHeight = self.backgroundDimmingView.bounds.size.height - cutoutHeight - self.drawerScrollView.contentSize.height;
    CGFloat maskWidth = self.backgroundDimmingView.bounds.size.width;
    CGRect drawerRect = CGRectMake(0, maskHeight, maskWidth, self.drawerContentContainer.bounds.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:drawerRect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    [path appendPath:[UIBezierPath bezierPathWithRect:self.backgroundDimmingView.bounds]];
    [layer setFillRule:kCAFillRuleEvenOdd];
    
    layer.path = path.CGPath;
    self.backgroundDimmingView.layer.mask = layer;
}

- (CGFloat)p_bottomSafeArea {
    CGFloat safeAreaBottomInset;
    if (@available(iOS 11.0, *)) {
        safeAreaBottomInset = self.view.safeAreaInsets.bottom;
    } else {
        safeAreaBottomInset = self.bottomLayoutGuide.length;
    }
    return safeAreaBottomInset;
}

- (void)p_dimmingTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture == self.tapGestureRecognizer) {
        if (self.tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self setDrawerPosition:MXMPulleyPositionCollapsed animated:YES];
        }
    }
}

- (CGRect)p_backgroundDimmingViewFrameForDrawerPosition:(CGFloat)position {
    
    CGFloat cutoutHeight = 2 * [self p_cornerRadius];
    CGRect backgroundDimmingViewFrame = self.backgroundDimmingView.frame;
    backgroundDimmingViewFrame.origin.y = 0 - position + cutoutHeight;
    return backgroundDimmingViewFrame;
}

- (MXMPulleyPosition)p_postionToMoveFromPostion:(MXMPulleyPosition)currentPosition
                    lastDragTargetContentOffSet:(CGPoint)lastDragTargetContentOffSet
                                     scrollView:(UIScrollView *)scrollView
                              supportedPosition:(NSSet <NSNumber *> *)supportedPosition {
    
    NSMutableArray <NSNumber *> *drawerStops = [[NSMutableArray alloc] init];
    CGFloat currentDrawerPositionStop = 0.0f;
    
    if ([supportedPosition containsObject:@(MXMPulleyPositionCollapsed)]) {
        CGFloat collapsedHeight = [self collapsedHeight];
        [drawerStops addObject:@(collapsedHeight)];
        if (currentPosition == MXMPulleyPositionCollapsed) {
            currentDrawerPositionStop = collapsedHeight;
        }
    }
    
    if ([supportedPosition containsObject:@(MXMPulleyPositionPartiallyRevealed)]) {
        CGFloat partialHeight = [self partialRevealDrawerHeight];
        [drawerStops addObject:@(partialHeight)];
        if (currentPosition == MXMPulleyPositionPartiallyRevealed) {
            currentDrawerPositionStop = partialHeight;
        }
    }
    
    if ([supportedPosition containsObject:@(MXMPulleyPositionOpen)]) {
        CGFloat openHeight = scrollView.bounds.size.height;
        [drawerStops addObject:@(openHeight)];
        if (currentPosition == MXMPulleyPositionOpen) {
            currentDrawerPositionStop = openHeight;
        }
    }
    
    //取最小值
    CGFloat lowestStop = [[drawerStops valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat distanceFromBottomOfView = lowestStop + lastDragTargetContentOffSet.y;
    CGFloat currentClosestStop = lowestStop;
    
    MXMPulleyPosition cloestValidDrawerPosition = currentPosition;
    
    for (NSNumber *currentStop in drawerStops) {
        if (fabs(currentStop.floatValue - distanceFromBottomOfView) < fabs(currentClosestStop - distanceFromBottomOfView)) {
            currentClosestStop = currentStop.integerValue;
        }
    }
    
    if (fabs(currentClosestStop - (scrollView.frame.size.height)) <= FLT_EPSILON &&
        [supportedPosition containsObject:@(MXMPulleyPositionOpen)]) {
        
        cloestValidDrawerPosition = MXMPulleyPositionOpen;
        
    } else if (fabs(currentClosestStop - [self collapsedHeight]) <= FLT_EPSILON &&
               [supportedPosition containsObject:@(MXMPulleyPositionCollapsed)]) {
        
        cloestValidDrawerPosition = MXMPulleyPositionCollapsed;
        
    } else if ([supportedPosition containsObject:@(MXMPulleyPositionPartiallyRevealed)]){
        
        cloestValidDrawerPosition = MXMPulleyPositionPartiallyRevealed;
        
    }
    
    return cloestValidDrawerPosition;
}

- (void)setDrawerPosition:(MXMPulleyPosition)position
                   animated:(BOOL)animated {
    
    if (![self.supportedPostions containsObject:@(position)]) {
        return;
    }
    
    CGFloat stopToMoveTo;
    CGFloat lowestStop = [self collapsedHeight];
    if (position == MXMPulleyPositionCollapsed) {
        stopToMoveTo = lowestStop;
    } else if (position == MXMPulleyPositionPartiallyRevealed) {
        stopToMoveTo = [self partialRevealDrawerHeight];
    } else if (position == MXMPulleyPositionOpen) {
        if (self.backgroundDimmingView) {
            stopToMoveTo = self.drawerScrollView.frame.size.height;
        } else {
            stopToMoveTo = self.drawerScrollView.frame.size.height - kMXMDefaultShadowRadius;
        }
    } else { //close
        stopToMoveTo = 0.0f;
    }
    
    self.isAnimatingDrawerPosition = YES;
    self.currentPosition = position;
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.drawerScrollView setContentOffset:CGPointMake(0, stopToMoveTo - lowestStop) animated:NO];
        
        if (weakSelf.backgroundDimmingView) {
            weakSelf.backgroundDimmingView.frame = [weakSelf p_backgroundDimmingViewFrameForDrawerPosition:stopToMoveTo];
        }
        
    } completion:^(BOOL finished) {
        weakSelf.isAnimatingDrawerPosition = NO;
    }];
}

- (BOOL)p_needsCornerRadius {
    return [self p_cornerRadius] > FLT_EPSILON;
}

- (CGFloat)p_cornerRadius {
    if ([self.drawerContentViewController respondsToSelector:@selector(drawerCornerRadius)]) {
        return [self.drawerContentViewController drawerCornerRadius];
    }
    return 0.0f;
}

@end
