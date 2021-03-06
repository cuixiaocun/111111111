//
//  HomeThreeCollectionViewCell.m
//  家装
//
//  Created by Admin on 2017/9/7.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import "HomeThreeCollectionViewCell.h"

@implementation HomeThreeCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[UIColor whiteColor];
        self.topMCImage = [[EGOImageView alloc] initWithFrame:CGRectMake(0*Width,0*Width,336*Width,336*Width)];
        self.topMCImage.backgroundColor = BGColor;
        self.topMCImage.userInteractionEnabled = YES;
        [self.contentView addSubview:self.topMCImage];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        
        self.promtpmcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*Width,_topMCImage.bottom,336*Width,80*Width)];
        self.promtpmcLabel.textColor = [UIColor blackColor];
        //        self.promtpmcLabel.textAlignment = NSTextAlignmentCenter;
        self.promtpmcLabel.font = [UIFont fontWithName:@"Arial" size:13];
        self.promtpmcLabel.backgroundColor = [UIColor clearColor];
        self.promtpmcLabel.text =@"温碧泉里头白真凝润四件套（护肤）";
        _promtpmcLabel.numberOfLines =0;
        [self.contentView addSubview:self.promtpmcLabel];
        
        self.pricesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0*Width,_promtpmcLabel.bottom,336*Width,45*Width)];
        self.pricesLabel.textColor = NavColor;
        //        self.pricesLabel.textAlignment = NSTextAlignmentCenter;
        self.pricesLabel.font = [UIFont fontWithName:@"Arial" size:13];
        self.pricesLabel.backgroundColor = [UIColor clearColor];
        _pricesLabel.text =@"¥500.00";
        [self.contentView addSubview:self.pricesLabel];
        
    }
    return self;
}
-(void)setDic:(NSDictionary *)dic
{
    _dic =dic;
    [self.topMCImage sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEURL,[_dic objectForKey:@"thumb"]]]];
    self.promtpmcLabel.text =[NSString stringWithFormat:@"%@",[_dic objectForKey:@"title"]];
    self.pricesLabel.text =[NSString stringWithFormat:@"¥%@",[_dic objectForKey:@"price"]];
    
    
    
}

@end
