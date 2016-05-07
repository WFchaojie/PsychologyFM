//
//  SpeakCategoryCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/4.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakCategoryCell.h"

@interface SpeakCategoryCell()

@property (nonatomic,strong) UIImageView *cellCover;
@property (nonatomic,strong) UILabel *cellTitle;
@property (nonatomic,strong) UILabel *cellContent;

@end

@implementation SpeakCategoryCell

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
        _cellCover.clipsToBounds = YES;
        _cellCover.layer.cornerRadius = 30;
    }
    
    if(!_cellTitle)
    {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellCover.frame.origin.y, self.bounds.size.width - _cellCover.bounds.size.width, _cellCover.bounds.size.height/3);
        _cellTitle.font = [UIFont systemFontOfSize:15];
        _cellTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    if(!_cellContent)
    {
        _cellContent = [[UILabel alloc]init];
        _cellContent.frame = CGRectMake(_cellCover.bounds.size.width+_cellCover.frame.origin.x*2, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height+5, self.bounds.size.width - _cellCover.frame.size.width - _cellCover.frame.origin.x * 3, self.bounds.size.height);
        _cellContent.font = [UIFont systemFontOfSize:13];
        _cellContent.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellContent];
        _cellContent.numberOfLines = 2;
    }
    

    
    
    if (_cTitle.length) {
        _cellTitle.text = _cTitle;
    }
    
    if (_cContent.length) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_cContent];
        
        NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
        
        //style.headIndent = 30; //缩进
        
        //style.firstLineHeadIndent = 0;
        
        style.lineSpacing=5;//行距
        
        //style.alignment=NSTextAlignmentCenter;
        
        //需要设置的范围
        
        NSRange range =NSMakeRange(0,_cContent.length);
        
        [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
        
        _cellContent.attributedText= text;
        
        [_cellContent sizeToFit];
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
