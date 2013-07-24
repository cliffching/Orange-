//
//  tabbarAppDelegate.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**将下面注释取消，并定义自己的app key，app secret以及授权跳转地址uri
 此demo即可编译运行**/

#define kAppKey             @"3602690368"
#define kAppSecret          @"ba22cebb61a6735b2094de3f9cb6bc5d"
#define kAppRedirectURI     @"http://weibo.com/cliffching"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

@class SinaWeibo;
@class tabbarViewController;

@interface tabbarAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) tabbarViewController *viewController;

@end
