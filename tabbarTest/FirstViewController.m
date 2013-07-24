//
//  FirstViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarAppDelegate.h"
#import "FirstViewController.h"
#import "tabbarAppDelegate.h"
#import "WeiBoData.h"
#import "UIImageView+WebCache.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FirstViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (SinaWeibo *)sinaweibo
{
    tabbarAppDelegate *delegate = (tabbarAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //每次更新需要重新重置_allItem
    _allItem=[[NSMutableArray alloc] init];
    
    //    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    //    [self.view addSubview:self.tableView];
    
    //    self.dataArray = [NSMutableArray array];
    
    for(int i = 0; i < 10; i++){
        
        //[self.dataArray addObject: [NSString stringWithFormat:@"cell %d", i]];
    }
    
    [self getHomeTimeline];
    // Do any additional setup after loading the view from its nib.
}

- (void)getUserTimeline
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)getHomeTimeline
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                       params:nil
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return 44.;
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    WeiBoData *wb=[_allItem objectAtIndex:indexPath.row];
    
    UILabel *text=(UILabel *)[cell.contentView viewWithTag:6];
    
    NSInteger height=text.frame.origin.y+text.frame.size.height+4;
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return [self.dataArray count];
    return [_allItem count];
    NSLog(@"%d条微博", [_allItem count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    // Configure the cell...
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MainCell" owner:nil options:nil] lastObject];
        
    }
    
    WeiBoData *wb=[_allItem objectAtIndex:indexPath.row];
    NSLog(@"正在显示第%d条微博", indexPath.row);
    CGSize size=[self calculateHeigh:wb.text];
    //用户头像
    UIImageView *myPic=(UIImageView*) [cell viewWithTag:1];
    
    if(wb.usrimg)
        [myPic setImageWithURL:[NSURL URLWithString: [wb.usrimg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    //用户名
    [(UILabel*) [cell viewWithTag:2] setText:wb.name];
    
    //微博内容
    UILabel *myText=(UILabel*) [cell viewWithTag:3];
    NSInteger offsetImg=0;
    //微博图片
    UIImageView *myImage=(UIImageView*) [cell viewWithTag:4];
    if (wb.imgUrl) {
        [myImage setImageWithURL:[NSURL URLWithString:[wb.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        //offsetImg=myImage.image.size.height-myImage.frame.size.height;
        //myImage.frame=CGRectMake(myImage.frame.origin.x, myImage.frame.origin.y, myImage.frame.size.width, myImage.image.size.height);
    }
    else
    {
        offsetImg=-myImage.frame.size.height;
        myImage.hidden=YES;
    }
    //来源
    UILabel *myCreat=(UILabel*) [cell viewWithTag:5];
    //转发
    UILabel *myRepost=(UILabel*) [cell viewWithTag:6];
    //评论
    UILabel *myComment=(UILabel*) [cell viewWithTag:7];
    
    
    //动态调整位置
    if (size.height!=myText.frame.size.height) {
        
        //NSInteger offsetY=size.height+2-myText.frame.size.height;
        //微博内容显示位置调整
        myText.frame=CGRectMake(myText.frame.origin.x, myText.frame.origin.y, myText.frame.size.width, size.height+2);
        
        //微博图片
        myImage.frame=CGRectMake(myImage.frame.origin.x,myText.frame.origin.y+myText.frame.size.height+2,myImage.frame.size.width,myImage.frame.size.height);
        
        //来源
        myCreat.frame=CGRectMake(myCreat.frame.origin.x,myImage.frame.origin.y+myImage.frame.size.height+2+offsetImg,myCreat.frame.size.width,myCreat.frame.size.height);
        myRepost.frame=CGRectMake(myRepost.frame.origin.x,myImage.frame.origin.y+myImage.frame.size.height+2+offsetImg,myRepost.frame.size.width,myRepost.frame.size.height);
        myComment.frame=CGRectMake(myComment.frame.origin.x,myImage.frame.origin.y+myImage.frame.size.height+2+offsetImg,myComment.frame.size.width,myComment.frame.size.height);
    }
    
    //微博内容
    [myText setText:wb.text];
    //来源
    NSString *strSource=wb.source;
    NSInteger location=[strSource rangeOfString:@">"].location+1;
    NSInteger length=[strSource rangeOfString:@"</"].location-location;
    NSString *strSou=[strSource substringWithRange:NSMakeRange(location, length)];
    [myCreat setText:strSou];
    //[(UILabel*) [cell viewWithTag:5] setText:wb.creat];
    
    //转发
    [myRepost setText:[NSString stringWithFormat:@"转发 %@",wb.repost]];
    //评论
    [myComment setText:[NSString stringWithFormat:@"评论 %@",wb.comment]];
    
    return cell;
    
}

- (CGSize)calculateHeigh:(NSString *)string;
{
    UIFont* font = [UIFont systemFontOfSize:17];
    
    //        - (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(UILineBreakMode)lineBreakMode;
    CGSize size = [string sizeWithFont:font
                     constrainedToSize:CGSizeMake(280.0f, CGFLOAT_MAX)
                         lineBreakMode:UILineBreakModeCharacterWrap];
    return size;
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release], userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release], statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release];
        userInfo = [result retain];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release];
        statuses = [[result objectForKey:@"statuses"] retain];
    }
    else if([request.url hasSuffix:@"statuses/home_timeline.json"])
    {
        [_allItem removeAllObjects];
        NSArray *statuses=[result objectForKey:@"statuses"];
        for(NSDictionary *d in statuses){
            WeiBoData *data=[[WeiBoData alloc] init];
            NSDictionary *duser=[d objectForKey:@"user"];
            
            data.usrimg=[duser objectForKey:@"profile_image_url"];
            data.name=[duser objectForKey:@"screen_name"];
            data.wid=[d objectForKey:@"id"];
            data.text=[d objectForKey:@"text"];
            data.imgUrl=[d objectForKey:@"bmiddle_pic"];
            data.creat=[d objectForKey:@"created_at"];
            data.source=[d objectForKey:@"source"];
            data.repost=[d objectForKey:@"reposts_count"];
            data.comment=[d objectForKey:@"comments_count"];
            
            [_allItem addObject:data];
            
            [data release];
        }
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postStatusText release], postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postImageStatusText release], postImageStatusText = nil;
    }
    
    //[self updateTableView];
    [_tableView reloadData];
}

