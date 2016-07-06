//
//  refreshHeadView.h
//  refreshController
//
//  Created by iLogiE MAC on 14-12-30.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface refreshHeadView : UIView
- (id)initWithFrame:(CGRect)frame;

/**
 * 刷新提示。
 */
@property (nonatomic,strong)UILabel *statusLabel;
/**
 *  刷新时间
 */
@property (nonatomic,strong)UILabel *timeLabel;
/**
 *  刷新圆圈
 */
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@end
