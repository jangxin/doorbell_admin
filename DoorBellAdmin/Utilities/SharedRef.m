//
//  SharedRef.m
//  Doorbell_user
//
//  Created by My Star on 4/15/17.
//  Copyright © 2017 Doorbell. All rights reserved.
//

#import "SharedRef.h"

@implementation SharedRef
-(id)init
{
    self =[super init];
    [self initValues];
    return self;
}
+(SharedRef *) instance
{
    static SharedRef  *instance =nil;
    if(instance ==nil){
        instance =[[SharedRef alloc] init];
    }
    
    return instance;
}
- (void)initValues{
    self.arrCompanies = [NSMutableArray array];
    self.arrUsers = [NSMutableArray array];
    self.strLat = @"30";
    self.strLong = @"40";
}
@end