//用来简易显示微博正文，无头像、发博人姓名、图片、转发等信息，仅用于测试。
- (void)updateTableView
{
    if (statuses)
    {
        if (statuses.count > 0)
        {
            for (int n = 0; statuses.count > n; n++) {
                NSString *boText = [[statuses objectAtIndex:n] objectForKey:@"text"];
                [self.dataArray addObject: [NSString stringWithFormat:@"%@", boText]];
                //[self.tableView reloadData];
            }
            
            
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"sssd%d",scrollView.contentOffset.y);
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    
    
    
    //NSLog(@"y%d",scrollView.bounds.origin.y);
    //上拉刷新
    //if (scrollView.contentOffset.y <= - 65.0f)
    //{
    //    NSLog(@"sss");
    //}
    //    if(scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom) <= -REFRESH_HEADER_HEIGHT && scrollView.contentOffset.y > 0){
    //        NSLog(@"scoll end");
    //    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*    DetailViewController *detailView=[[[DetailViewController alloc] init] autorelease];
     detailView.data=[_allItem objectAtIndex:indexPath.row];
     detailView.hidesBottomBarWhenPushed=YES;
     [self.navigationController pushViewController:detailView animated:YES];
     */
}


- (void)dealloc {
    [_tableView release];
    [_allItem release];
    [_tableView release];
    [super dealloc];
}

@end
