//
//  SpeakPersonCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/4.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakPersonCell.h"

@interface SpeakPersonCell()

@property(nonatomic,strong) UIImageView *cellCover;
@property(nonatomic,strong) UILabel *cellTitle;
@property(nonatomic,strong) UILabel *cellContent;
@property(nonatomic,strong) UILabel *cellFmnum;

@end

@implementation SpeakPersonCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_cellCover) {
        _cellCover = [[UIImageView alloc]init];
        _cellCover.frame = CGRectMake(10,10, 45, 50);
        [self.contentView addSubview:_cellCover];
    }
    
    if (!_cellTitle) {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellCover.frame.origin.x*2+_cellCover.bounds.size.width, 5, self.bounds.size.width - _cellCover.frame.origin.x *2, _cellCover.bounds.size.height/2);
        _cellTitle.font = [UIFont systemFontOfSize:14];
        _cellTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    
    if (!_cellFmnum) {
        _cellFmnum = [[UILabel alloc]init];
        _cellFmnum.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, self.bounds.size.height - 30, 120, 30);
        _cellFmnum.font = [UIFont systemFontOfSize:13];
        _cellFmnum.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellFmnum];
    }
    
    if ([_sFmnum isKindOfClass:[NSString class]]) {
        _cellFmnum.text = [NSString stringWithFormat:@"收听量:%@",_sFmnum];
    }else if ([_sFmnum isKindOfClass:[NSNumber class]])
    {
        _cellFmnum.text = [NSString stringWithFormat:@"收听量:%@",_sFmnum];
    }
    
    if (_sTitle.length) {
        _cellTitle.text = _sTitle;
    }
    
    if (_sCover.length) {
        [_cellCover sd_setImageWithURL:[NSURL URLWithString:_sCover]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
