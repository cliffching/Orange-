//
//  tabbarViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 88


@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@class tabbarView;

@interface tabbarViewController : UIViewController<SinaWeiboDelegate, tabbarDelegate>
{
    //仅做测试只用的按钮
    UIButton *loginButton;
    UIButton *logoutButton;
    UIButton *userInfoButton;
    UIButton *timelineButton;
    UIButton *postStatusButton;
    UIButton *postImageStatusButton;
    
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    NSString *postImageStatusText;
}
@property(nonatomic,strong) tabbarView *tabbar;
@property(nonatomic,strong) NSArray *arrayViewcontrollers;
@end



