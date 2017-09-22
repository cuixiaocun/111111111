//
//  FindCompanyFiveCell.m
//  家装
//
//  Created by Admin on 2017/9/19.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "FindCompanyFiveCell.h"

@implementation FindCompanyFiveCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        
        //图片
        _phoneImageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timg.png"]];
        _phoneImageV.backgroundColor =BGColor;
        _phoneImageV.frame=CGRectMake(24*Width, 30*Width, 194*Width, 194*Width);
        [self addSubview:_phoneImageV];
        //名称
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width,_phoneImageV.top, 460*Width, 50*Width)];
        _nameLabel.text = @"王涛";
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.numberOfLines =0;
        _nameLabel.font =[UIFont systemFontOfSize:14];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_nameLabel];
        
        //案例
        _caseLabel =[[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width, _nameLabel.bottom,500*Width, 50*Width)];
        _caseLabel.numberOfLines =0;
        _caseLabel.text =@"案例：30套";
        _caseLabel.font =[UIFont systemFontOfSize:14];
        _caseLabel.textColor =TextColor;
        [self addSubview:_caseLabel];
        
        //毕业院校
        _collegesLabel =[[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width,_caseLabel.bottom, 500*Width, 50*Width)];
        _collegesLabel.text =@"毕业院校";
        _collegesLabel.font =[UIFont systemFontOfSize:14];
        _collegesLabel.textColor =TextColor;
        [self addSubview:_collegesLabel];
        //面积
        _ideaLabel =[[UILabel alloc]initWithFrame:CGRectMake(_phoneImageV.right+24*Width, _collegesLabel.bottom, 500*Width, 50*Width)];
        _ideaLabel.text =@"设计理念：房屋装修以简约现代为主，金属粉还低中国风 ";
        _ideaLabel.font =[UIFont systemFontOfSize:13];
        _ideaLabel.textColor =TextGrayColor;
        [self addSubview:_ideaLabel];
        //线
        _xianImageV =[[UIImageView alloc]initWithFrame:CGRectMake(30*Width,250*Width-1.5*Width, 690*Width, 1.5*Width)];
        _xianImageV.backgroundColor =BGColor;
        [self addSubview:_xianImageV];
        
        
    }
    return self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDic:(NSDictionary *)dic
{
    
    
}

@end
