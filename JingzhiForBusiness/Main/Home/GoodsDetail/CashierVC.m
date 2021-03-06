//
//  CashierVC.m
//  JingzhiForBusiness
//
//  Created by Admin on 2017/6/19.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "CashierVC.h"
#import "CXCTwoLableSheet.h"
#import "ShoppingCartVC.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HYMyOrderVC.h"

@interface CashierVC ()<CXCTwoLableSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *bgScrollView;
}
@end

@implementation CashierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTheView) name:@"ZHIFUCHENGGONG" object:nil];

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
    [navTitle setText:@"心体荟收银台"];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [navTitle setNumberOfLines:0];
    [navTitle setTextColor:[UIColor whiteColor]];
    [self.view addSubview:navTitle];
    
    
    
    [self mainView];
}
-(void)returnBtnAction
{
     HYMyOrderVC*homeVC = [[HYMyOrderVC alloc] init];
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }else
    {
        UIViewController * viewVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
        
        [self.navigationController popToViewController:viewVC animated:YES];
    
    }

    
    
   
}

- (void)mainView
{
    bgScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, Frame_NavAndStatus,CXCWidth, CXCHeight-Frame_NavAndStatus )];
    [bgScrollView setUserInteractionEnabled:YES];
    [bgScrollView setBackgroundColor:BGColor];
    [self.view addSubview:bgScrollView];
    [bgScrollView setContentSize:CGSizeMake(CXCWidth, 1200*Width)];
    
    UIView *needPayView =[[UIView alloc]initWithFrame:CGRectMake(0,20*Width, CXCWidth, 83*Width)];
    needPayView.backgroundColor =[UIColor whiteColor];
    [bgScrollView addSubview:needPayView];
    
    
    UILabel *needPayLabel =[[UILabel alloc]initWithFrame:CGRectMake(24*Width,0, 200*Width,83*Width )];
    needPayLabel.text =@"需支付";
    needPayLabel.textColor =BlackColor;
    needPayLabel.font =[UIFont systemFontOfSize:14];
    [needPayView addSubview:needPayLabel];
    
    UILabel *payLabel =[[UILabel alloc]initWithFrame:CGRectMake(150*Width,0, 575*Width,83*Width )];
    payLabel.text =[NSString stringWithFormat:@"%.2f",[[_orderDic objectForKey:@"total"] floatValue]-[[_orderDic objectForKey:@"integral"] floatValue]];
    NSLog(@"%@",_orderDic);
    payLabel.textColor =NavColor;
    payLabel.textAlignment =NSTextAlignmentRight;
    payLabel.font =[UIFont systemFontOfSize:14];
    [needPayView addSubview:payLabel];
    _priceLabel =payLabel;
    
    UIButton *middleBgView =[[UIButton alloc]initWithFrame:CGRectMake(0, needPayView.bottom+20*Width, CXCWidth, 140*Width)];
    middleBgView.backgroundColor =[UIColor whiteColor];
    [bgScrollView   addSubview:middleBgView];
    [middleBgView addTarget:self action:@selector(showCXCActionSheetView) forControlEvents:UIControlEventTouchUpInside];
    UILabel*promLabel =[[UILabel alloc]initWithFrame:CGRectMake(24*Width,20*Width , 300*Width, 44*Width)];
    promLabel.text =@"支付方式";
    promLabel.textColor =BlackColor;
    promLabel.font =[UIFont systemFontOfSize:16];
    [middleBgView addSubview:promLabel];
    
    
    
    
    
    
//    //银行卡头像背景
//    UIImageView *cardPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(24*Width,promLabel.bottom+ 32*Width, 72*Width, 72*Width)];
//    cardPhoto.userInteractionEnabled = YES;
//    cardPhoto.tag =201;
//    cardPhoto.image =[UIImage imageNamed:@"withdrawcash_icon_bank_red"];
//    [middleBgView addSubview:cardPhoto];
    
    //名称
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(24*Width, promLabel.bottom+10*Width, 500*Width, 36*Width)];
    nameLabel.textColor =TextGrayColor;
    nameLabel.text =@"可选择支付宝支付、微信支付";
    nameLabel.tag =202;
    nameLabel.font =[UIFont systemFontOfSize:14];
    [middleBgView addSubview:nameLabel];
    
    
    
