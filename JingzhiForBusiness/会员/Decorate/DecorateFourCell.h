//
//  DecorateFourCell.h
//  家装
//
//  Created by Admin on 2017/9/12.
//  Copyright © 2017年 cuixiaocun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateFourCell : UICollectionViewCell
@property(nonatomic,retain)NSDictionary *dic;
@property (nonatomic,strong)EGOImageView  *topMCImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *seeLabel;
@property (nonatomic,strong) UILabel *talkLabel;

@end
