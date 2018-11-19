//
//  AppSettingModel.h
//  DoorBellAdmin
//
//  Created by My Star on 6/21/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AppSettingModel : JSONModel

@property NSString<Optional> *bgimageurl;
@property NSString<Optional> *disp_period;
@property NSString<Optional> *company_logo_show;
@property NSString<Optional> *wifi_info_send;
@property NSString<Optional> *visitor_confirm_set;
@property NSString<Optional> *users_search_set;
@property NSString<Optional> *user_id;
@property NSString<Optional> *skip_visitor_reg;
@property NSString<Optional> *company_logo_size;
@property NSString<Optional> *wifi_name;
@property NSString<Optional> *wifi_pass;

@end
