//
//  WeiBoData.m
//  MicroCloud
//
//  Created by cloud on 13-4-3.
//  Copyright (c) 2013年 cloud. All rights reserved.
//

#import "WeiBoData.h"

@implementation WeiBoData
@synthesize wid;
@synthesize name;
@synthesize usrimg;
@synthesize text;
@synthesize imgUrl;
@synthesize creat;
@synthesize source;
@synthesize repost;
@synthesize comment;
-(id) init
{
    if(self=[super init])
    {
        
    }
    return self;
}

-(void) dealloc
{
    [wid release];
    [name release];
    [usrimg release];
    [text release];
    [imgUrl release];
    [creat release];
    [source release];
    [repost release];
    [comment release];
    
    [super dealloc];
}
@end