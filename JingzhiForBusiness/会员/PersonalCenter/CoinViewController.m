//
//  CoinViewController.m
//  家装
//
//  Created by Admin on 2017/9/15.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "CoinViewController.h"
#import "FundRecordCell.h"
@interface CoinViewController ()
{
    NSString *statuString;
    NSIndexPath *index;

}
@end

@implementation CoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //替代导航栏的imageview
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CXCWidth, Frame_NavAndStatus)];
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = NavColorWhite;
    [self.view addSubview:topImageView];
    //添加返回按钮
    UIButton *  returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(0, Frame_rectStatus, Frame_rectNav, Frame_rectNav);
    [returnBtn setImage:[UIImage imageNamed:navBackarrow] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:returnBtn];
    
    //注册标签
    UILabel *navTitle =[[UILabel alloc] initWithFrame:CGRectMake(200*Width, Frame_rectStatus, 350*Width, Frame_rectNav)];
    [navTitle setText:@"金币明细"];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [navTitle setNumberOfLines:0];
    [navTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:navTitle];
    //横线
    UIImageView*xian =[[UIImageView alloc]init];
    xian.backgroundColor =BGColor;
    [topImageView addSubview:xian];
    xian.frame =CGRectMake(0,Frame_NavAndStatus-1, CXCWidth, 1);

    [self mainView];
    
    
    
    
    
}
- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];


}
- (void)mainView
{

    UIView *topView =[[UIView alloc]initWithFrame:CGRectMake(0, Frame_NavAndStatus, CXCWidth, 85*Width)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];
    NSArray *btnArr =@[@"金币日志",@"充值记录",@"消费记录",];
    for (int i=0; i<3; i++) {
        UIButton *  statuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statuBtn.frame = CGRectMake(CXCWidth/3*i, 0,CXCWidth/3-2*Width ,85*Width);
        if (i==0) {
            statuBtn.selected =YES;
        }
             
        statuBtn.titleLabel.font =[UIFont boldSystemFontOfSize:14];
        [statuBtn setTitle:btnArr[i] forState:UIControlStateNormal];
        [statuBtn setTitleColor:TextGrayColor forState:UIControlStateNormal];
        [statuBtn setTitleColor:NavColor forState:UIControlStateSelected];
        statuBtn.tag =220+i;
        [statuBtn addTarget:self action:@selector(changeStatuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:statuBtn];
    }
    //可移动image
    
    UIImageView *imageview =[[UIImageView alloc] init];
    [imageview setTag:14];
    [imageview setBackgroundColor:NavColor];
    [imageview setFrame:CGRectMake(0, Frame_NavAndStatus+85*Width, CXCWidth/3, 3*Width)];
    [self.view addSubview:imageview];

    
    //横线
    UIImageView*xian =[[UIImageView alloc]init];
    xian.backgroundColor =BGColor;
    [topView addSubview:xian];
    xian.frame =CGRectMake(0,83.5*Width, CXCWidth, 1.5*Width);
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus+100*Width, CXCWidth, CXCHeight-100*Width-Frame_rectStatus)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView .showsVerticalScrollIndicator = NO;
    
    //下拉刷新
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableHeaderView" owner:self options:nil];
    DemoTableHeaderView *headerView = (DemoTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = headerView;
    //上拉加载
    nib = [[NSBundle mainBundle] loadNibNamed:@"DemoTableFooterView" owner:self options:nil];
    DemoTableFooterView *footerView = (DemoTableFooterView *)[nib objectAtIndex:0];
    self.footerView = footerView;
    infoArray = [[NSMutableArray alloc] init];
    //  [self performSelector:@selector(getInfoList)];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changeStatuBtn:(UIButton *)btn
{
    UIImageView *imageview =(UIImageView *)[self.view viewWithTag:14];
    
    [UIView animateWithDuration:0.15 animations:^{
        [imageview setFrame:CGRectMake(CXCWidth/3*(btn.tag-220), Frame_NavAndStatus+85*Width, CXCWidth/3, 3*Width)];
        
    }completion:^(BOOL finished){
        
    }];

    
    
    
    for (int i=0; i<5; i++) {
        UIButton *statuBtn =[self.view viewWithTag:220+i];
        statuBtn.selected=NO;
    }
    statuString =[NSString stringWithFormat:@"%ld",btn.tag-220];
    btn.selected =YES;
    
    currentPage=0;
    [self getInfoList];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return infoArray.count ;
    return 10 ;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  160*Width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =[indexPath row];
    static NSString *CellIdentifier = @"Cell";
    FundRecordCell *cell =[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FundRecordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier ];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
//    NSDictionary *dict = [infoArray objectAtIndex:row];
//    [cell setDic:dict];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    DeclarDetailVC *declar =[[DeclarDetailVC alloc]init];
    //    [self.navigationController pushViewController:declar animated:YES];
    
}
#pragma mark - Pull to Refresh
- (void) pinHeaderView
{
    [super pinHeaderView];
    
    // do custom handling for the header view
    DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"加载中...";
    [CATransaction begin];
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus+100*Width, CXCWidth, CXCHeight-Frame_rectStatus)];
    
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    ((DemoTableHeaderView *)self.headerView).arrowImage.hidden = YES;
    [CATransaction commit];;
}
- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    // do custom handling for the header view
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss a"];
    ((DemoTableHeaderView *)self.headerView).time.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:[NSDate date]]];
    [[(DemoTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    DemoTableHeaderView *hv = (DemoTableHeaderView *)self.headerView;
    if (willRefreshOnRelease){
        hv.title.text = @"松开即可更新...";
        currentPage = 0;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18f];
        ((DemoTableHeaderView *)self.headerView).arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
    }
    
    else{
        
        if ([hv.title.text isEqualToString:@"松开即可更新..."]) {
            currentPage = 0;
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.18f];
            ((DemoTableHeaderView *)self.headerView).arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
        
        hv.title.text = @"下拉即可刷新...";
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        ((DemoTableHeaderView *)self.headerView).arrowImage.hidden = NO;
        ((DemoTableHeaderView *)self.headerView).arrowImage.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
    
}
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    // Do your async call here
    // This is just a dummy data loader:
    [self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:0];
    
    
    // See -addItemsOnTop for more info on how to finish loading
    return YES;
}
#pragma mark - Load More

- (void) willBeginLoadingMore
{
    DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
    [fv.activityIndicator startAnimating];
}

- (void) loadMoreCompleted
{
    [super loadMoreCompleted];
    
    DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
    [fv.activityIndicator stopAnimating];
    
    if (!self.canLoadMore) {
        // Do something if there are no more items to load
        
        // We can hide the footerView by: [self setFooterViewVisibility:NO];
        
        // Just show a textual info that there are no more items to load
        fv.infoLabel.hidden = YES;
    }else{
        fv.infoLabel.hidden = NO;
    }
}
- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    
    [self performSelector:@selector(addItemsOnBottom) withObject:nil afterDelay:0];
    
    
    // Inform STableViewController that we have finished loading more items
    
    return YES;
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
    
    if (!isRefreshing && isDragging && scrollView.contentOffset.y < 0) {
        [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight]
                       scrollView:scrollView];
    } else if (!isLoadingMore && self.canLoadMore) {
        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
        //NSLog(@"%f====%f",scrollPosition,[self footerLoadMoreHeight]);
        if (scrollPosition < [self footerLoadMoreHeight] && scrollPosition > 20) {
            
            [fv.infoLabel setText:@"上拉加载更多..."];
        }else if(scrollPosition < 20){
            //[fv.infoLabel setText:@"释放开始加载..."];
            [fv.infoLabel setText:@"正在加载..."];
            [self loadMore];
        }
        
    }
}

