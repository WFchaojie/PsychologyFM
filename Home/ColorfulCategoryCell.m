//
//  ColorfulCategoryCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/30.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "ColorfulCategoryCell.h"

@interface ColorfulCategoryCell()

@property (nonatomic,strong) UIImageView *cellCover;
@property (nonatomic,strong) UILabel *cellTitle;
@property (nonatomic,strong) UILabel *cellSpeak;
@property (nonatomic,strong) UILabel *cellFavnum;

@end

@implementation ColorfulCategoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_cellCover) {
        _cellCover = [[UIImageView alloc]init];
        _cellCover.frame = CGRectMake(10,10, 60, 60);
        [self.contentView addSubview:_cellCover];
    }
    
    if(!_cellTitle)
    {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellCover.frame.origin.y, self.bounds.size.width - _cellCover.bounds.size.width, _cellCover.bounds.size.height/3);
        _cellTitle.font = [UIFont systemFontOfSize:15];
        _cellTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    if(!_cellSpeak)
    {
        _cellSpeak = [[UILabel alloc]init];
        _cellSpeak.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height+5, 120, _cellCover.bounds.size.height/3);
        _cellSpeak.font = [UIFont systemFontOfSize:13];
        _cellSpeak.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellSpeak];
    }
    
    if (!_cellFavnum) {
        _cellFavnum = [[UILabel alloc]init];
        _cellFavnum.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellSpeak.frame.origin.y+_cellSpeak.bounds.size.height, 120, _cellCover.bounds.size.height/3+4);
        _cellFavnum.font = [UIFont systemFontOfSize:13];
        _cellFavnum.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellFavnum];
    }
    
   
    if (_cTitle.length) {
        _cellTitle.text = _cTitle;
    }
    
    if (_cSpeak.length) {
        _cellSpeak.text = _cSpeak;
    }
    
    if ([_cFavnum isKindOfClass:[NSString class]]) {
        _cellFavnum.text = [NSString stringWithFormat:@"收听量:%@",_cFavnum];
    }else if ([_cFavnum isKindOfClass:[NSNumber class]])
    {
        _cellFavnum.text = [NSString stringWithFormat:@"收听量:%@",_cFavnum];
    }


    if (_cCover.length) {
        [_cellCover sd_setImageWithURL:[NSURL URLWithString:_cCover]];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
