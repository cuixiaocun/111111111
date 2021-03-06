//
//  ManageAddressTableVC.m
//  JingzhiForBusiness
//
//  Created by Admin on 2017/6/5.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "ManageAddressTableVC.h"
#import "ManageAddCell.h"
#import "AddAddressVC.h"
#import "IsTureAlterView.h"

@interface ManageAddressTableVC ()<ManageAddCellDelegate,IsTureAlterViewDelegate,AddAddressDelegate>
{

    NSIndexPath *index;
}

@end

@implementation ManageAddressTableVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //替代导航栏的imageview
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CXCWidth,Frame_NavAndStatus)];
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
    UILabel *navTitle =[[UILabel alloc] initWithFrame:CGRectMake(100*Width, Frame_rectStatus, 550*Width, Frame_rectNav)];
    [navTitle setText:@"收货地址管理"];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [navTitle setNumberOfLines:0];
    [navTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:navTitle];
    
    [self mainView];
}
- (void)mainView
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus, CXCWidth, CXCHeight-Frame_rectStatus-128*Width)];
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
      [self performSelector:@selector(getInfoList)];
    UIView *bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, CXCHeight-128*Width, CXCWidth, 128*Width)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    

    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressBtn setFrame:CGRectMake(40*Width,20*Width , 670*Width, 88*Width)];
    [addAddressBtn setBackgroundColor:NavColor];
    [addAddressBtn.layer setCornerRadius:4];
    [addAddressBtn.layer setMasksToBounds:YES];
    
    [addAddressBtn setTitle:@"新建地址" forState:UIControlStateNormal];
    [addAddressBtn setImage:[UIImage imageNamed:@"adress_btn_add"]  forState:UIControlStateNormal];
    [addAddressBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,34*Width)];

    [addAddressBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [addAddressBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:addAddressBtn];
    //横线
    UIImageView*xian =[[UIImageView alloc]init];
    xian.backgroundColor =BGColor;
    [bottomView addSubview:xian];
    xian.frame =CGRectMake(0,0, CXCWidth, 1.5*Width);
    

}
- (void)addAddressBtnAction
{
    AddAddressVC *addVC =[[AddAddressVC alloc]init];
    addVC.delegate =self;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClick:(UITableViewCell *)cell andTag:(int)tag
{
    index = [self.tableView indexPathForCell:cell];
    
    switch (tag) {
        case 110://换默认地址
        {
            NSLog(@"切换默认地址");
            [self setDefultAdress:(int)index.row];
            
            break;
        }
        case 111://编辑
        {
            NSLog(@"编辑");

            AddAddressVC *addVC =[[AddAddressVC alloc]init];
//            addVC.dic =infoArray[index.row] ;
            addVC.delegate =self;
            [self.navigationController pushViewController:addVC animated:YES];
            

        
        }
            break;
        case 112://删除
        {
            

            IsTureAlterView *isture =[[IsTureAlterView alloc]initWithTitile:@"确认要删除此地址吗？"];
            isture.delegate =self;
            isture.tag =180;

            [self.view addSubview:isture];
            NSLog(@"showalert");
            return;
            
            
        }
            break;
        default:
            break;
    }
    
    //刷新表格
    [self.tableView reloadData];
    
       
}

#pragma mark - IsTureAlterViewDelegate

-(void)cancelBtnActinAndTheAlterView:(UIView *)alter
{
    IsTureAlterView *isture = [self.view viewWithTag:180];
    [isture removeFromSuperview];
    NSLog(@"取消");
    
}
-(void)tureBtnActionAndTheAlterView:(UIView *)alter
{
    IsTureAlterView *isture = [self.view viewWithTag:180];
    [self deleteTheAdress];
    [isture removeFromSuperview];
    NSLog(@"确认");
    //删除
    
}
- (void)deleteTheAdress
{
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSString *url ;
    
    if ([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"HY"]) {
        [dic1 setDictionary:@{
                              @"id":[infoArray[index.row] objectForKey:@"id"] ,
                              }];
;
        url =@"Home/Address/remove";
    }else if([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"DL"])
    {
        [dic1 setDictionary:@{
                              @"id":[infoArray[index.row] objectForKey:@"id"] ,
                              }];
        url =@"home/address/agenremove";
        
    }

    [PublicMethod AFNetworkPOSTurl:url paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
            
            if ([[NSString stringWithFormat:@"%@",[infoArray[index.row] objectForKey:@"isdefault"]]isEqualToString:@"1"])
            {
                
                    NSMutableDictionary * memberDic  = [NSMutableDictionary dictionaryWithDictionary:[PublicMethod getDataKey:member]];
                    [memberDic setObject:@"<null>" forKey:@"addressid"];
                    [memberDic setObject:@"<null>" forKey:@"name_path"];
                    [memberDic setObject:@"<null>" forKey:@"address"];
                    [memberDic setObject:@"<null>" forKey:@"receivename"];
                    [memberDic setObject:@"<null>" forKey:@"phone"];
                    [PublicMethod saveData:memberDic withKey:member];
                    
              
            }
           
            for (int i=0; i<infoArray.count; i++) {
                [infoArray [i] setObject:@"2" forKey:@"isdefault"];
            }
            [infoArray removeObjectAtIndex:index.row];
            
            [self.tableView reloadData];


            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//        return infoArray.count ;
    return 10 ;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310*Width;
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSInteger row =[indexPath row];
    static NSString *CellIdentifier = @"Cell";
    ManageAddCell *cell =[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ManageAddCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier ];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;

    }
//        NSDictionary *dict = [infoArray objectAtIndex:row];
//        [cell setDic:dict];
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
    [self.tableView setFrame:CGRectMake(0,Frame_NavAndStatus, CXCWidth, CXCHeight-Frame_rectStatus  -128*Width)];
    
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
        currentPage = 1;
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.18f];
        ((DemoTableHeaderView *)self.headerView).arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
    }
    
    else{
        
        if ([hv.title.text isEqualToString:@"松开即可更新..."]) {
            currentPage = 1;
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
    
    currentPage=1;
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
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSString *url ;
    if ([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"HY"]) {
        [dic1 setDictionary:@{
//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]]
                              }];
        url =@"Home/address/index";
    }else if([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"DL"])
    {
        [dic1 setDictionary:@{
//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:agen] objectForKey:@"id"]]
                              }];
        url =@"home/address/agenindex";
    
    }
    
    [PublicMethod AFNetworkPOSTurl:url paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
        
             infoArray=[[dict objectForKey:@"data"] objectForKey:@"address_list"];
            [self.tableView reloadData];
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)setDefultAdress:(int)indexRow
{
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSString *url ;
    if ([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"HY"]) {
        [dic1 setDictionary:@{
                              @"id":[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[infoArray[indexRow] objectForKey:@"id"]]] ,
//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]]
                              }];
        url =@"Home/Address/setDefault";
    }else if([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"DL"])
    {
        [dic1 setDictionary:@{
                              @"id":[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[infoArray[indexRow] objectForKey:@"id"]]] ,

//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:agen] objectForKey:@"id"]]
                              }];
        url =@"home/address/agensetDefault";
        
    }

    
    [PublicMethod AFNetworkPOSTurl:url paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
            
            NSMutableDictionary * memberDic  = [NSMutableDictionary dictionaryWithDictionary:[PublicMethod getDataKey:member]];
            [memberDic setObject:[infoArray[indexRow] objectForKey:@"id"] forKey:@"addressid"];
            [memberDic setObject:[infoArray[indexRow] objectForKey:@"name_path"] forKey:@"name_path"];
            [memberDic setObject:[infoArray[indexRow] objectForKey:@"address"] forKey:@"address"];
            [memberDic setObject:[infoArray[indexRow] objectForKey:@"name"] forKey:@"receivename"];
            [memberDic setObject:[infoArray[indexRow] objectForKey:@"phone"] forKey:@"phone"];

            [PublicMethod saveData:memberDic withKey:member];
            
            for (int i=0; i<infoArray.count; i++) {
                [infoArray [i] setObject:@"2" forKey:@"isdefault"];
                
            }
            [infoArray [indexRow] setObject:@"1" forKey:@"isdefault"];

            [self.tableView reloadData];

            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}
-(void)needReloadDataAddress
{
    [self getInfoList];
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