#pragma mark - Dummy data methods
- (void) addItemsOnTop
{
    
    currentPage=0;
    [self performSelector:@selector(getInfoList) withObject:nil afterDelay:0];
    
    DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
    
    if (currentPage >= pageCount-1){
        self.canLoadMore = NO; // signal that there won't be any more items to load
    }else{
        self.canLoadMore = YES;
    }
    
    
    
    
    if (!self.canLoadMore) {
        fv.infoLabel.hidden = YES;
    }else{
        fv.infoLabel.hidden = NO;
    }
    
    
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    [self refreshCompleted];
}


- (void) addItemsOnBottom
{
    currentPage++;
    [self performSelector:@selector(getInfoList) withObject:nil afterDelay:0];
    
    
    if (currentPage >= pageCount-1)
        self.canLoadMore = NO; // signal that there won't be any more items to load
    else
        self.canLoadMore = YES;
    
    // Inform STableViewController that we have finished loading more items
    [self loadMoreCompleted];
}

- (void)getInfoList
{
    
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//    [dic1 setDictionary:@{
//                          @"currentPage":[NSString stringWithFormat:@"%ld",currentPage] ,
//                          //                          @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]],
//                          @"status":statuString
//                          //                          @"token":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"token"]]
//                          }
//     ];
//    
//    [PublicMethod AFNetworkPOSTurl:@"Home/OnlineOrder/myOrderList" paraments:dic1  addView:self.view success:^(id responseDic) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
//        
//        if (currentPage==0) {
//            [infoArray removeAllObjects];
//            
//        }
//        NSMutableArray *array=[dict objectForKey:@"data"];
//        if ([array isKindOfClass:[NSNull class]]) {
//            //                [PublicMethod setAlertInfo:@"暂无信息" andSuperview:self.view];
//            [self.tableView reloadData];
//            
//            return ;
//        }
//        
//        
//        [infoArray addObjectsFromArray:array];
//        
//        if ([infoArray count]==0 && currentPage==0) {
//            //                [PublicMethod setAlertInfo:@"暂无信息" andSuperview:self.view];
//            
//        }
//        pageCount =infoArray.count/20;
//        //判断是否加载更多
//        if (array.count==0 || array.count<20){
//            self.canLoadMore = NO; // signal that there won't be any more items to load
//        }else{
//            self.canLoadMore = YES;//要是分页的话就要改成yes并且把上面的currentPage=1注掉
//        }
//        
//        DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
//        [fv.activityIndicator stopAnimating];
//        
//        if (!self.canLoadMore) {
//            fv.infoLabel.hidden = YES;
//        }else{
//            fv.infoLabel.hidden = NO;
//        }
//        
//        
//        [self.tableView reloadData];
//        if (currentPage==0) {
//            //                [self.tableView setScrollsToTop:YES];
//            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//        
//        [self.tableView reloadData];
//        
//    } fail:^(NSError *error) {
//        
//    }];
//    
}

@end
