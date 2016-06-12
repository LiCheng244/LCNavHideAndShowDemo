//
//  OtherViewController.h
//  TableViewHeader
//
//  Created by LiCheng on 16/6/12.
//  Copyright © 2016年 Li_Cheng. All rights reserved.
//

#import "OtherViewController.h"


@interface OtherViewController ()

@property (nonatomic, assign) CGFloat startY;
@property (nonatomic, assign) BOOL    isNowUp;
@property (nonatomic, assign) BOOL    isNowDown;
@property (nonatomic, assign) BOOL    isUserDrag;// 是用户拖拽 而不是系统反弹

@end

@implementation OtherViewController
#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [self imageWithColor:[UIColor colorWithRed:0.227 green:0.753 blue:0.757 alpha:1]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

}


#pragma mark - tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"列表%zd",indexPath.row];
    return cell;
}


#pragma mark - 只要在代理方法里面加上以下三个方法 进行处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    // 开始时,标记置真
    self.isUserDrag = YES;
    // 记录一下开始滚动的offsetY
    self.startY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // 结束时,置flag还原
    self.isUserDrag = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 只有用户drag时,才进行响应
    if(self.isUserDrag){
        // 判断一下
        CGFloat newY = scrollView.contentOffset.y;
        
        if(self.startY - newY > 0){ // 向上滚动
            
            if(!self.isNowUp){
                
                // 显示
                [UIView animateWithDuration:1 animations:^{
                    self.tabBarController.tabBar.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:3 animations:^{
                        self.navigationController.navigationBar.alpha = 1;
                    }];
                }];

                self.isNowUp   = YES;
                self.isNowDown = NO;
            }
            
        }else if(self.startY - newY < 0){ // 向下滚动
            
            if(!self.isNowDown){
                
                // 隐藏
                [UIView animateWithDuration:1 animations:^{
                    // 隐藏下导航
                    self.tabBarController.tabBar.transform = CGAffineTransformMakeTranslation(0, 49);
                    // 隐藏上导航
                    [UIView animateWithDuration:3 animations:^{
                        self.navigationController.navigationBar.alpha = 0;
                    }];
                }];
                self.isNowUp   = NO;
                self.isNowDown = YES;
            }
        }
        self.startY = scrollView.contentOffset.y;
    }
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