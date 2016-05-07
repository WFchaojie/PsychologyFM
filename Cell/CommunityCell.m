//
//  CommunityCell.m
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import "CommunityCell.h"

@interface CommunityCell()

@property (nonatomic,strong) UIImageView *cellUserPic;
@property (nonatomic,strong) UILabel *cellUserNickName;
@property (nonatomic,strong) UILabel *cellUpdated;
@property (nonatomic,strong) UILabel *cellContent;
@property (nonatomic,strong) UILabel *cellTitle;
@property (nonatomic,strong) UILabel *cellCommentnum;
@property (nonatomic,strong) UIView *grayView;

@property (nonatomic,strong) UIImageView *cellImage1;
@property (nonatomic,strong) UIImageView *cellImage2;
@property (nonatomic,strong) UIImageView *cellImage3;

@end

@implementation CommunityCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    

    if (!_cellUserPic) {
        _cellUserPic = [[UIImageView alloc]init];
        _cellUserPic.frame = CGRectMake(10,10, 40, 40);
        [self.contentView addSubview:_cellUserPic];
    }
    
    if(!_cellUserNickName)
    {
        _cellUserNickName = [[UILabel alloc]init];
        _cellUserNickName.frame = CGRectMake(_cellUserPic.bounds.size.width+_cellUserPic.frame.origin.x*2, _cellUserPic.frame.origin.y, 120, _cellUserPic.bounds.size.height/2);
        _cellUserNickName.font = [UIFont systemFontOfSize:13];
        _cellUserNickName.textColor = [UIColor grayColor];
        [self.contentView addSubview:_cellUserNickName];
    }
    
    if(!_cellUpdated)
    {
        _cellUpdated = [[UILabel alloc]init];
        _cellUpdated.frame = CGRectMake(_cellUserPic.bounds.size.width+_cellUserPic.frame.origin.x*2, _cellUserNickName.frame.origin.y+_cellUserNickName.bounds.size.height, 120, _cellUserPic.bounds.size.height/2);
        _cellUpdated.font = [UIFont systemFontOfSize:12];
        _cellUpdated.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_cellUpdated];
    }
    
    if (!_cellTitle) {
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.frame = CGRectMake(_cellUserPic.frame.origin.x, _cellUpdated.frame.origin.y+_cellUpdated.bounds.size.height, self.bounds.size.width - _cellUserPic.frame.origin.x *2, _cellUserPic.bounds.size.height);
        _cellTitle.font = [UIFont systemFontOfSize:15];
        _cellTitle.textColor = [UIColor blackColor];
        [self.contentView addSubview:_cellTitle];
    }
    
    if (!_cellContent) {
        _cellContent = [[UILabel alloc]init];
        _cellContent.frame = CGRectMake(_cellUserPic.frame.origin.x, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height, self.bounds.size.width - _cellUserPic.frame.origin.x *2, _cellUserPic.bounds.size.height);
        _cellContent.font = [UIFont systemFontOfSize:14];
        _cellContent.textColor = [UIColor grayColor];
        _cellContent.numberOfLines = 0;
        [self.contentView addSubview:_cellContent];
    }
    
    if (!_grayView) {
        _grayView = [[UIView alloc]init];
        [self addSubview:_grayView];
        _grayView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    }
    
    if (_content.length) {
        CGSize size=CGSizeMake(self.bounds.size.width-_cellUserPic.frame.origin.x, 1000);
        UIFont *font=[UIFont systemFontOfSize:14];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        CGSize actualSize=[_content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        _cellContent.frame = CGRectMake(_cellUserPic.frame.origin.x, _cellTitle.frame.origin.y+_cellTitle.bounds.size.height, self.bounds.size.width - _cellUserPic.frame.origin.x *2, actualSize.height);
        _cellContent.text = _content;
    }
    
    if (_title.length) {
        _cellTitle.text = _title;
    }
    
    if (_updated.length) {
        _cellUpdated.text = _updated;
    }
    
    if (_userNickName.length) {
        _cellUserNickName.text = _userNickName;
    }
    
    if (_userPic.length) {
        [_cellUserPic sd_setImageWithURL:[NSURL URLWithString:_userPic]];
    }
    

    
    if (_images.count) {

        NSLog(@"%@ %@",_userNickName,_images);
        for (int i = 0; i<_images.count; i++) {
            if (i==0) {
                if (!_cellImage1) {
                    _cellImage1 = [[UIImageView alloc]init];
                    _cellImage1.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                    [self.contentView addSubview:_cellImage1];
                }
                _cellImage1.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                [_cellImage1 sd_setImageWithURL:[NSURL URLWithString:[_images objectAtIndex:i]]];
            }
            if (i == 1) {
                if (!_cellImage2) {
                    _cellImage2 = [[UIImageView alloc]init];
                    _cellImage2.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                    [self.contentView addSubview:_cellImage2];
                }
                _cellImage2.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                [_cellImage2 sd_setImageWithURL:[NSURL URLWithString:[_images objectAtIndex:i]]];
            }
            if (i == 2) {
                if (!_cellImage3) {
                    _cellImage3 = [[UIImageView alloc]init];
                    _cellImage3.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                    [self.contentView addSubview:_cellImage3];
                }
                _cellImage3.frame = CGRectMake(10 + i*((self.bounds.size.width -10*4)/3+10), _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, (self.bounds.size.width -10*4)/3, 100);
                [_cellImage3 sd_setImageWithURL:[NSURL URLWithString:[_images objectAtIndex:i]]];
            }
            
            if(i+1==3)
            {
                break;
            }
        }
        _grayView.frame = CGRectMake(0, _cellContent.frame.origin.y + _cellContent.frame.size.height + 10 + 100 +10, self.bounds.size.width, 15);

    }else
    {
        [_cellImage1 removeFromSuperview];
        [_cellImage2 removeFromSuperview];
        [_cellImage3 removeFromSuperview];
        
        _grayView.frame = CGRectMake(0, _cellContent.frame.origin.y + _cellContent.frame.size.height + 10, self.bounds.size.width, 15);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
