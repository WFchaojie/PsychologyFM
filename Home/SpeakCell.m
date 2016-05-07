//
//  SpeakCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/5/3.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "SpeakCell.h"

@interface SpeakCell()

@property(nonatomic,strong) UIImageView *cellCover;
@property(nonatomic,strong) UILabel *cellTitle;
@property(nonatomic,strong) UILabel *cellContent;
@property(nonatomic,strong) UILabel *cellFmnum;

@end

@implementation SpeakCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_cellCover) {
        _cellCover = [[UIImageView alloc]init];
        _cellCover.frame = CGRectMake(10,10, 40, 40);
        [self.contentView addSubview:_cellCover];
        _cellCover.clipsToBounds = YES;
        _cellCover.layer.cornerRadius = 20;
    }
    
    if (!_cellTitle) {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellCover.frame.origin.x*2+_cellCover.bounds.size.width, 5, self.bounds.size.width - _cellCover.frame.origin.x *2, _cellCover.bounds.size.height/2);
        _cellTitle.font = [UIFont systemFontOfSize:15];
        _cellTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    if (!_cellContent) {
        _cellContent = [[UILabel alloc]init];
        _cellContent.frame = CGRectMake(_cellTitle.frame.origin.x, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height+10, self.bounds.size.width - _cellTitle.frame.origin.x *2,self.bounds.size.height-_cellCover.bounds.size.height/2 -_cellCover.frame.origin.y);
        _cellContent.font = [UIFont systemFontOfSize:13];
        _cellContent.textColor = [UIColor grayColor];
        _cellContent.numberOfLines = 2;
        [self.contentView addSubview:_cellContent];
    }
    
    if (_sContent.length) {
        //设置Label行间距
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:_sContent];
        
        NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
        
        //style.headIndent = 30; //缩进
        
        //style.firstLineHeadIndent = 0;
        
        style.lineSpacing=5;//行距
        
        //style.alignment=NSTextAlignmentCenter;
        
        //需要设置的范围
        
        NSRange range =NSMakeRange(0,_sContent.length);
        
        [text addAttribute:NSParagraphStyleAttributeName value:style range:range];
        
        _cellContent.attributedText= text;
        
        [_cellContent sizeToFit];
        
        
        
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
