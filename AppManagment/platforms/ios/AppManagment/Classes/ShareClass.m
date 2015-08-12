//
//  ShareClass.m
//  开8
//
//  Created by Elvis_J_Chan on 13-6-25.
//  Copyright (c) 2013年 Elvis_J_Chan. All rights reserved.
//

#import "ShareClass.h"

@implementation ShareClass
- (id) init {
    self = [super init];
    if (self) {
        //向微信注册
        [WXApi registerApp:WECHAT_APP_ID withDescription:@"华夏银保"];
    }
    return self;
}
#pragma mark - wechat
- (void) shareWeiXinWithTitle:(NSString *) title description:(NSString *) description url:(NSString *) url sence:(int) sence {
    
    if ([WXApi isWXAppInstalled]) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        [message setThumbImage:[UIImage imageNamed:@"icon@2x.png"]];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        
        message.mediaObject = ext;
        message.mediaTagName = title;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = sence;
        [WXApi sendReq:req];
    }
    else {
        
        BaseResp *resp = [[BaseResp alloc] init];
        resp.errCode = -6;
        [self onResp:resp];
    }
}
#pragma mark - wechatResponse
-(void) onResp:(BaseResp*)resp {
    
    NSNotificationCenter* ns=[NSNotificationCenter defaultCenter];
    [ns postNotificationName:@"wechatShareResult" object:resp];
}

@end
