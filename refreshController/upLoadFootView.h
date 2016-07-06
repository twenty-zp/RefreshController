//
//  upLoadFootView.h
//  refreshController
//
//  Created by iLogiE MAC on 14-12-31.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface upLoadFootView : UIView

- (id)initWithFrame:(CGRect)frame;
//刷新操作提示
@property (nonatomic,strong)UILabel *statusLabel;

//刷新时间
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;


- (void)resetView;
@end
