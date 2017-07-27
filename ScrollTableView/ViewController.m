//
//  ViewController.m
//  ScrollTableView
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface ViewController ()<ScrollDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childVC;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, weak) UIButton *selectBtn;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, assign) CGFloat offsetY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.childVC = [[NSMutableArray alloc] init];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.scrollView = scrollView;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, 200)];
    [self.view addSubview:headView];
    _headView = headView;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这里可以放一些其他的视图";
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.bottom.offset(-44);
    }];
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor yellowColor];
    [headView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(label.mas_bottom);
    }];
    _titleView = titleView;

    
    CGFloat btnW = screenWidth / 3;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * i, 0, btnW, 44)];
        btn.tag = i + 100;
        if (i == 0) {
            btn.selected = YES;
            _selectBtn = btn;
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"按钮%d", i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
    }
    
    
    FirstViewController *first = [[FirstViewController alloc] init];
    SecondViewController *second = [[SecondViewController alloc] init];
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [self.childVC addObjectsFromArray:@[first, second, third]];
    self.scrollView.contentSize = CGSizeMake(screenWidth * self.childVC.count, 0);
}

- (void)buttonClick:(UIButton *)sender {
    if (sender == _selectBtn) return;
    _selectBtn.selected = NO;
    sender.selected = YES;
    _selectBtn = sender;
    [self changeViewWithIndex:sender.tag - 100];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeViewWithIndex:0];
}

- (void)changeViewWithIndex:(NSInteger)index {
    
    CGFloat height = self.scrollView.frame.size.height - 64;
    BaseViewController *vc = self.childVC[index];
    if (!vc.view.superview) {
        vc.delegate = self;
        vc.view.frame = CGRectMake(screenWidth * index, 0, screenWidth, height);
        vc.headViewHeight = 200;
        if (_offsetY <= 156) vc.tableView.contentOffset = CGPointMake(0, _offsetY);
        else {
            vc.tableView.contentOffset = CGPointMake(0, 156);
        }
        [self.scrollView addSubview:vc.view];
    }
     [self.scrollView setContentOffset:CGPointMake(index * screenWidth, -64) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / screenWidth;
    UIButton *btn = [_titleView viewWithTag:index + 100];
    [self buttonClick:btn];
}

- (void)tableViewDidScroll:(UITableView *)tableView {
    if (tableView.contentOffset.y <= 156) {
        for (BaseViewController *vc in _childVC) {
            if (tableView == vc.view) continue;
            UITableView *tbView = (UITableView *)vc.view;
            tbView.contentOffset = CGPointMake(0, tableView.contentOffset.y);
        }
        [self setHeadViewY:-tableView.contentOffset.y + 64];
    } else {
        for (BaseViewController *vc in _childVC) {
            if (tableView == vc.view) continue;
            UITableView *tbView = (UITableView *)vc.view;
            if (tbView.contentOffset.y > 156) continue;
            tbView.contentOffset = CGPointMake(0, 156);
        }
        [self setHeadViewY:-156 + 64];
    }
    
    if (tableView.contentOffset.y != 0) {
        _offsetY = tableView.contentOffset.y;
    }
}

- (void)setHeadViewY:(CGFloat)y {
    CGRect rect = _headView.frame;
    rect.origin.y = y;
    _headView.frame = rect;
}

@end
