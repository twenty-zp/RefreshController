//
//  RefreshHeadController.m
//  refreshController
//
//  Created by iLogiE MAC on 14-12-30.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import "RefreshHeadController.h"
#import "refreshHeadView.h"
#import "upLoadFootView.h"
@interface RefreshHeadController()
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)refreshHeadView *headView;
@property (nonatomic,strong)upLoadFootView *footView;
@property (nonatomic,assign)CGFloat originalToInset;
@property (nonatomic, assign) BOOL isPullDownRefreshed;
@property (nonatomic,assign)BOOL isPullUpLoadMore;
@property (nonatomic,assign)ZPRefreshStatus refreshStatus;
@property (nonatomic, assign) BOOL pullDownRefreshing;
@property (nonatomic,assign)BOOL pullUpLoadMoring;

@property (nonatomic,assign)ZPLoadMoreStatus loadMoreStatus;
@end

@implementation RefreshHeadController

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id)delegate
{
    if (self ==[super init])
    {
        
        self.delegate=delegate;
        self.scrollView =scrollView;
        [self setup];
        
    }
    return self;
}
- (void)setup
{
    self.originalToInset =self.scrollView.contentInset.top;
    
    [self configuraObserverWithScrollView:self.scrollView];
    
    self.headView.timeLabel.text =@"刷新时间";
    self.headView.statusLabel.text =@"下拉刷新";
    self.refreshStatus=ZPRefreshStatusNomal;
    if (self.isPullDownRefreshed) {
        [self.scrollView addSubview:self.headView];
    }
    
}
- (BOOL)isPullUpLoadMore
{
    if ([self.delegate respondsToSelector:@selector(hasRefreshFooterView)]) {
        BOOL hasFootView =      [self.delegate hasRefreshFooterView];
        return hasFootView;
    }
    return NO;
}
- (void)callPullDownRefresh
{
    if ([self.delegate respondsToSelector:@selector(pullDownRefresh)]) {
        [self.delegate pullDownRefresh];
    }
}
- (void)callPullloadMoring
{
    if ([self.delegate respondsToSelector:@selector(loadMore) ]) {
        [self.delegate loadMore];
    }
}
/**
 *  结束刷新
 */
- (void)endPullDownRefresh
{
    
    if (self.isPullDownRefreshed) {
        NSLog(@"结束刷新使scrollView的UIEndgeInset重置，然后让其状态重新为normal");
        self.pullDownRefreshing =NO;
        self.refreshStatus =ZPRefreshStatusStopped;
 
    }
    
    [self resetScrollViewContentInset];
}
#pragma mark-
#pragma mark - SrollerView 下拉刷新后的 重置
- (void)resetScrollViewContentInset {
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.originalToInset;
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        
        self.refreshStatus = ZPRefreshStatusNomal;
        [self.headView.activityView stopAnimating];
    }];
}


- (void)endPullUpLoading
{
    if (!self.isPullUpLoadMore) {
        [self.footView removeFromSuperview];
        self.footView =nil;
    }
    self.pullUpLoadMoring =NO;
    [self resetScrollViewContentInsetWithDoneLoadMore];
}
#pragma mark-
#pragma mark - SrollerView 上拉加载更多后的 重置
- (void)resetScrollViewContentInsetWithDoneLoadMore {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        if (_footView) {
            self.loadMoreStatus = ZPLoadMoreNomal;
            CGRect tmpFrame = _footView.frame;
            tmpFrame.origin.y = self.scrollView.contentSize.height;
            _footView.frame = tmpFrame;
        }
    }];
}
- (BOOL)isPullDownRefreshed
{
    return YES;
}
- (refreshHeadView *)headView
{
    if (!_headView) {
        _headView =[[refreshHeadView alloc]initWithFrame:CGRectMake(0,-60, CGRectGetWidth([[UIScreen mainScreen] bounds]), 60)];
        _headView.backgroundColor =[UIColor clearColor];
        
    }
    return _headView;
}
- (upLoadFootView *)footView
{
    if (_footView ==nil) {
        _footView = [[upLoadFootView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 40)];
        _footView.backgroundColor =[UIColor clearColor];
        [self.scrollView addSubview:_footView];
        self.loadMoreStatus =ZPLoadMoreNomal;
        
    }
    return _footView;
}
- (void)setRefreshStatus:(ZPRefreshStatus)refreshStatus
{
    switch (refreshStatus) {
        case ZPRefreshStatusStopped:
//            [self.headView.activityView stopAnimating];
//            break;
        case ZPRefreshStatusNomal:
        {
           
            self.headView.statusLabel.text =@"下拉刷新";
        }
            
            break;
        case ZPRefreshStatusPull:
            self.headView .statusLabel.text =@"释放立即刷新";
            
            break;
        case ZPRefreshStatusLoading:
        {
            if (self.pullDownRefreshing) {
                self.headView.statusLabel.text=@"正在加载";
                [self setScrollViewContentInsetForLoading];
                [self.headView.activityView startAnimating];
                [self callPullDownRefresh];
            }

            
        }
            break;
            
        default:
            break;
    }
    
    _refreshStatus =refreshStatus;
}

