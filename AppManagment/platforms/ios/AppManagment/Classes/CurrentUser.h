//
//  CurrentUser.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/9/16.
//
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject {
    
    NSString *userFlag;
    NSString *userIcon;
    NSString *userID;
    NSString *userLandline;
    NSString *userLastLoginTime;
    NSString *userLoginName;
    NSString *userName;
    NSString *userPassword;
    NSString *userPhone;
    NSString *userPosition;
    NSString *userScore;
    NSString *userSeriesLoginCount;
}

@property (nonatomic, strong) NSString *userFlag;
@property (nonatomic, strong) NSString *userIcon;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userLandline;
@property (nonatomic, strong) NSString *userLastLoginTime;
@property (nonatomic, strong) NSString *userLoginName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *userPosition;
@property (nonatomic, strong) NSString *userScore;
@property (nonatomic, strong) NSString *userSeriesLoginCount;

@end
