//
//  Header.h
//  DoorBellAdmin
//
//  Created by My Star on 5/7/17.
//  Copyright © 2017 DoorBell. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define mainStorageRef [[FIRStorage storage] referenceForURL:@"gs://doorbell-1cf1b.appspot.com"]
#define unselectColor [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:119.0/255.0 alpha:1.0]

#define selectColor [UIColor colorWithRed:6.0/255.0 green:129.0/255.0 blue:197.0/255.0 alpha:1.0]

#define delay_time 0.2

#define main_color          @"#1aa094"
#define main_back_color     @"#4e5655"
#define baseURL             @"http://139.59.189.226:3000/admin/"
#define baseLogoURL         @"http://139.59.189.226:3000"
#define baseLogInURL         @"http://139.59.189.226:3000/"
#define baseBGEndPoint      @"http://139.59.189.226:3000/admin/uploadImage/backgroundimages/"
//#define baseURL             @"http://192.168.1.79:3000/admin/"
//#define baseLogoURL         @"http://192.168.1.79:3000"
//#define baseBGEndPoint      @"http://192.168.1.79:3000/admin/uploadImage/backgroundimages/"
//#define baseLogInURL         @"http://192.168.1.79:3000/"
#define loginEndPoint       @"get_single_admin_name"
#define getusers            @"get_users"
#define getcompanies        @"get_company_backend"
#define get_single_company  @"get_single_company"
#define get_all_company     @"get_all_company"
#define get_single_visitor_phone     @"get_single_visitor_phone"
#define signupEndPoint      @"post_admin"
#define updateEndPoint      @"update_admin"
#define USER_TABLE          @"USER_TABLE"
#define ADMIN_MODEL         @"ADMIN_MODEL"
#define USER_MODEL          @"USER_MODEL"
#define add_visitor         @"post_visitor"
#define update_visitor      @"update_visitor"
#define super_admin_id      @"super_admin_id"

#define get_single_admin    @"get_single_admin"
#define login    @"loginwithmobile"
#define getallcompanywithid @"getallcompanywithid"


#define send_call           @"send_call"
#define sendsmstoguys       @"send_smstoguys"
#define sendsmswifiinfo     @"send_smswifiinfo"
#define send_pushnotification @"send_pushnotification"

#define get_an_users        @"get_user_id"
#define get_admin_companyid @"get_admin_companyid"
#define Admin_company_id    @"admin_company_id"
#define Admin_company_name  @"admin_company_name"
#define Admin_email         @"admin_email"
#define Admin_logo          @"admin_logo"
#define Admin_name          @"admin_name"
#define Admin_phone         @"admin_phone"
#define Admin_status        @"admin_status"
#define Passcode            @"passcode"

#define tophonenumber       @"tophonenumber"
#define devtoken            @"token"
#define push_message        @"message"
#define toname              @"toname"
#define User_id             @"user_id"
#define __V                 @"__v"
#define _Id                 @"_id"

#define Lat                 @"latitude"
#define Llong               @"longitude"

#define Address             @"address"

#define Company_name        @"company_name"
#define Company_email       @"company_email"
#define Company_logo        @"company_logo"
#define Company_statu       @"company_statu"

#define Admin_ID            @"admin_id"

#define appsettingwithuseridOnMobile @"appsettingwithuseridOnMobile"

#define userID              @"userID"
#endif /* Header_h */
