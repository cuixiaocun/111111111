//
//  DiaryDetailListVC.m
//  家装
//
//  Created by Admin on 2017/9/18.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "DiaryDetailListVC.h"
#import "IsTureAlterView.h"
#import "DiaryDetailCell.h"
#import "EditDetailVC.h"
@interface DiaryDetailListVC ()<IsTureAlterViewDelegate,DiaryDetialDelegate>

@end

@implementation DiaryDetailListVC


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
    [navTitle setText:@"日记文章"];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [navTitle setNumberOfLines:0];
    [navTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:navTitle];
    
    UIButton *  withDrawlsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withDrawlsBtn.frame = CGRectMake(CXCWidth-100, 20, 84, 44);
    withDrawlsBtn.titleLabel.font =[UIFont boldSystemFontOfSize:13];
    [withDrawlsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [withDrawlsBtn setTitle:@"添加日记文章" forState:UIControlStateNormal];
    [withDrawlsBtn addTarget:self action:@selector(createDecorate) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:withDrawlsBtn];
    
    
    currentPage=0;
    
    [self getInfoList];
    
    [self mainView];
}
- (void)createDecorate
{
    EditDetailVC *edit =[[EditDetailVC alloc]init];
    [self.navigationController pushViewController:edit animated:YES];
}
- (void)mainView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus, CXCWidth, CXCHeight-Frame_rectStatus)];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.showsVerticalScrollIndicator = NO;
    
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
- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 ;
    //    return infoArray.count ;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 328*Width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =[indexPath row];
    static NSString *CellIdentifier = @"Cell";
    DiaryDetailCell *cell =[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DiaryDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier ];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    cell.delegate =self ;
    //    NSDictionary *dict = [infoArray objectAtIndex:row];
    //    [cell setDic:dict];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus, CXCWidth, CXCHeight-Frame_rectStatus)];
    
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
-(void)btnClick:(UITableViewCell *)cell andBtnActionTag:(NSInteger)tag
{
    //    index = [ self.tableView indexPathForCell:cell];
    
    switch (tag) {
        case 130:
        {
            //修改
            EditDetailVC *declar =[[EditDetailVC alloc]init];
                        //            declar.dic =infoArray[index.row];
            [self.navigationController pushViewController:declar animated:YES];
            
            break;
            
        }
        case 131:
        {
            //删除
                        IsTureAlterView *isture =[[IsTureAlterView alloc]initWithTitile:@"确认要删除此文章吗？"];
                        isture.delegate =self;
                        isture.tag =180;
                        [self.view addSubview:isture];
            
                        NSLog(@"");
            
            
            break;
            
        }
            
    }
}
#pragma mark - IsTureAlterViewDelegate
-(void)cancelBtnActinAndTheAlterView:(UIView *)alter
{
    if (alter.tag ==180)
    {
        [alter removeFromSuperview];
        NSLog(@"取消");
        
    }else if (alter.tag ==181)
    {
        [alter removeFromSuperview];
        NSLog(@"取消");
    }
    
}
-(void)tureBtnActionAndTheAlterView:(UIView *)alter
{
    
    if (alter.tag ==180)
    {
        [alter removeFromSuperview];
        NSLog(@"删除");
        [self cancelOrder];
        
    }else if (alter.tag ==181)
    {
        [alter removeFromSuperview];
        
        [self tureGetGoods];
        
        NSLog(@"收货");
        
    }
    
}
- (void)cancelOrder//取消订单
{
    //    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    //
    //    [dic1 setDictionary:@{
    //                          @"id":[[infoArray objectAtIndex:index.row ] objectForKey:@"id"],
    ////                          @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]]
    //                          }];
    //
    //    [PublicMethod AFNetworkPOSTurl:@"Home/OnlineOrder/cancel" paraments:dic1  addView:self.view success:^(id responseDic) {
    //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
    //        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
    //
    [MBProgressHUD showSuccess:@"删除成功" ToView:self.view];
    //            currentPage =0;
    //            [self getInfoList ];
    //        }
    //
    //    } fail:^(NSError *error) {
    //
    //    }];
    //
    
    
    
}
- (void)tureGetGoods//确认收货
{
    //    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    //
    //    [dic1 setDictionary:@{@"id":[[infoArray objectAtIndex:index.row ] objectForKey:@"id"],
    ////                          @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]]
    //                          }];
    //
    //    [PublicMethod AFNetworkPOSTurl:@"Home/OnlineOrder/receive" paraments:dic1  addView:self.view success:^(id responseDic) {
    //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
    //        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
    //
    [MBProgressHUD showSuccess:@"收货成功" ToView:self.view];
    //            currentPage =0;
    //            [self getInfoList ];
    //
    //        }
    //
    //    } fail:^(NSError *error) {
    //
    //    }];
    //
    //
    
}
- (void)getInfoList
{
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setDictionary:@{
                          @"currentPage":[NSString stringWithFormat:@"%ld",currentPage] ,
                          //                          @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]],
                          //                          @"token":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"token"]]
                          }
     ];
    
    [PublicMethod AFNetworkPOSTurl:@"Home/OnlineOrder/myOrderList" paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        
        if (currentPage==0) {
            [infoArray removeAllObjects];
            
        }
        NSMutableArray *array=[dict objectForKey:@"data"];
        if ([array isKindOfClass:[NSNull class]]) {
            //                [PublicMethod setAlertInfo:@"暂无信息" andSuperview:self.view];
            [self.tableView reloadData];
            
            return ;
        }
        
        
        [infoArray addObjectsFromArray:array];
        
        if ([infoArray count]==0 && currentPage==0) {
            //                [PublicMethod setAlertInfo:@"暂无信息" andSuperview:self.view];
            
        }
        pageCount =infoArray.count/20;
        //判断是否加载更多
        if (array.count==0 || array.count<20){
            self.canLoadMore = NO; // signal that there won't be any more items to load
        }else{
            self.canLoadMore = YES;//要是分页的话就要改成yes并且把上面的currentPage=1注掉
        }
        
        DemoTableFooterView *fv = (DemoTableFooterView *)self.footerView;
        [fv.activityIndicator stopAnimating];
        
        if (!self.canLoadMore) {
            fv.infoLabel.hidden = YES;
        }else{
            fv.infoLabel.hidden = NO;
        }
        
        
        [self.tableView reloadData];
        if (currentPage==0) {
            //                [self.tableView setScrollsToTop:YES];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        [self.tableView reloadData];
        
    } fail:^(NSError *error) {
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