//    UILabel *defaultLabel=[[UILabel alloc]initWithFrame:CGRectMake(400*Width, nameLabel.top, 80*Width, 36*Width)];
//    defaultLabel.textColor =NavColor;
//    defaultLabel.text =@"默认";
//    defaultLabel.font =[UIFont systemFontOfSize:12];
//    [middleBgView addSubview:defaultLabel];
//    [defaultLabel.layer setCornerRadius:2*Width];
//    [defaultLabel.layer setBorderWidth:1.5*Width];
//    [defaultLabel.layer setMasksToBounds:YES];
//    defaultLabel.textAlignment =NSTextAlignmentCenter;
//    defaultLabel.layer.borderColor =NavColor.CGColor;
    

    
//    //银行卡号
//    UILabel *bankLabel =[[UILabel alloc]initWithFrame:CGRectMake(cardPhoto.right+20*Width, nameLabel.bottom+10*Width, 550*Width, 36*Width)];
//    bankLabel.textColor =BlackColor;
//    bankLabel.text =@"6223 9103 0116 0170";
//    bankLabel.tag =203;
//    bankLabel.font =[UIFont systemFontOfSize:14];
//    [middleBgView addSubview:bankLabel];
    //箭头
    UIImageView  *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(680*Width,50*Width,40*Width , 40*Width)];
    [middleBgView addSubview:jiantou];
    [jiantou setImage:[UIImage imageNamed:@"register_btn_nextPage"]];
    
    
 
    //下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(40*Width,440*Width , 670*Width, 88*Width)];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn.layer setCornerRadius:4];
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn setTitle:@"支付" forState:UIControlStateNormal];
    [nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [nextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [nextBtn addTarget:self action:@selector(surePayTheMoney) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:nextBtn];
    

}
- (void)surePayTheMoney
{
    
    UILabel *nameLabel= [self.view viewWithTag:202];
    if([nameLabel.text isEqualToString:@"支付宝支付"])
    {
        [self zhifubaoPay];
    
    }else if ([nameLabel.text isEqualToString:@"微信支付"])
    {
    
        [self ProPayRequest];
    }else
    {
    
        [MBProgressHUD showWarn:@"请选择支付方式" ToView:self.view];
        return;
        
    }
    
//    UILabel*defaultLabel =[self.view viewWithTag:33345];
//    defaultLabel.hidden =YES;
//    
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//    [dic1 setDictionary:@{
//                         @"orderid":[NSString stringWithFormat:@"%@",_orderId] ,
//                          }];
//    [PublicMethod AFNetworkPOSTurl:@"Home/Pay/notify" paraments:dic1  addView:self.view success:^(id responseDic) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
//        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
//            
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:[ShoppingCartVC  class]]) {
//                    //从购物车跳进去需要删除购物车里面的东西
//                    NSMutableArray* infoArr =[[NSMutableArray alloc]init];
//                    NSArray *arr =[PublicMethod getObjectForKey:shopingCart];
//                    [infoArr  addObjectsFromArray:arr];
//                    [ProgressHUD  showSuccess:@"支付成功"];
//                    
//                    //遍历一遍把购物车删除
//                    for (int i=0; i<infoArr.count; i++) {
//                        for (int j=0; j<_googsArr.count; j++) {
//                            NSMutableDictionary * mDict = [NSMutableDictionary dictionaryWithDictionary:infoArr[i]];
//                            NSMutableDictionary * jDict = [NSMutableDictionary dictionaryWithDictionary:_googsArr[j]];
//                            
//                            //商品ID暂设为1
//                            if ([[mDict objectForKey:@"goodID"]isEqualToString:[jDict objectForKey:@"goodID"]]) {
//                                //先删除后保存
//                                [infoArr removeObjectAtIndex:i];
//                                [PublicMethod setObject:infoArr key:shopingCart];
//                                [self.navigationController  popToRootViewControllerAnimated:YES];
//                                
//                                
//                            }
//                            
//                        }
//                        
//                        
//                    }
//                    
//                    
//                    
//                    
//                }else
//                {
//                    //从其他地方
//                    [self.navigationController  popToRootViewControllerAnimated:YES];
//                    
//                }
//            }
            
//        }
//
//    } fail:^(NSError *error) {
//        
//    }];
//
//    
//        
//    NSMutableArray* infoArr =[[NSMutableArray alloc]init];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showCXCActionSheetView
{
//    CXCTwoLableSheet *sheet =[[CXCTwoLableSheet alloc]initWithFrame:CGRectMake(0, 0, CXCWidth, CXCHeight) with:@[@[@"潍坊银行",@"62239050849068308690468"],@[@"中国银行",@"3243905864390608593"],@[@"中国银行",@"3243905864390608593"],@[@"中国银行",@"3243905864390608593"],@[@"潍坊银行",@"62239050849068308690468"],@[@"中国银行",@"3243905864390608593"],@[@"潍坊银行",@"62239050849068308690468"],@[@"中国银行",@"3243905864390608593"],]];
//    sheet.tag=1111;
//    sheet.delegate=self;
//    [self.view addSubview:sheet];
    
    {
        if(!_selectPayTypeTableView)
        {
            
            self.shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CXCWidth, CXCHeight)];
            self.shadowImage.backgroundColor =[UIColor blackColor];
            _shadowImage.alpha =0.3;
            [self.view addSubview:self.shadowImage];
            //支付方式列表
            self.selectPayTypeTableView = [[UITableView alloc] init];
            self.selectPayTypeTableView.delegate = self;
            self.selectPayTypeTableView.dataSource = self;
            self.selectPayTypeTableView.scrollEnabled = NO;
            self.selectPayTypeTableView.showsVerticalScrollIndicator = NO;
            self.selectPayTypeTableView.backgroundColor = [UIColor whiteColor];
            self.selectPayTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:self.selectPayTypeTableView];
            _selectPayTypeTableView.frame =CGRectMake(0, CXCHeight-800*Width, CXCWidth, 800*Width);
            
        }
        
        self.shadowImage.hidden = NO;
        self.selectPayTypeTableView.hidden = NO;
        //    [self.selectPayTypeTableView reloadData];
