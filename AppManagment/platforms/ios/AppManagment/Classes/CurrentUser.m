//
//  CurrentUser.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/16.
//
//

#import "CurrentUser.h"

@implementation CurrentUser

@synthesize userFlag,userIcon,userID,userLandline,userLastLoginTime,userLoginName,userName,userPassword,userPhone,userPosition,userScore,userSeriesLoginCount;

- (void) dealloc {
    
    self.userFlag = nil;
    self.userIcon = nil;
    self.userID = nil;
    self.userLandline = nil;
    self.userLastLoginTime = nil;
    self.userLoginName = nil;
    self.userName = nil;
    self.userPassword = nil;
    self.userPhone = nil;
    self.userPosition = nil;
    self.userScore = nil;
    self.userSeriesLoginCount = nil;
}
@end
