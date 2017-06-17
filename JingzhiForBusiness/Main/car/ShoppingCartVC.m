//
//  ShoppingCartVC.m
//  JingzhiForBusiness
//
//  Created by Admin on 2017/5/25.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "MyCustomCell.h"
#import "GoodsInfoModel.h"

@interface ShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate,GoodsInfoCellDelegate>
{
    UITableView *goodsTableview;//中间商品
    NSMutableArray *infoArr;//商品信息
    float allPrice;//总共价格
    UILabel *_allPriceLab;//总共价格Labbel
    UIView* blackBgView;//输入框背景透明黑
    UIView *alterView;//弹出输入框
    NSInteger indextNum;//定位在哪个单元格点击的（alterView 用）


}

@property(strong,nonatomic)UIButton *allSelectBtn;
@property(strong,nonatomic)UILabel *allPriceLab;


@end
@implementation ShoppingCartVC
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =YES;

    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    [self.view setBackgroundColor:BGColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //替代导航栏的imageview
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CXCWidth, 64)];
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = NavColor;
    [self.view addSubview:topImageView];
   
    //注册标签
    UILabel *navTitle =[[UILabel alloc] initWithFrame:CGRectMake(100*Width, 20, 550*Width, 44)];
    [navTitle setText:@"购物车"];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [navTitle setNumberOfLines:0];
    [navTitle setTextColor:[UIColor whiteColor]];
    [self.view addSubview:navTitle];
    [self mainView  ];
    

    
    

    //初始化数据
   
}
-(void)mainView
{

    //中间的tableview
    goodsTableview   =[[UITableView alloc]init];
    [goodsTableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    goodsTableview .showsVerticalScrollIndicator = NO;
    goodsTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [goodsTableview setFrame:CGRectMake(0,64,CXCWidth,CXCHeight-64-200*Width)];
    [goodsTableview setDelegate:self];
    [goodsTableview setDataSource:self];
    [self.view addSubview:goodsTableview];
//    goodsTableview.hidden =YES;//先隐藏当系统计算的时候再显示
    
    //底部
    UIView *bottomBgview =[[UIView alloc]initWithFrame:CGRectMake(0, CXCHeight-100*Width-49, CXCWidth, 100*Width)];
    [bottomBgview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomBgview];
    //线
    UIImageView*xianBottom =[[UIImageView alloc]init];
    xianBottom.backgroundColor =BGColor;
    [bottomBgview addSubview:xianBottom];
    xianBottom.frame =CGRectMake(0*Width,0*Width, CXCWidth, 1.5*Width);
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(10*Width, 35*Width, 125*Width, 45*Width)];
    btn.tag =888;
    [btn addTarget:self action:@selector(btnClickAll:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"adress_btn_radio"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"adress_btn_radio_sel"] forState:UIControlStateSelected];
    [btn setTitle:@"全选" forState:UIControlStateNormal];
    [btn setTitle:@"全选" forState:UIControlStateSelected];
    [btn setTitleColor:TextColor forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:14];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0*Width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(7.5*Width, 10*Width, 7.5*Width, 85*Width)];
    [bottomBgview addSubview:btn];
    
    
    
    
    
    
    UILabel *subPromLabel =[[UILabel alloc]initWithFrame:CGRectMake(150*Width, 0, 100*Width, 100*Width)];
    [subPromLabel setText:@"合计:"];
    [subPromLabel  setFont:[UIFont systemFontOfSize:17]];
    [bottomBgview   addSubview:subPromLabel];
    [subPromLabel    setTextColor:[UIColor colorWithRed:33/255.0 green:36/255.0 blue:38/255.0 alpha:1]];
    //底部总价
    UILabel *subNumLabel =[[UILabel alloc]initWithFrame:CGRectMake(235*Width, 0, 500*Width, 100*Width)];
    [subNumLabel setText:@"¥0"];
    [subNumLabel  setFont:[UIFont systemFontOfSize:17]];
    [subNumLabel    setTextColor:NavColor];
    [bottomBgview   addSubview:subNumLabel];
    _allPriceLab =subNumLabel;
    //确认提交按钮
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setFrame:CGRectMake(550*Width,0 , 200*Width, 100*Width)];
    [confirmBtn setBackgroundColor:NavColor];
    confirmBtn.layer.borderColor =[UIColor blueColor].CGColor;
    [confirmBtn setTitle:@"去 结 算" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [confirmBtn addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgview addSubview:confirmBtn];
    [self calculateTheGoods];

}
- (void)btnClickAll:(UIButton*)btn
{
    btn.selected=!btn.selected;
    if (btn.selected==YES) {
        for (int i = 0; i<infoArr.count; i++)
        {
            
            GoodsInfoModel *goodsModel = infoArr[i];
            goodsModel.selectState =YES;
        }
        [self totalPrice];//求总和
        [goodsTableview reloadData];//更新一下tableView
        

    }else
    {
        
        for (int i = 0; i<infoArr.count; i++)
    {
        
        GoodsInfoModel *goodsModel = infoArr[i];
        goodsModel.selectState =NO;
    }
        [self totalPrice];//求总和
        [goodsTableview reloadData];//更新一下tableView
        

    
    }


}
//确认提交按钮
- (void)confirmButtonAction
{
    
}
//系统计算
- (void)calculateTheGoods
{
    goodsTableview.hidden =NO;//显示tableview
    
    NSString*num =[NSString stringWithFormat:@"%d",2];
    infoArr =[[NSMutableArray alloc]init];
    
    for (int i = 0; i<4; i++)
    {
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        [infoDict setValue:@"温碧泉白里透红凝润四件套(洁面乳、柔肤水、保湿霜、面膜)" forKey:@"goodsTitle"];
        [infoDict setValue:@"10.00" forKey:@"goodsPrice"];
        [infoDict setValue:[NSNumber numberWithBool:NO] forKey:@"selectState"];
        [infoDict setValue:[NSString stringWithFormat:@"%.2f",([@"10.0" floatValue] *[num floatValue])] forKey:@"goodsTotalPrice"];
        [infoDict setValue:[NSNumber numberWithInt:[num intValue]] forKey:@"goodsNum"];
        
        //封装数据模型
        GoodsInfoModel *goodsModel = [[GoodsInfoModel alloc]initWithDict:infoDict];
        //将数据模型放入数组中
        [infoArr addObject:goodsModel];
    }
    [self totalPrice];//求总和
    [goodsTableview reloadData];//更新一下tableView
    
    
    
    
    
}
//返回按钮
- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return infoArr.count;
}
//定制单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify =  @"indentify";
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[MyCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //调用方法，给单元格赋值
    [cell addTheValue:infoArr[indexPath.row]];
    
    return cell;
}
//返回单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220*Width;
}
//点击其他地方收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITextField *textF =[self.view viewWithTag:2];
    [textF resignFirstResponder];
    
}
//单元格选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void)selectBtnClick:(UIButton *)sender
{
    //判断是否选中，是改成否，否改成是，改变图片状态
    sender.tag = !sender.tag;
    if (sender.tag)
    {
        [sender setImage:[UIImage imageNamed:@"复选框-选中.png"] forState:UIControlStateNormal];
        
    }else{
        [sender setImage:[UIImage imageNamed:@"复选框-未选中.png"] forState:UIControlStateNormal];
    }
    //改变单元格选中状态
    for (int i=0; i<infoArr.count; i++)
    {
        GoodsInfoModel *model = [infoArr objectAtIndex:i];
        model.selectState = sender.tag;
    }
    //计算价格
    [self totalPrice];
    //刷新表格
    [goodsTableview reloadData];
    
}