//        UILabel *lab =[self.view viewWithTag:333];
//        lab.text =_priceLabel.text;
        //    lab.text =@"2";
        
    }
    
}
- (void)btnClickName:(NSString *)nameString andBankNumber:(NSString *)bankNum
{
    UILabel *nameLabel= [self.view viewWithTag:202];
    [nameLabel setText:nameString];
    
    UILabel *numberLabel= [self.view viewWithTag:203];
    [numberLabel setText:bankNum];
    
    UIView *view= [self.view viewWithTag:1111];
    [view removeFromSuperview];
    
    
    
}
-(void)hiddenCXCActionSheet
{
    UIView *view= [self.view viewWithTag:1111];
    [view removeFromSuperview];
    UILabel *nameLabel= [self.view viewWithTag:202];
    [nameLabel setText:@"请选择"];
    
    UILabel *numberLabel= [self.view viewWithTag:203];
    [numberLabel setText:@"请选择"];
    
    
    
}
//高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0)
        {
            return 96*Width;
        }
        else if (indexPath.row == 1)
        {
            return 220*Width;
        }
        else
            return 135*Width;
}
//组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//每组（section）有几行（row）
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 5;
}
//设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        static NSString *ID = @"cellPPCId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.textColor = [UIColor colorWithRed:0.620 green:0.620 blue:0.620 alpha:1.00];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.620 green:0.620 blue:0.620 alpha:1.00];
        
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        //分割线
        
        
        if (indexPath.row == 0)
        {
            UILabel *detailabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CXCWidth, 96*Width)];
            [cell.contentView addSubview:detailabel];
            detailabel.text =@"请选择支付方式";
            detailabel.textAlignment =NSTextAlignmentCenter;
            detailabel.textColor =TextColor;
            detailabel.font =[UIFont systemFontOfSize:14];
            detailabel.textAlignment =NSTextAlignmentCenter;
            
            //x按钮
            self.detelBtn = [[UIButton alloc] initWithFrame:CGRectMake(690*Width, 32*Width, 30*Width, 30*Width)];
            [self.detelBtn setBackgroundImage:[UIImage imageNamed:@"pay_icon_close"] forState:UIControlStateNormal];
            [self.detelBtn setBackgroundImage:[UIImage imageNamed:@"pay_icon_close"] forState: UIControlStateSelected];
            [cell.contentView addSubview:self.detelBtn];
            [self.detelBtn addTarget:self action:@selector(hiddenBtn) forControlEvents:UIControlEventTouchUpInside];
            self.detelBtn.backgroundColor = [UIColor clearColor];
            
            
            UIImageView *segmentationImmage = [[UIImageView alloc] init];
            segmentationImmage.backgroundColor = BGColor;
            [cell.contentView addSubview:segmentationImmage];
            segmentationImmage.frame =CGRectMake(0, 95*Width, CXCWidth, Width);
        }
        else if (indexPath.row == 1)
        {
            UILabel *monayL =[[UILabel alloc]initWithFrame:CGRectMake(0, 40*Width, CXCWidth, 80*Width)];
            [cell.contentView addSubview:monayL];
            monayL.text =_priceLabel.text;
            NSString *str =_priceLabel.text;
            monayL.textColor =NavColor;
            monayL.tag =333;
            monayL.textAlignment =NSTextAlignmentCenter;
            //            NSMutableAttributedString *sendMessageString = [[NSMutableAttributedString alloc] initWithString:_priceLabel.text];
            
            //            monayL.backgroundColor =[UIColor redColor];
            monayL.font =[UIFont systemFontOfSize:25];
            //            NSLog(@"%d",_priceLabel.text.length);
            //
            NSMutableAttributedString *sendMessageString = [[NSMutableAttributedString alloc] initWithString:str];
            monayL.font =[UIFont systemFontOfSize:25];
            [sendMessageString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(str.length-3,3)];
            monayL.attributedText =sendMessageString;
            
            UILabel *detailabel =[[UILabel alloc]initWithFrame:CGRectMake(0, monayL.bottom, CXCWidth, 50*Width)];
            [cell.contentView addSubview:detailabel];
            detailabel.text =@"支付金额";
            detailabel.textAlignment =NSTextAlignmentCenter;
            detailabel.textColor =TextColor;
            detailabel.font =[UIFont systemFontOfSize:14];
            UIImageView *segmentationImmage = [[UIImageView alloc] init];
            segmentationImmage.backgroundColor = BGColor;
            [cell.contentView addSubview:segmentationImmage];
            segmentationImmage.frame =CGRectMake(0,219*Width, CXCWidth, Width);
        }
        else if (indexPath.row == 2)
        {
            
            self.orderType = @"alipay";
            //图标
            UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(32*Width, 32*Width, 70*Width, 70*Width)];
            headImage.image = [UIImage imageNamed:@"pay_icon_alipay"];
            [cell.contentView addSubview:headImage];
            //方式
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = @"支付宝支付";
            nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
            [cell.contentView addSubview:nameLabel];
            nameLabel.frame =CGRectMake(headImage.right+24*Width,32*Width, 300*Width, 40*Width);
            
            //描述
            UILabel *promptLabel = [[UILabel alloc] init];
            promptLabel.text = @"支持有支付宝账号的用户使用";
            promptLabel.textColor = [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1.00];
            promptLabel.font = [UIFont fontWithName:@"Arial" size:12];
            [cell.contentView addSubview:promptLabel];
            
            promptLabel.frame =CGRectMake(headImage.right+24*Width,nameLabel.bottom, 600*Width, 40*Width);
            //            cell.contentView.backgroundColor =[UIColor blueColor];
            
            UIImageView  *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(680*Width, 25*Width,30*Width , 50*Width)];
            [cell addSubview:jiantou];
            [jiantou setImage:[UIImage imageNamed:@"icon_shezhi_next"]];
            UIImageView *segmentationImmage = [[UIImageView alloc] init];
            segmentationImmage.backgroundColor = BGColor;
            [cell.contentView addSubview:segmentationImmage];
            segmentationImmage.frame =CGRectMake(0, 134*Width, CXCWidth, Width);
        }
        else if (indexPath.row == 3)
        {
            
            //图标
            UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(32*Width, 32*Width, 70*Width, 70*Width)];
            headImage.image = [UIImage imageNamed:@"pay_icon_weChat"];
            [cell.contentView addSubview:headImage];
            //方式
            UILabel *nameLabel = [[UILabel alloc] init];
            nameLabel.textColor = [UIColor blackColor];
            nameLabel.text = @"微信支付";
            nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
            [cell.contentView addSubview:nameLabel];
            //描述
            UILabel *promptLabel = [[UILabel alloc] init];
            promptLabel.text = @"推荐已安装微信的用户使用";
            promptLabel.textColor = [UIColor colorWithRed:0.451 green:0.451 blue:0.451 alpha:1.00];
            promptLabel.font = [UIFont fontWithName:@"Arial" size:12];
            [cell.contentView addSubview:promptLabel];
            nameLabel.frame =CGRectMake(headImage.right+24*Width,32*Width, 300*Width, 40*Width);
            promptLabel.frame =CGRectMake(headImage.right+24*Width,nameLabel.bottom, 600*Width, 40*Width);
            UIImageView  *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(680*Width, 25*Width,30*Width , 50*Width)];
            [cell addSubview:jiantou];
            [jiantou setImage:[UIImage imageNamed:@"icon_shezhi_next"]];
            UIImageView *segmentationImmage = [[UIImageView alloc] init];
            segmentationImmage.backgroundColor = BGColor;
            [cell.contentView addSubview:segmentationImmage];
            segmentationImmage.frame =CGRectMake(0,134*Width, CXCWidth, Width);
        }
            return cell;
}
//tableview点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    
        [self hiddenBtn];
    }
           if (indexPath.row == 2)
        {
            self.selectPayTreasureButton.hidden = NO;
            self.selectWeChatButton.hidden = YES;
            self.orderType = @"alipay";
            UILabel *nameLabel= [self.view viewWithTag:202];
            [nameLabel setText:@"支付宝支付"];
//            [self ProPayRequest];
            
//            [self zhifubaoPay];
            
            self.shadowImage.hidden = YES;
            self.selectPayTypeTableView.hidden = YES;

        }
        else if (indexPath.row == 3)
        {
            UILabel *nameLabel= [self.view viewWithTag:202];
            [nameLabel setText:@"微信支付"];
            self.shadowImage.hidden = YES;
            self.selectPayTypeTableView.hidden = YES;

            self.selectPayTreasureButton.hidden = YES;
            self.selectWeChatButton.hidden = NO;
            self.orderType = @"wx";
//            [self ProPayRequest];
    
        }else
        {
            return;
        
        }
}
- (void)ProPayRequest
{
           /*需要改变*/
    //
    self.shadowImage.hidden = YES;
    self.selectPayTypeTableView.hidden = YES;
    

    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setDictionary:@{
                          @"orderid":[NSString stringWithFormat:@"%@",_orderId] ,
                          }];
    [PublicMethod AFNetworkPOSTurl:@"Home/PayWx/getAppPay" paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
            NSDictionary*dictionary = [[dict  objectForKey:@"data"] objectForKey:@"ios"];
            
            if(dictionary != nil){
                NSMutableString *retcode = [dictionary objectForKey:@"return_code"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [dictionary objectForKey:@"timeStamp"];
                    NSString *demostr =[NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%@",
                                        [dictionary objectForKey:@"appid"],
                                        [dictionary objectForKey:@"nonce_str"],
                                        @"Sign=WXPay",
                                        [dictionary objectForKey:@"mch_id"],
                                        [dictionary objectForKey:@"prepay_id"],
                                        [NSString stringWithFormat:@"%ld",(long)stamp.intValue]
                                        ];
                    NSLog(@"demostr = %@",demostr);
                    NSString *stringA=[NSString stringWithFormat:@"%@&key=%@",demostr,@"2ba002adc916888ce5c4558e2d7736f4"];
                    NSString *stringB = [PublicMethod md5:stringA];
                    NSString *stringC = stringB.uppercaseString;
                    NSLog(@"%@",stringC);
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dictionary objectForKey:@"mch_id"];
                    req.prepayId            = [dictionary objectForKey:@"prepay_id"];
                    req.nonceStr            = [dictionary objectForKey:@"nonceStr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = @"Sign=WXPay";
//                    req.sign               = stringC;
                    req.sign                = [dictionary objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    
                    NSLog(@"chenggonglema%d",[WXApi sendReq:req]);
                }else{
                    //return [dict objectForKey:@"retmsg"];
                    NSLog(@"2222");
                }
            }else{
                //return @"服务器返回错误， 未获取到json对象";
                NSLog(@"3333");
            }

        }
        
        
        
    } fail:^(NSError *error) {
        
    }];
    

    


}//:(NSNotification *)payNotificat
- (void)hiddenBtn
{
    
    self.selectPayTypeTableView.hidden = YES;
    self.shadowImage.hidden = YES;
    
}
-(void)postMoney
{



}
- (void)zhifubaoPay
{
    self.shadowImage.hidden = YES;
    self.selectPayTypeTableView.hidden = YES;
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setDictionary:@{
                          @"orderid":[NSString stringWithFormat:@"%@",_orderId] ,
                          }];
    [PublicMethod AFNetworkPOSTurl:@"Home/PayAliApp/getAppPay" paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
            
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:[dict objectForKey:@"data"] fromScheme:@"aliqiaotianxiaxintihui1" callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    
                    if([[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]] isEqualToString:@"9000"])
                    {
                        HYMyOrderVC *hy =[[HYMyOrderVC alloc]init];
                        [self.navigationController pushViewController:hy animated:YES];
                    }
                    

                    
                   }];
            }
            
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
    
}
-(void)refreshTheView{
    
    

    
               [ProgressHUD showSuccess:@"支付成功"];

            //服务器端查询支付通知或查询API返回的结果再提示成功
            HYMyOrderVC *hy =[[HYMyOrderVC alloc]init];
            [self.navigationController pushViewController:hy animated:YES];
            
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
