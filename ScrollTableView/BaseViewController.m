//
//  BaseViewController.m
//  ScrollTableView
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)setHeadViewHeight:(CGFloat)headViewHeight {
    _headViewHeight = headViewHeight;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, headViewHeight)];
    self.tableView.tableHeaderView = view;
    
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        [_delegate tableViewDidScroll:self.tableView];
    }
}

@end
