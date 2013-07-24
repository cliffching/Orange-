//
//  FirstViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface FirstViewController : UIViewController <SinaWeiboDelegate, SinaWeiboRequestDelegate, UITableViewDelegate>
//@interface FirstViewController : UIViewController <UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    UITableView *TableView;
    UITableViewController *tableViewController;
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
    NSMutableArray *_allItem;
}
- (CGSize)calculateHeigh:(NSString *)string;
@end
