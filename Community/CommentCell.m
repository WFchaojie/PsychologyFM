//
//  CommentCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/5.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()

@property (nonatomic,strong) UIImageView *cellCover;
@property (nonatomic,strong) UILabel *cellContent;
@property (nonatomic,strong) UILabel *cellTitle;
@property (nonatomic,strong) UILabel *cellTime;


@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_cellCover) {
        _cellCover = [[UIImageView alloc]init];
        _cellCover.frame = CGRectMake(10,10, 30, 30);
        [self.contentView addSubview:_cellCover];
    }
    
    if(!_cellTitle)
    {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellCover.frame.origin.y, 120, _cellCover.bounds.size.height/2);
        _cellTitle.font = [UIFont systemFontOfSize:13];
        _cellTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    if (!_cellContent) {
        _cellContent = [[UILabel alloc]init];
        _cellContent.frame = CGRectMake(_cellTitle.frame.origin.x, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height + 10, self.bounds.size.width - _cellCover.frame.origin.x *2, _cellCover.bounds.size.height);
        _cellContent.font = [UIFont systemFontOfSize:12];
        _cellContent.textColor = [UIColor blackColor];
        _cellContent.numberOfLines = 0;
        [self.contentView addSubview:_cellContent];
    }
    
    if (!_cellTime) {
        _cellTime = [[UILabel alloc]init];
        _cellTime.font = [UIFont systemFontOfSize:12];
        _cellTime.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellTime];
    }

    
    if (_content.length) {
        CGSize size=CGSizeMake(self.bounds.size.width-_cellCover.frame.origin.x*2 - _cellCover.bounds.size.width, 1000);
        UIFont *font=[UIFont systemFontOfSize:12];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[_content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        _cellContent.frame = CGRectMake(_cellTitle.frame.origin.x, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height + 10, self.bounds.size.width - _cellCover.frame.origin.x *2 - _cellCover.bounds.size.width, actualSize.height);
        _cellContent.text = _content;
        _cellTime.frame = CGRectMake(_cellTitle.frame.origin.x, _cellContent.frame.origin.y + _cellContent.frame.size.height+10, _cellContent.bounds.size.width, 20);
    }

    if (_time.length) {
        _cellTime.text = _time;
    }
    
    if (_cTitle.length) {
        _cellTitle.text = _cTitle;
    }
    
    if (_cover.length) {
        [_cellCover sd_setImageWithURL:[NSURL URLWithString:_cover]];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
