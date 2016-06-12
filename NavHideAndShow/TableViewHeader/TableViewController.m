//
//  TableViewController.m
//  TableViewHeader
//
//  Created by LiCheng on 16/6/8.
//  Copyright © 2016年 Li_Cheng. All rights reserved.
//

#import "TableViewController.h"

// 图片的高度
#define HEADER_HEIGHT self.view.frame.size.height / 4
#define MAIN_WIDTH self.view.frame.size.width

@interface TableViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置头部视图
    [self setUpHeaderImageView:[UIImage imageNamed:@"333.jpg"]];
    
    // 设置headerView
    [self setUpHeaderView];
    
}

#pragma mark - 创建头部图片
/**
 *   创建头部图片
 *
 *  @param image 背景图片
 */
-(void)setUpHeaderImageView:(UIImage *)image{
    
    // 头部图片
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0, -HEADER_HEIGHT, MAIN_WIDTH, HEADER_HEIGHT);
    
    // 让图片内容按原图的比例放缩
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // 创建一个 背景 View,与屏幕一样大小
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [bgView addSubview:self.imageView];
    self.tableView.backgroundView = bgView;
}

#pragma mark - 设置tableView的头部视图
-(void)setUpHeaderView{
    
    // 设置 tableHeaderView 并将背景色设置为透明
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEADER_HEIGHT)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    //去除导航条透明后导航条下的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"列表%zd",indexPath.row];
    return cell;
}

#pragma mark - 滚动视图代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 修改 imageView 的高
    CGRect frame = self.imageView.frame;
    
    CGFloat offsetY = self.tableView.contentOffset.y;
    
    if(offsetY > 0){ // 向上拉
        
        frame.origin.y = -offsetY;
        
    }else{ // 向下拉
        
        frame.origin.y = 0;
        frame.size.height = HEADER_HEIGHT - offsetY;
    }
    
    self.imageView.frame = frame;
    
    // 设置导航条的背景图片 其透明度随  alpha 值 而改变
    CGFloat alpha = offsetY/(HEADER_HEIGHT - 64);
    if (alpha > 1) {
        alpha = 1;
    }
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:0.227 green:0.753 blue:0.757 alpha:alpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 返回一张纯色图片
- (UIImage *)imageWithColor:(UIColor *)color{
    
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return theImage;
}

@end
