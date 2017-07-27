//
//  BaseViewController.h
//  ScrollTableView
//
//  Created by admin on 2017/7/26.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollDelegate <NSObject>

- (void)tableViewDidScroll:(UITableView *)tableView;

@end

@interface BaseViewController : UITableViewController
@property (nonatomic, assign) CGFloat headViewHeight;
@property (nonatomic, weak) id<ScrollDelegate> delegate;
@end