#pragma mark -- 实现加减按钮点击代理事件
/**
 *  实现加减按钮点击代理事件
 *
 *  @param cell 当前单元格
 *  @param flag 按钮标识，11 为减按钮，12为加按钮 10为输入框按钮
 */
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag
{
    NSIndexPath *index = [goodsTableview indexPathForCell:cell];
    
    switch (flag) {
        case 10:
        {
            indextNum =index.row;
            
            [self alterView:index.row];
            
            break;
            
        }
        case 11:
        {
            //做减法
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
            GoodsInfoModel *model = infoArr[index.row];
            if (model.goodsNum > 1)
            {
                model.goodsNum --;
                model.goodsTotalPrice =[NSString stringWithFormat:@"%.2f",[model.goodsPrice floatValue]*model.goodsNum] ;
                
            }
        }
            break;
        case 12:
        {
            //做加法
            GoodsInfoModel *model = infoArr[index.row];
            
            model.goodsNum ++;
            model.goodsTotalPrice =[NSString stringWithFormat:@"%.2f",[model.goodsPrice floatValue]*model.goodsNum] ;
            
            break;

        }case 9:
        {
            GoodsInfoModel *model = infoArr[index.row];
            
         model.selectState =!model.selectState ;
            
        }
            break;
        default:
            break;
    }
    
    //刷新表格
    [goodsTableview reloadData];
    
    //计算总价
    [self totalPrice];
    
}

#pragma mark -- 计算价格
-(void)totalPrice
{
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格（单价 * 商品数量）
    for ( int i =0; i<infoArr.count; i++)
    {
        GoodsInfoModel *model = [infoArr objectAtIndex:i];
        if (model.selectState)
        {
            allPrice = allPrice + model.goodsNum *[model.goodsPrice intValue];
        }
    }
    
    //给总价文本赋值
    _allPriceLab.text = [NSString stringWithFormat:@"¥%.2f",allPrice];
    NSLog(@"%f",allPrice);
    
    //每次算完要重置为0，因为每次的都是全部循环算一遍
    allPrice = 0.0;
}




