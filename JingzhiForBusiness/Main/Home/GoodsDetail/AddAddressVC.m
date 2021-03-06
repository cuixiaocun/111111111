//
//  AddAddressVC.m
//  JingzhiForBusiness
//
//  Created by Admin on 2017/6/5.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "AddAddressVC.h"
#import "MOFSPickerManager.h"
@interface AddAddressVC ()<UITextFieldDelegate>
{
    //底部scrollview
    TPKeyboardAvoidingScrollView *bgScrollView;
    
}
@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:BGColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor =BGColor;
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
    bgScrollView =[[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, Frame_NavAndStatus,CXCWidth, CXCHeight-100*Width)];
    [bgScrollView setUserInteractionEnabled:YES];
    [bgScrollView setBackgroundColor:BGColor];
    [self.view addSubview:bgScrollView];
    [bgScrollView setContentSize:CGSizeMake(CXCWidth, 1500*Width)];
    NSArray *rightArr =[[NSArray alloc]init];
    
    if (_dic) {
        
     rightArr =@[[NSString stringWithFormat:@"%@",[_dic objectForKey:@"name"]],[NSString stringWithFormat:@"%@",[_dic objectForKey:@"phone"]],[NSString stringWithFormat:@"%@",[_dic objectForKey:@"name_path"]],[NSString stringWithFormat:@"%@",[_dic objectForKey:@"address"]]];
    }else
    {
        rightArr =@[@"孙类",@"18363671722",@"山东省潍坊市奎文区",@"新华路胜利街路口西北角宝鼎花园2208号",@"",@"",@"",@""];

    
    
    }
    NSArray*leftArr =@[@"姓名：",@"手机号：",@"所在地区：",@"详细地址：",@"",@"",@"",@"",] ;
    //列表
    for (int i=0; i<4; i++) {
        UIView *bgview =[[UIView alloc]init];
        bgview.backgroundColor =[UIColor whiteColor];
        bgview.frame =CGRectMake(0, 20*Width+100*i*Width, CXCWidth, 100*Width);
        [bgScrollView addSubview:bgview];
        
        UILabel* labe = [[UILabel alloc]initWithFrame:CGRectMake(32*Width, 0,200*Width , 99*Width)];
        labe.text = leftArr[i];
        labe.font = [UIFont systemFontOfSize:15];
        labe.textColor = BlackColor;
        [bgview addSubview:labe];
        if (i!=2) {
            UITextField *inputText = [[UITextField alloc] init];
            [inputText setTag:i+10];
            if (i==1) {
                [inputText setKeyboardType:UIKeyboardTypePhonePad];
            }
            [inputText setDelegate:self];
            [inputText setFont:[UIFont systemFontOfSize:16]];
            [inputText setTextColor:[UIColor blackColor]];
            [inputText setText:[NSString stringWithFormat:@"%@",rightArr[i]]];
            inputText.textAlignment =NSTextAlignmentRight;
            [inputText setFrame:CGRectMake(200*Width, 0,520*Width,99*Width)];
            [inputText setClearButtonMode:UITextFieldViewModeWhileEditing];
            [bgview addSubview:inputText];
            
        }else
        {
            UIButton *chooseBtn =[[UIButton alloc]initWithFrame:CGRectMake(200*Width, 0,520*Width,99*Width)];
            [bgview addSubview:chooseBtn];
            chooseBtn.tag =10+i;
            [chooseBtn addTarget:self action:@selector(addressChoose) forControlEvents:UIControlEventTouchUpInside];
            //文字
            UILabel* wzlabe = [[UILabel alloc]initWithFrame:CGRectMake(0*Width, 0,470*Width , 99*Width)];
            wzlabe.text =[NSString stringWithFormat:@"%@",rightArr[i]] ;
            wzlabe.tag =111;
            wzlabe.font = [UIFont systemFontOfSize:14];
            wzlabe.textColor = [UIColor blackColor];
            [chooseBtn addSubview:wzlabe];
            wzlabe.textAlignment =NSTextAlignmentRight;

            //箭头
            UIImageView  *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(680*Width, 35*Width,30*Width , 30*Width)];
            [bgview addSubview:jiantou];
            [jiantou setImage:[UIImage imageNamed:@"register_btn_nextPage"]];
            
            
        }
        //横线
        UIImageView*xian =[[UIImageView alloc]init];
        xian.backgroundColor =BGColor;
        [bgview addSubview:xian];
        xian.frame =CGRectMake(0,98.5*Width, CXCWidth, 1.5*Width);
        
        
        
    }
    //保存按钮
    UIButton*nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(40*Width,550*Width , 670*Width, 88*Width)];
    [nextBtn setBackgroundColor:NavColor];
    [nextBtn.layer setCornerRadius:4];
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn setTitle:@"保存" forState:UIControlStateNormal];
    [nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [nextBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [nextBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:nextBtn];
    
    
    
    
    
}
//保存按钮
-(void)saveBtn
{
    
    UITextField *nameTF =[self.view viewWithTag:10];
    UITextField *phoneTF =[self.view viewWithTag:11];
    UITextField *addressTF =[self.view viewWithTag:13];
    UILabel *wzlabe =[self.view viewWithTag:111];
    [nameTF resignFirstResponder];
    [phoneTF resignFirstResponder];
    [addressTF resignFirstResponder];
    if (nameTF.text.length>10) {
        [MBProgressHUD showError:@"姓名不能超过10位" ToView:self.view];
        return;
    }
    if (IsNilString(nameTF.text)) {
        [MBProgressHUD showError:@"姓名不能为空!" ToView:self.view];
        return;
    }
    if (IsNilString(phoneTF.text)) {
        [MBProgressHUD showError:@"电话不能为空!" ToView:self.view];
        return;
    }
    if (addressTF.text.length>100) {
        [MBProgressHUD showError:@"地址不能超过100位" ToView:self.view];
        return;
    }
    if (IsNilString(addressTF.text)) {
        [MBProgressHUD showError:@"地址不能为空!" ToView:self.view];
        return;
    }if (IsNilString(wzlabe .text)) {
        [MBProgressHUD showError:@"地区不能为空!" ToView:self.view];
        return;
    }
    
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSString *url ;
    if ([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"HY"]) {
        [dic1 setDictionary:@{
                              @"phone":phoneTF.text ,
                              @"name":nameTF.text ,
                              @"newaddress":addressTF.text ,
                              @"xianaddress":wzlabe.text ,
//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:member] objectForKey:@"id"]]
                              }];
        url =@"Home/address/save";
    }else if([[PublicMethod getDataStringKey:@"IsLogin"] isEqualToString:@"DL"])
    {
        [dic1 setDictionary:@{
                              @"phone":phoneTF.text ,
                              @"name":nameTF.text ,
                              @"newaddress":addressTF.text ,
                              @"xianaddress":wzlabe.text ,
//                              @"uid":[NSString stringWithFormat:@"%@",[[PublicMethod getDataKey:agen] objectForKey:@"id"]]
                              }];
        url =@"home/address/agensave";
        
    }

    NSString *str =[NSString stringWithFormat:@"%@",[_dic objectForKey:@"id"]];
   
    if (! IsNilString(str)) {
        [dic1 setObject:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"id"]] forKey:@"id"];
 
    }
    [PublicMethod AFNetworkPOSTurl:url paraments:dic1  addView:self.view addNavgationController:self.navigationController success:^(id responseDic) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseDic options:NSJSONReadingMutableContainers error:nil];
        if ([ [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]]isEqualToString:@"0"]) {
            if (_dic) {
                [MBProgressHUD  showSuccess:@"修改成功" ToView:self.view];
            }else
            {
                [MBProgressHUD  showSuccess:@"添加成功" ToView:self.view];
            }
            
            
            
            if([[NSString stringWithFormat:@"%@",[_dic objectForKey:@"isdefault"]]isEqualToString:@"1"])
            {
                
                
                    NSMutableDictionary * memberDic  = [NSMutableDictionary dictionaryWithDictionary:[PublicMethod getDataKey:member]];
                    [memberDic setObject:[_dic objectForKey:@"id"] forKey:@"addressid"];
                    [memberDic setObject:wzlabe.text forKey:@"name_path"];
                    [memberDic setObject:addressTF.text forKey:@"address"];
                    [memberDic setObject:nameTF.text forKey:@"receivename"];
                    [memberDic setObject:phoneTF.text forKey:@"phone"];
                    
                    [PublicMethod saveData:memberDic withKey:member];
                    
               
                
                
                
                
                
            }
            
            [self performSelector:@selector(addressSuccess) withObject:nil afterDelay:1];

              }
        
    } fail:^(NSError *error) {
        
    }];
    



}
- (void)addressSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [_delegate needReloadDataAddress];
    

}
- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addressChoose
{
    UITextField *nameTextF =[self.view viewWithTag:10];
    UITextField *phoneTextF =[self.view viewWithTag:11];
    UITextField *addressTextF =[self.view viewWithTag:13];
    [nameTextF resignFirstResponder];
    [phoneTextF resignFirstResponder];
    [addressTextF resignFirstResponder];

    UILabel *label =[self.view viewWithTag:111];
    

    [[MOFSPickerManager shareManger] showMOFSAddressPickerWithDefaultAddress:nil numberOfComponents:3 title:@"" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString *address, NSString *zipcode) {
       label.text = [address stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    } cancelBlock:^{
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITextField *nameTextF =[self.view viewWithTag:10];
    UITextField *phoneTextF =[self.view viewWithTag:11];
    UITextField *addressTextF =[self.view viewWithTag:13];
    [nameTextF resignFirstResponder];
    [phoneTextF resignFirstResponder];
    [addressTextF resignFirstResponder];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;


}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
        
    
    
    
    
    
    
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (textField.tag==11) {
        if (existedLength - selectedLength + replaceLength >= 12) {
            
            [textField resignFirstResponder];
            return NO;
            
            
            
        }
        
    }
    if (textField.tag ==10) {
        if (existedLength - selectedLength + replaceLength >= 10) {
            [MBProgressHUD showWarn:@"名字太长了" ToView:self.view];
            [textField resignFirstResponder];
            return NO;
            
            
            
        }
        
    }else if (textField.tag ==13)
    {
        if (existedLength - selectedLength + replaceLength >= 100) {
            [MBProgressHUD showWarn:@"地址太长了" ToView:self.view];
            [textField resignFirstResponder];
            return NO;
            
            
            
        }
    }
    return YES;
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
