//
//  RefreshHeadController.h
//  refreshController
//
//  Created by iLogiE MAC on 14-12-30.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZPRefreshStatusPull  = 0, 
    ZPRefreshStatusNomal,
    ZPRefreshStatusLoading,
    ZPRefreshStatusStopped,
} ZPRefreshStatus;

typedef enum : NSUInteger {
    ZPLoadMoreNomal =0,
    ZPLoadMoring,
    ZpLoadMored,
    ZPLoadMoreStatusLoad,
} ZPLoadMoreStatus;

@protocol RefreshHeadControllerDelegate <NSObject>

@optional
- (void)pullDownRefresh;

- (BOOL)hasRefreshFooterView;
- (void)loadMore;

@end

@interface RefreshHeadController : NSObject

@property (nonatomic,assign)id<RefreshHeadControllerDelegate> delegate;
- (id)initWithScrollView:(UIScrollView *)scrollView  delegate:(id)delegate;
- (void)endPullDownRefresh;
- (void)endPullUpLoading;
- (void)startPullDownRefresh;
@end
