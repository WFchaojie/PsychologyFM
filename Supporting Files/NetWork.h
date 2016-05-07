//
//  NetWork.h
//  PsychologyFM
//

//  Created by 武超杰 on 15/11/24.
//  Copyright © 2015年 武超杰. All rights reserved.
//  http://bapi.xinli001.com/fm2/myuserinfo.json/?key=c0d28ec0954084b4426223366293d190&token=xinli123

#ifndef NetWork_h
#define NetWork_h

#define HTTP_NET_URL @"http://yiapi.xinli001.com/fm/home-list.json?key=c0d28ec0954084b4426223366293d190"
#define LAUCH_URL @"http://yiapi.xinli001.com/fm/initial-cover.json?key=c0d28ec0954084b4426223366293d190"
#define FM_URL @"http://bapi.xinli001.com/fm2/broadcast.json/?key=c0d28ec0954084b4426223366293d190&pk=%@"
#define FM_URL2 @"http://yiapi.xinli001.com/fm/broadcast-detail-old.json?key=c0d28ec0954084b4426223366293d190&id=%@"

//不知道是什么
#define UN_KNOW @"http://bapi.xinli001.com/fm2/alarmtext_list.json/?key=c0d28ec0954084b4426223366293d190"

//社区精华
#define Community_Hot(offset) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-thread-list.json?flag=0&size=10&key=c0d28ec0954084b4426223366293d190&offset=%ld&type=1",offset]

//社区最新
#define Community_New(offset) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-thread-list.json?flag=0&size=10&key=c0d28ec0954084b4426223366293d190&offset=%ld&type=0",offset]


//主播
#define Search_ZB @"http://yiapi.xinli001.com/fm/diantai-find-list.json?key=c0d28ec0954084b4426223366293d190&rows=6&offset=0"
//发现banner
#define Search_Banner @"http://bapi.xinli001.com/fm2/hot_tag_list.json/?flag=4&key=c0d28ec0954084b4426223366293d190&rows=3&offset=0"

//首页分类接口
#define Home_Class(offset,ID) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/category-jiemu-list.json?key=c0d28ec0954084b4426223366293d190&offset=%ld&category_id=%@&limit=20",offset,ID] 

//tag

#define Home_Tag(tag,offset) [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?rows=15&offset=%ld&key=c0d28ec0954084b4426223366293d190&tag=%@",offset,tag]
//最新心理课

#define Home_NewClass(offset) [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?rows=15&offset=%ld&is_teacher=1&key=c0d28ec0954084b4426223366293d190",offset]
//最新FM

#define Home_NewFM(offset) [NSString stringWithFormat:@"http://bapi.xinli001.com/fm2/broadcast_list.json/?rows=15&offset=%ld&is_teacher=0&key=c0d28ec0954084b4426223366293d190",offset]

//发现主播
#define Home_Speak @"http://yiapi.xinli001.com/fm/diantai-page.json?key=c0d28ec0954084b4426223366293d190"

#define Speak_hot(offset) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-hot-list.json?key=c0d28ec0954084b4426223366293d190&limit=10&offset=%ld",offset]

#define Speak_Detail(ID) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-detai.json?key=c0d28ec0954084b4426223366293d190&id=%@",ID]


#define Speak_Show(offset,ID) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-jiemu-list.json?diantai_id=%@&key=c0d28ec0954084b4426223366293d190&offset=%ld&limit=20",ID,offset]

#define Speak_New(offset) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/diantai-new-list.json?key=c0d28ec0954084b4426223366293d190&limit=20&offset=%ld",offset]

//社区详情
#define Community_User(ID) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-thread-detail.json?id=%@&key=c0d28ec0954084b4426223366293d190",ID]

#define Community_Comment(ID,offset) [NSString stringWithFormat:@"http://yiapi.xinli001.com/fm/forum-comment-list.json?post_id=%@&key=c0d28ec0954084b4426223366293d190&offset=%ld&limit=10",ID,offset]




#endif /* NetWork_h */
