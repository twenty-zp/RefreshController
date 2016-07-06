//
//  refreshHeadView.m
//  refreshController
//
//  Created by iLogiE MAC on 14-12-30.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import "refreshHeadView.h"

@implementation refreshHeadView

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel =[[UILabel alloc ]initWithFrame:CGRectMake(135,15, 160, 14)];
        _statusLabel.backgroundColor =[UIColor clearColor];
        _statusLabel.font =[UIFont systemFontOfSize:15.0f];
        _statusLabel.textColor =[UIColor blackColor];
    }
    return _statusLabel;
}


- (UILabel *)timeLabel
{
    
    if (!_timeLabel) {
        CGRect statusLabelFrame =_statusLabel.frame;
        statusLabelFrame.origin.y =CGRectGetMaxY(statusLabelFrame)+6;
        _timeLabel =[[UILabel alloc]initWithFrame:statusLabelFrame];
        _timeLabel.backgroundColor =[UIColor clearColor];
        _timeLabel.font =[UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor =[UIColor orangeColor];
    }
    return _timeLabel;
}
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped =NO;
           }
    return _activityView;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self ==[super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.statusLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.activityView];
    }
    return self;
}

@end
