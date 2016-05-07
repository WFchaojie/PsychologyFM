//
//  CommunityCell.h
//  PsychologyFM
//
//  Created by 武超杰 on 16/4/26.
//  Copyright © 2016年 武超杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCell : UITableViewCell

@property (nonatomic,strong) NSString *userPic;
@property (nonatomic,strong) NSString *userNickName;
@property (nonatomic,strong) NSString *updated;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *commentnum;
@property (nonatomic,strong) NSArray *images;

@end
