//
//  ViewController.m
//  refreshController
//
//  Created by iLogiE MAC on 14-12-30.
//  Copyright (c) 2014年 iLogiE MAC. All rights reserved.
//

#import "ViewController.h"
#import "RefreshHeadController.h"

#define allCount 5
#define cellIdentifier @"cellIdentifier"
@interface ViewController ()<RefreshHeadControllerDelegate>

@property (nonatomic,strong)RefreshHeadController *refresh;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,assign)int loadCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title =@"Refresh";
    _loadCount = 0;
       self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.refresh startPullDownRefresh];
}
- (void)pullDownRefresh
{
     [self performSelector:@selector(endRefresh) withObject:nil afterDelay:3];
    
}
- (BOOL)hasRefreshFooterView
{
    if (self.array.count>0 && _loadCount <allCount) {
        return YES;
    }
    return NO;
}

- (void)loadMore
{
    [self performSelector:@selector(endLoad) withObject:nil afterDelay:3];
}
- (void)endLoad
{
    _loadCount ++;
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"第%d次就加载更多,共%d次",_loadCount,allCount ],@"更多1",@"更多2",@"更多3", nil];
    [self.array addObjectsFromArray:data];
    [self.tableView reloadData];
    [self.refresh endPullUpLoading];
    
}
- (void)endRefresh
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithObjects:@"圣诞节撒的呢",@"那是你曾经开展农村",@"四川省你擦拭",@"删除MMC卡螺旋藻",@"飒飒大SD卡那是快乐的拉开",@"是你撒看见你的卡死你都看",@"萨达姆拉设计的",@"SD卡三季度",@"dsa9kdkfm",@"上次的事;分开拍151",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa",@"上次的事sasa", nil];
    self.array =data;
    [self.tableView reloadData];
    [self.refresh endPullDownRefresh];

}
- (RefreshHeadController *)refresh
{
    if (!_refresh) {
        _refresh =[[RefreshHeadController alloc]initWithScrollView:self.tableView delegate:self];
    }
    return _refresh;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text =self.array[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
