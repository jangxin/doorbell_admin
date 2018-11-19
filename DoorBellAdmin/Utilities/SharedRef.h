//
//  SharedRef.h
//  Doorbell_user
//
//  Created by My Star on 4/15/17.
//  Copyright © 2017 Doorbell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRef : NSObject
@property NSMutableArray *arrUsers;
@property NSMutableArray *arrCompanies;
@property NSString *strLat;
@property NSString *strLong;
+ (SharedRef *) instance;
@end