//alterView
- (void)alterView:(NSInteger)index
{
    //若存在就不走里边的直接hidden=no;
    if (!blackBgView) {
        blackBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CXCWidth, CXCHeight)];
        [blackBgView setAlpha:0.5];
        [blackBgView  setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:blackBgView];
        
        
        alterView=[[UIView alloc]initWithFrame:CGRectMake(75*Width, 200*Width, 620*Width, 360*Width)];
        [self.view addSubview:alterView];
        [alterView setBackgroundColor:[UIColor whiteColor]];
        [alterView.layer setCornerRadius:20*Width];
        [alterView.layer setBorderWidth:1.0*Width];
        alterView.layer.borderColor =BGColor.CGColor;
        [alterView.layer setMasksToBounds:YES];
        
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0*Width, 0*Width, 620*Width, 120*Width)];
        label.textAlignment =NSTextAlignmentCenter;
        [label setText:@"修改拿货数量"];
        [alterView addSubview:label];
        
        //购买商品的数量
        UITextField*  _numCountLab = [[UITextField alloc]initWithFrame:CGRectMake(210*Width,label.bottom,190*Width , 90*Width)];
        _numCountLab.textAlignment = NSTextAlignmentCenter;
        _numCountLab.tag=120;
        _numCountLab.keyboardType =UIKeyboardTypeNumberPad;
        _numCountLab.layer.borderColor =BGColor.CGColor;
        [_numCountLab.layer setBorderWidth:1.0*Width];
        [alterView addSubview:_numCountLab];
        
        //减按钮
        UIButton* _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(120*Width, label.bottom, 90*Width, 90*Width);
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.tag = 11;
        [_deleteBtn setImage:[UIImage imageNamed:@"register_btn_reduce_modify_black"] forState:UIControlStateNormal];
        [_deleteBtn.layer setBorderWidth:1.0*Width];
        _deleteBtn.layer.borderColor =BGColor.CGColor;
        [alterView addSubview:_deleteBtn];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(15*Width, 15*Width,15*Width, 15*Width);
        
        
        //加按钮
        UIButton* _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(400*Width, label.bottom, 90*Width, 90*Width);
        _addBtn.imageEdgeInsets = UIEdgeInsetsMake(15*Width, 15*Width,15*Width, 15*Width);
        
        [_addBtn.layer setBorderWidth:1.0*Width];
        _addBtn.layer.borderColor =BGColor.CGColor;
        [_addBtn setImage:[UIImage imageNamed:@"register_btn_add_modify_black"] forState:UIControlStateNormal];
        
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.tag = 12;
        [alterView addSubview:_addBtn];
        //线
        UIImageView*xian =[[UIImageView alloc]init];
        xian.backgroundColor =BGColor;
        [alterView addSubview:xian];
        xian.frame =CGRectMake(0*Width,260*Width, 620*Width, 1*Width);
        //取消按钮
        UIButton*cancelBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, xian.bottom, 310*Width, 100*Width)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:BlackColor forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [alterView addSubview:cancelBtn];
        //确认按钮
        UIButton*tureBtn =[[UIButton alloc]initWithFrame:CGRectMake(310*Width, xian.bottom, 310*Width, 100*Width)];
        [tureBtn setBackgroundColor:NavColor];
        [tureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [tureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tureBtn addTarget:self action:@selector(tureBtn) forControlEvents:UIControlEventTouchUpInside];
        [alterView addSubview:tureBtn];
    }
    
    UITextField *textF =[self.view viewWithTag:120];
    [textF becomeFirstResponder];//收起键盘
    GoodsInfoModel *model = infoArr[indextNum];
    textF.text =[NSString stringWithFormat:@"%d",model.goodsNum];//取得数量
    
    blackBgView.hidden=NO;
    alterView.hidden =NO;
    
}
//-
- (void)deleteBtnAction
{
    UITextField *textF =[self.view viewWithTag:120];
    if(textF.text.length==0||[textF.text isEqualToString:@"0"])
    {
        return;
        
    }else
    {
        textF.text =[NSString stringWithFormat:@"%ld",([textF.text integerValue]-1)];
        
        
    }
    
    
}
//+
- (void)addBtnAction
{
    UITextField *textF =[self.view viewWithTag:120];
    textF.text =[NSString stringWithFormat:@"%ld",([textF.text integerValue]+1)];
    
    
}
//确认
- (void)tureBtn
{
    
    blackBgView.hidden=YES;
    
    alterView.hidden =YES;
    
    
    UITextField *textF =[self.view viewWithTag:120];
    [textF resignFirstResponder];
    
    GoodsInfoModel *model = infoArr[indextNum];
    model.goodsNum =[textF.text intValue];
    model.goodsTotalPrice =[NSString stringWithFormat:@"%.2f",[model.goodsPrice floatValue]*model.goodsNum] ;
    
    //刷新表格
    [goodsTableview reloadData];
    
    //计算总价
    [self totalPrice];
    
}
//取消
-(void)cancelBtn
{
    UITextField *textF =[self.view viewWithTag:120];
    [textF resignFirstResponder];
    
    blackBgView.hidden=YES;
    
    alterView.hidden =YES;
    
}


@end
