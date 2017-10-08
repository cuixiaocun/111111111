//
//  FindCompanyDetailVC.m
//  家装
//
//  Created by Admin on 2017/9/19.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "FindCompanyDetailVC.h"
#import "FindCompanyOneCell.h"//公司介绍
#import "FindCompanyFiveCell.h"//设计团队
#import "FindDesignerTwoCell.h"//案例展示
#import "FindCompanyTwoCell.h"//优惠活动
#import "FindCompanyThreeCell.h"//新闻
#import "FindCompanyFourCell.h"//评价
#import "IntroduceCompanyVC.h"
#import "TalkCompanyVC.h"
#import "ActivityForYouhui.h"
#import "TXScrollLabelView.h"

@interface FindCompanyDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,TXScrollLabelViewDelegate>
{
    UIScrollView *bgScrollView;//
    UIView *topview ;
    
    UIView *topview2;
}
@property (nonatomic,strong) UICollectionView *mainCMallCollectionView;//按钮视图
@property(nonatomic,strong)UIImageView *phoneImageV;
@property(nonatomic,strong)UILabel *nameLabel;




@end

@implementation FindCompanyDetailVC

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
    [navTitle setText:@"找装修公司"];
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
    xian.frame =CGRectMake(0,Frame_NavAndStatus-1,CXCWidth, 1);
    
    
    [self mainView];
}
- (void)mainView
{
    //底部scrollview
    bgScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, Frame_NavAndStatus, CXCWidth, CXCHeight-Frame_NavAndStatus-49)];
    [bgScrollView setUserInteractionEnabled:YES];
    [bgScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:bgScrollView];
    
    topview =[[UIView alloc]initWithFrame:CGRectMake(0, 0,CXCWidth , 330*Width)];
    topview.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:topview];
    //图片
    _phoneImageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg.png"]];
    _phoneImageV.backgroundColor =BGColor;
    _phoneImageV.frame=CGRectMake(24*Width, 30*Width, 190*Width, 190*Width);
    [bgScrollView addSubview:_phoneImageV];
    //名称
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width,_phoneImageV.top, 460*Width, 50*Width)];
    _nameLabel.text = @"北京凯虹装饰";
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.numberOfLines =0;
    _nameLabel.font =[UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [bgScrollView addSubview:_nameLabel];
    NSArray *arr =@[@"案例:100",@"签单数:909",@"预约数:12",@"签约数:12"];
    for(int i=0;i<4;i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width+i%2*200*Width,_nameLabel.bottom+i/2*60*Width, 220*Width, 50*Width)];
        label.text = [NSString stringWithFormat:@"%@",arr[i]];
        label.textColor=TextColor;
        label.numberOfLines =0;
        label.font =[UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        [bgScrollView addSubview:label];
        
    }
    //横线
    UIImageView*xian =[[UIImageView alloc]init];
    xian.backgroundColor =BGColor;
    [bgScrollView addSubview:xian];
    xian.frame =CGRectMake(0,_phoneImageV.bottom+28.5*Width, CXCWidth, 1.5*Width);
    
    
    NSArray *arr2 =@[@"综合评价:5.0",@"设计:09",@"服务:12",@"贴心:12"];
    for(int i=0;i<4;i++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(187.5*i*Width,xian.bottom, 187.5*Width, 90*Width)];
        if (i==0) {
            label.frame =CGRectMake(20*Width, xian.bottom, 200*Width, 90*Width);
        }else
        {
            label.frame =CGRectMake(220*Width+170*Width*(i-1), xian.bottom, 170*Width, 90*Width);
            
        }
        label.text = [NSString stringWithFormat:@"%@",arr2[i]];
        label.textColor=TextGrayColor;
        label.numberOfLines =0;
        
        label.font =[UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        [bgScrollView addSubview:label];
        
    }
    
    topview2 =[[UIView alloc]initWithFrame:CGRectMake(0, topview.bottom+20*Width,CXCWidth , 90*Width)];
    topview2.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:topview2];
    
    //购房指南
    UIImageView *znImgV =[[UIImageView alloc]initWithFrame:CGRectMake(24*Width,27*Width,130*Width,36*Width)];
    znImgV.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",@"gs_icon_yuyue"]];
    [topview2 addSubview:znImgV];
    
    [self addWith:TXScrollLabelViewTypeFlipNoRepeat velocity:@[@"2",@"2",@"3",@"5"].count isArray:YES withArr:@[@"2",@"2",@"3",@"5"]];

    
    
    //商品详情
    
    //1\初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2\设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(CXCWidth, 100*Width);
    layout.footerReferenceSize = CGSizeMake(CXCWidth, 80*Width);
    
    //3\初始化collextionVIewCell
    _mainCMallCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topview2.bottom, CXCWidth,0*Width) collectionViewLayout:layout];
    [bgScrollView addSubview:_mainCMallCollectionView];
    [_mainCMallCollectionView setBackgroundColor:BGColor];
    //注册collectionViewCell


    //注意，此处的ReuseIdentifier必须和cellForItemAtIndexPath方法中一致，必须为cellId
    [_mainCMallCollectionView registerClass:[FindCompanyOneCell class] forCellWithReuseIdentifier:NSStringFromClass([FindCompanyOneCell class])];
    [_mainCMallCollectionView registerClass:[FindCompanyFiveCell class] forCellWithReuseIdentifier:NSStringFromClass([FindCompanyFiveCell class])];
    [_mainCMallCollectionView registerClass:[FindDesignerTwoCell class] forCellWithReuseIdentifier:NSStringFromClass([FindDesignerTwoCell class])];
    [_mainCMallCollectionView registerClass:[FindCompanyTwoCell class] forCellWithReuseIdentifier:NSStringFromClass([FindCompanyTwoCell class])];
    [_mainCMallCollectionView registerClass:[FindCompanyThreeCell class] forCellWithReuseIdentifier:NSStringFromClass([FindCompanyThreeCell class])];
    [_mainCMallCollectionView registerClass:[FindCompanyFourCell class] forCellWithReuseIdentifier:NSStringFromClass([FindCompanyFourCell class])];
    
    //注册headerView 此处的ReuseiDentifier必须个cellForItemAtIndexPath方法中一致，均为reusableView
    [_mainCMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_mainCMallCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    _mainCMallCollectionView.backgroundColor =[UIColor whiteColor];
    
    //设置代理
    _mainCMallCollectionView.delegate = self;
    _mainCMallCollectionView.dataSource = self;
    _mainCMallCollectionView.scrollEnabled = NO;
    [_mainCMallCollectionView reloadData];
    
    [bgScrollView setContentSize:CGSizeMake(CXCWidth,100000)];
    _mainCMallCollectionView.height = 100000 ;//高度=(数量/2+1)*440*width+20*width
    
    
    //确认提交按钮
    UIButton * shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopCartBtn setFrame:CGRectMake(0*Width,CXCHeight-100*Width , 375*Width, 100*Width)];
    [shopCartBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:112/255.0 blue:48/255.0 alpha:1]];
    [shopCartBtn setTitle:@"关注" forState:UIControlStateNormal];
    [shopCartBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [shopCartBtn addTarget:self action:@selector(guanzhuBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopCartBtn];
    
    //确认提交按钮
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setFrame:CGRectMake(375*Width,CXCHeight-100*Width , 375*Width, 100*Width)];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:230/255.00 green:47/255.00 blue:44/255.00 alpha:1]];
    buyBtn.layer.borderColor =[UIColor blueColor].CGColor;
    [buyBtn setTitle:@"委托设计" forState:UIControlStateNormal];
    [buyBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [buyBtn addTarget:self action:@selector(weituoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
    
    
    
}
- (void)guanzhuBtnAction
{
    
}
- (void)weituoBtnAction
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}
//返回section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
        
    }else if(section==1)
    {
        return 2;
        
    }
    else if(section==2||section==3||section==4)
    {
        return 2;
        
    }else
        
    return 3;
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView    dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        header.backgroundColor =BGColor;
        UILabel *xianV =[[UILabel alloc]initWithFrame:CGRectMake(0*Width,0,CXCWidth,80*Width)];
        xianV.backgroundColor =BGColor;
        [header addSubview:xianV];
        //下边文字
        UILabel *botLabel =[[UILabel alloc]initWithFrame:CGRectMake(0*Width,20*Width,CXCWidth,80*Width)];
        botLabel.font =[UIFont systemFontOfSize:16];
        botLabel.textColor =BlackColor;
        botLabel.backgroundColor =[UIColor whiteColor];
        if (indexPath.section ==0) {
            botLabel.text =[NSString stringWithFormat:@"%@",@"    公司介绍"];
            [header addSubview:botLabel];
            
        }else if(indexPath.section ==1) {
            botLabel.text =[NSString stringWithFormat:@"%@",@"    设计团队"];
            [header addSubview:botLabel];
            
        }else if(indexPath.section ==2) {
            botLabel.text =[NSString stringWithFormat:@"%@",@"    案例展示"];
            [header addSubview:botLabel];
            
        }else if(indexPath.section ==3) {
            botLabel.text =[NSString stringWithFormat:@"%@",@"    优惠活动"];
            [header addSubview:botLabel];
            
        }else if(indexPath.section ==4) {
            botLabel.text =[NSString stringWithFormat:@"%@",@"    企业新闻"];
            [header addSubview:botLabel];
            
        }else
        {
            botLabel.userInteractionEnabled =YES;
            [header addSubview:botLabel];
            
            botLabel.text =[NSString stringWithFormat:@"%@",@"    业主评价"];
            UIButton*   talkBtn = [[UIButton alloc]init];
            [talkBtn setBackgroundColor:NavColor];
            [talkBtn.layer setCornerRadius:2];
            [talkBtn.layer setMasksToBounds:YES];
            talkBtn.frame =CGRectMake(600*Width,30*Width , 130*Width, 60*Width);
            [talkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [talkBtn setTitle:@"评价" forState:UIControlStateNormal];
            talkBtn.tag=130;
            [talkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [talkBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:talkBtn];
            
        }
        
        return header;
    }
    //    如果底部视图
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *footer=[collectionView    dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        
        UIButton *addressBtn =[[UIButton alloc]initWithFrame:CGRectMake(0*Width,0,CXCWidth , 80*Width)];
        addressBtn.tag=440+indexPath.section;
        [footer addSubview:addressBtn];
        [addressBtn addTarget:self action:@selector(chooseMore:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *addLabel = [[UILabel alloc] init];
        [addLabel setText:@"查看全部 >"];
        addLabel.tag =30;
        addLabel.textColor =BlackColor;
        addLabel.textAlignment =NSTextAlignmentCenter;
        [addLabel setFont:[UIFont systemFontOfSize:14]];
        [addLabel setFrame:CGRectMake(0*Width,1.5*Width,CXCWidth , 78.5*Width)];
        addLabel.backgroundColor =[UIColor whiteColor];
        [addressBtn addSubview:addLabel];
        [addressBtn setBackgroundColor:[UIColor whiteColor]];
        UIImageView *addShowImgV =[[UIImageView alloc]initWithFrame:CGRectMake(30*Width, 0*Width, 690*Width, 1.5*Width)];
        addressBtn.backgroundColor =BGColor;
        [addressBtn addSubview:addShowImgV];
        
        return footer;
        
    }
    return nil;
}
- (void)btnAction:(UIButton *)btn
{
     TalkCompanyVC*talk =[[TalkCompanyVC alloc]init];
    [self.navigationController pushViewController:talk animated:YES];
    
}
- (void)chooseMore:(UIButton *)btn
{
    if (btn.tag==440) {
        IntroduceCompanyVC *talk =[[IntroduceCompanyVC alloc]init];
        [self.navigationController pushViewController:talk animated:YES];
        

    }else  if (btn.tag==441) {
        
    }else  if (btn.tag==442) {
        
    }else  if (btn.tag==443) {
        ActivityForYouhui *talk =[[ActivityForYouhui alloc]init];
        [self.navigationController pushViewController:talk animated:YES];
        

    }else  if (btn.tag==444) {
        
    }else  if (btn.tag==445) {
        
    }
    
}
//设置每个方块的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section==0) {
        
        NSString *titleContent =@"个人简介：看了一段时间后的第一个感受-水真深！因为喜欢摄影的原因，自己喜欢的摄影师又都有着小清新，日系情操。\n所以他们的家看起来也是那种干净，简洁，但每种装饰都有它必须在那里的理由。有从比如埃及带回来的装饰品，有从发货某个二手市场淘回来的小家具...放在那里就让整个房间焕发一种温馨的感觉。\nOk，拉回来，我想说的是，这种审美会传染人。于是我也渐渐开始建立起这样的审美。";
        CGSize titleSize;//通过文本得到高度
        titleSize = [titleContent boundingRectWithSize:CGSizeMake(680*Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        NSString *ideaContent =@"设计理念：看了一段时间后的第一个感受-水真深！因为喜欢摄影的原因，自己喜欢的摄影师又都有着小清新，日系情操。\n所以他们的家看起来也是那种干净，简洁，但每种装饰都有它必须在那里的理由。有从比如埃及带回来的装饰品，有从发货某个二手市场淘回来的小家具...放在那里就让整个房间焕发一种温馨的感觉。\nOk，拉回来，我想说的是，这种审美会传染人。于是我也渐渐开始建立起这样的审美。";
        CGSize ideaSize;//通过文本得到高度
        ideaSize = [ideaContent boundingRectWithSize:CGSizeMake(680*Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        return CGSizeMake(CXCWidth,ideaSize.height+titleSize.height+300*Width)  ;
    }else if (indexPath.section==1) {
        return CGSizeMake(CXCWidth,250*Width);

    }else if (indexPath.section==2) {
        return CGSizeMake(340*Width,410*Width);
        
    }else if (indexPath.section==3) {
        return CGSizeMake(340*Width,300*Width);
        
    }else if (indexPath.section==4) {
        return CGSizeMake(CXCWidth,180*Width);
        
    }else{
        NSString *ideaContent =@"他们的团队他别细心，非常专业，很棒的，继续努力！他们的团队他别细心，非常专业，很棒的，继续努力！他们的团队他别细心，非常专业，很棒的，继续努力！";
        CGSize ideaSize;//通过文本得到高度
        ideaSize = [ideaContent boundingRectWithSize:CGSizeMake(560*Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        return CGSizeMake(CXCWidth,300*Width+ideaSize.height);
    }
}
//两个cell之间的间距（同一行的cell的间距）
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0*Width;
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0*Width;
    
    
}

////设置每个item四周的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
     if (section==2||section==3) {
        return UIEdgeInsetsMake(10*Width, 23.33*Width,10*Width,23.33*Width);
        
    }else  {
        return UIEdgeInsetsZero;
        
    }
    
}
//每个cell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.section==0) {
        FindCompanyOneCell* onecell = (FindCompanyOneCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCompanyOneCell class]) forIndexPath:indexPath];
        onecell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return onecell;
        
    }else  if (indexPath.section==1) {
        FindCompanyFiveCell*twocell = (FindCompanyFiveCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCompanyFiveCell class]) forIndexPath:indexPath];
        twocell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return twocell;
        
    }else  if (indexPath.section==2) {
        FindDesignerTwoCell*twocell = (FindDesignerTwoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindDesignerTwoCell class]) forIndexPath:indexPath];
        twocell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return twocell;
        
    }else  if (indexPath.section==3) {
        FindCompanyTwoCell*twocell = (FindCompanyTwoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCompanyTwoCell class]) forIndexPath:indexPath];
        twocell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return twocell;
        
    }else  if (indexPath.section==4) {
        FindCompanyThreeCell*twocell = (FindCompanyThreeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCompanyThreeCell class]) forIndexPath:indexPath];
        twocell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return twocell;
        
    }else {
        FindCompanyFourCell*twocell = (FindCompanyFourCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FindCompanyFourCell class]) forIndexPath:indexPath];
        twocell.backgroundColor = [UIColor whiteColor];
        //    _cell.dic =goodsArr[indexPath.row];
        return twocell;
        
    }
}
//点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1) {
        
    }else if (indexPath.section==2) {
        
    }else if (indexPath.section==3) {
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CXCWidth,100*Width);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(CXCWidth,80*Width);
    
    
}
- (void)addWith:(TXScrollLabelViewType)type velocity:(CGFloat)velocity isArray:(BOOL)isArray  withArr:(NSArray *)stringArray{
    
    /** Step1: 滚动文字 */
    NSString *scrollTitle = @"";
    NSArray *scrollTexts = stringArray;
    
    /** Step2: 创建 ScrollLabelView */
    TXScrollLabelView *scrollLabelView = nil;
    if (isArray) {
        scrollLabelView = [TXScrollLabelView scrollWithTextArray:scrollTexts type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut inset:UIEdgeInsetsZero];
    }else {
        scrollLabelView = [TXScrollLabelView scrollWithTitle:scrollTitle type:type velocity:velocity options:UIViewAnimationOptionCurveEaseInOut];
    }
    /** Step3: 设置代理进行回调 */
    scrollLabelView.scrollLabelViewDelegate = self;
    
    /** Step4: 布局(Required) */
    scrollLabelView.frame = CGRectMake(270*Width, 0, 460*Width, 90*Width);
    [topview2 addSubview:scrollLabelView];
    scrollLabelView.scrollSpace = 10;
    scrollLabelView.backgroundColor =[UIColor whiteColor];
    scrollLabelView.font = [UIFont systemFontOfSize:14];
    scrollLabelView.layer.cornerRadius = 5;
    /** Step5: 开始滚动(Start scrolling!) */
    [scrollLabelView beginScrolling];
}
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    NSLog(@"%@--%ld",text, (long)index);
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
//    NoticeDetailVC *notice =[[NoticeDetailVC alloc]init];
//    notice.contentString =[titleArr[index] objectForKey:@"content"];
//    notice.titleString =[titleArr[index] objectForKey:@"title"];
//    [self.navigationController pushViewController:notice animated:YES];
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