- (void)setLoadMoreStatus:(ZPLoadMoreStatus)loadMoreStatus
{
    switch (loadMoreStatus) {
        case ZpLoadMored:
        case ZPLoadMoreNomal:
        {
            self.footView.statusLabel.text =@"上拉加载更多";
            [self.footView.indicatorView stopAnimating];
        }
            break;
       
        case ZPLoadMoring:
        {
            self.footView.statusLabel.text =@"加载中.... ";
            [self.footView.indicatorView startAnimating];
            if (self.pullUpLoadMoring) {
                [self callPullloadMoring];
            }

        }
            break;
        default:
            break;
    }
    if (_footView) {
        [_footView resetView];
    }
    _loadMoreStatus =loadMoreStatus;
}
//是否支持 ios7 这里暂时不支持
- (CGFloat)getAdaptorHeight {
//    if ([self.delegate respondsToSelector:@selector(keepiOS7NewApiCharacter)]) {
//        return ([self.delegate keepiOS7NewApiCharacter] ? 64 : 0);
//    } else {
        return 64;
//    }

}


- (void)startPullDownRefresh
{
    if (self.isPullDownRefreshed) {
        self.pullDownRefreshing =YES;
        self.refreshStatus =ZPRefreshStatusPull;
        self.refreshStatus =ZPRefreshStatusLoading;
    }
}
- (CGFloat)refreshTotalPixels {
    return 60 + [self getAdaptorHeight];
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if (self.refreshStatus == ZPRefreshStatusStopped) {
                             self.refreshStatus = ZPRefreshStatusNomal;
                             
                             if (self.headView.activityView) {
                                 [self.headView.activityView stopAnimating];
                             }
                         }
                     }];
}

- (void)setScrollViewContentInsetForLoading
{
    UIEdgeInsets currentInsets =self.scrollView.contentInset;
    currentInsets.top =self.refreshTotalPixels;
    [self setScrollViewContentInset:currentInsets];
}
- (void)configuraObserverWithScrollView:(UIScrollView *)scr
{
    [scr addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [scr addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scr addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset =[[change valueForKeyPath:NSKeyValueChangeNewKey] CGPointValue];
        if (self.isPullDownRefreshed) {
            if (self.refreshStatus !=ZPRefreshStatusLoading)
            {
                if (ABS(self.scrollView.contentOffset.y +[self getAdaptorHeight]) >= 20)
                {
                    
                    self.headView.activityView.center =CGPointMake(self.headView.center.x, 30);
                }
                CGFloat  scrollOffsetThreshold = -(60 + self.originalToInset);
                if (!self.scrollView.isDragging && self.refreshStatus ==ZPRefreshStatusPull)
                {
                    self.pullDownRefreshing =YES;
                    self.refreshStatus =ZPRefreshStatusLoading;
                    NSLog(@"加载");
                }else if (contentOffset.y< scrollOffsetThreshold && self.scrollView.isDragging && self.refreshStatus ==ZPRefreshStatusStopped)
                {
                    self.refreshStatus =ZPRefreshStatusPull;
                    NSLog(@"下拉");
                }else if (contentOffset.y >scrollOffsetThreshold && self.refreshStatus !=ZPRefreshStatusStopped )
                {
                    self.refreshStatus =ZPRefreshStatusStopped;
                    NSLog(@"停止");
                }
               
            }else
            {
//                CGFloat offset ;
//                UIEdgeInsets contentInset;
//                offset =MAX(self.scrollView.contentOffset.y *-1, 0.0f);
//                offset =MIN(offset,self.refreshTotalPixels);
//                contentInset =self.scrollView.contentInset;
//                self.scrollView.contentInset =UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
            }
        }
        
        if (self.isPullUpLoadMore)
        {
            if (self.loadMoreStatus !=ZPLoadMoring)
            {
                contentOffset.y += self.scrollView.bounds.size.height;
                float scrollContentSizeHeight =self.scrollView.contentSize.height+40;
               
                if (!self.scrollView.isDragging && contentOffset.y >scrollContentSizeHeight)
                {
                    self.pullUpLoadMoring =YES;
                    self.loadMoreStatus =ZPLoadMoring;

                }
                
            }else
            {
                if (self.pullUpLoadMoring)
                {
                    CGFloat offset;
                    UIEdgeInsets contentInset;
                    offset = 0;
                    offset = MAX(offset, 40);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                }
            }
        }
        
        
    }else if ([keyPath isEqualToString:@"contentInset"])
    {
        
    }else if ([keyPath isEqualToString:@"contentSize"])
    {
        BOOL hasFooterView = [self isPullUpLoadMore];
        if (hasFooterView) {
            CGRect tmpFrame = self.footView.frame;
            tmpFrame.origin.y = self.scrollView.contentSize.height;
            self.footView.frame = tmpFrame;
        }else {
            [self.footView removeFromSuperview];
            self.footView = nil;
        }
    }
}
- (void)removeObserverWithScrollView:(UIScrollView *)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}
- (void)dealloc {
    self.delegate = nil;
    [self removeObserverWithScrollView:self.scrollView];
    self.scrollView = nil;
    self.headView = nil;
//    self.refreshFooterView = nil;
}
@end
