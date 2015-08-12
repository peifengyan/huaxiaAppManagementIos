//
//  TransformPDFPlugin.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 14/11/10.
//
//

#import "TransformPDFPlugin.h"
#import "DesEncryptUtil.h"
#import "ConversationViewController.h"
#import "PDFViewController.h"
#import "GeneralPDF.h"
#import "PDFRenderer.h"

@implementation TransformPDFPlugin
- (void) transformPDF:(CDVInvokedUrlCommand *)command {
}

- (void) jsonToPDF:(CDVInvokedUrlCommand *)command {
    
    UIViewController *c = [GlobalVariables getGlobalVariables].currentController;
    
    HUD = [MBProgressHUD showHUDAddedTo:c.view animated:YES];
    HUD.delegate = self;
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    self.callbackId = command.callbackId;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success:) name:@"generalSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeed:) name:@"generalSucceed" object:nil];

    NSError *error = nil;
    NSString *savePath = [DocumentOperation getPathWithComponent:[reciveFromJS objectForKey:@"savePath"] withIntermediateDirectories:YES error:&error];
    NSString *fileName = [reciveFromJS objectForKey:@"fileName"];
    if (![fileName hasPrefix:@".pdf"]) {
        fileName = [fileName stringByAppendingString:@".pdf"];
    }
    fileSavePath = [NSString stringWithFormat:@"%@/%@",savePath,fileName];
    
    NSDictionary *data = [[reciveFromJS objectForKey:@"data"] objectAtIndex:0];
    NSString *imageURL = [data objectForKey:@"imageUrl"];
    NSString * thanksMessageString = [data objectForKey:@"thanksMsg"];
    NSString * companyInfoString = [data objectForKey:@"companyInfo"];
    NSString * startMsgString = [data objectForKey:@"startMsg"];
    NSString * productInfoString = [data objectForKey:@"productInfo"];
    NSString * isuresInterestString = [data objectForKey:@"isuresInterest"];
    NSString * isuresInterestTableString = [data objectForKey:@"isuresInterestTable"];
    NSString * importTipString = [data objectForKey:@"importTip"];
    NSString * endMsgString = [data objectForKey:@"endMsg"];
    
    GeneralPDF *pdf = [[GeneralPDF alloc] initWithPath:@"1.pdf"];
    NSArray *lines = @[@{kPDFRect: [NSValue valueWithCGRect:CGRectMake(10, 50, PageSize.width - 20, 1)]},@{kPDFRect: [NSValue valueWithCGRect:CGRectMake(10, PageSize.height - 50, PageSize.width - 20, 1)]}];
    
    CGRect headerImageRect = CGRectMake(20, PageSize.height - 50, 173, 23);
    NSArray *headersAndFooters = @[
                                   @{
                                       kPDFTextColor: [UIColor blackColor],
                                       kPDFTextFont: [UIFont systemFontOfSize:13.0f],
                                       kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentRight],
                                       kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                       kPDFRect: [NSValue valueWithCGRect:CGRectMake(PageSize.width - 320, 10, 300, 25)],
                                       kPDFText: @"呈敬:张学友先生"},
                                   @{
                                       kPDFTextColor: [UIColor blackColor],
                                       kPDFTextFont: [UIFont systemFontOfSize:13.0f],
                                       kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentRight],
                                       kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                       kPDFRect: [NSValue valueWithCGRect:CGRectMake(PageSize.width - 320, 25, 300, 25)],
                                       kPDFText: @"理财顾问:mrzhou 业务代码:8611018517"},
                                   @{
                                       kPDFTextColor: [UIColor blackColor],
                                       kPDFTextFont: [UIFont systemFontOfSize:10.0f],
                                       kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                       kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                       kPDFRect: [NSValue valueWithCGRect:CGRectMake(40, PageSize.height - 40, PageSize.width - 80, 100)],
                                       kPDFText: @"￼郑重声明:本保障计划单位为人民币元,假定被保险人为标准体,所列产品、费率、基本保险金额等与保险合 同不一定一致,请以保险合同为准。"}];
    if (imageURL.length != 0) {
        
        NSArray *arr = @[
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:13.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(100, 80, 300, 30)],
                             kPDFText: @"呈敬:张学友先生"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(0, 110, PageSize.width, 30)],
                             kPDFText: @"张学友"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:12.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(227.6, 680, 140, 30)],
                             kPDFText: @"理财顾问: mrzhou"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:12.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(227.6, 700, 140, 30)],
                             kPDFText: @"工       号: 8611018517"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:12.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(227.6, 720, 140, 30)],
                             kPDFText: @"电       话: 15923003477"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:12.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(227.6, 740, 140, 30)],
                             kPDFText: @"所属机构: 北京分公司"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:12.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(227.6, 760, 140, 30)],
                             kPDFText: @"日       期: 2014年12月26日"},
                         @{
                             kPDFTextColor: [UIColor blackColor],
                             kPDFTextFont: [UIFont systemFontOfSize:10.0f],
                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(0, 780, PageSize.width, 30)],
                             kPDFText: @"本建议书仅供参考,详细内容以正式保险合同为准。"}];
        
        NSString *s = [NSString stringWithFormat:@"promodel/10003/www/cover/%@",imageURL];
        UIImage *image = [UIImage imageWithContentsOfFile:[DocumentOperation getPathWithComponent:s withIntermediateDirectories:NO error:nil]];
        
        [pdf drawTexts:arr onImage:image andImageRect:[NSValue valueWithCGRect:CGRectMake(0, 0, PageSize.width, PageSize.height)] linesArray:nil beginPage:YES endPage:YES];
    }
    if (thanksMessageString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼致谢函"};
        thanksMessageString = [thanksMessageString stringByReplacingOccurrencesOfString:@"牛肉女士" withString:@"张学友先生"];
        NSDictionary *thanksMessageDictionary = @{
                                                  kPDFTextColor: [UIColor blackColor],
                                                  kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                                  kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                                  kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                                  kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                                  kPDFText: thanksMessageString};
        NSMutableArray *thanksMessage = [NSMutableArray arrayWithArray:headersAndFooters];
        [thanksMessage addObject:titleInfo];
        [thanksMessage addObject:thanksMessageDictionary];
        [pdf drawTexts:thanksMessage onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    if (companyInfoString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼民生人寿保险股份有限公司简介"};
        NSDictionary *companyInfoDictionary = @{
                                                kPDFTextColor: [UIColor blackColor],
                                                kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                                kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                                kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                                kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                                kPDFText: companyInfoString};
        NSMutableArray *companyInfo = [NSMutableArray arrayWithArray:headersAndFooters];
        [companyInfo addObject:titleInfo];
        [companyInfo addObject:companyInfoDictionary];
        [pdf drawTexts:companyInfo onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    if (startMsgString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼开篇语"};
        NSDictionary *startMsgDictionary = @{
                                             kPDFTextColor: [UIColor blackColor],
                                             kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                             kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                             kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                             kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                             kPDFText: startMsgString};
        NSMutableArray *startMsg = [NSMutableArray arrayWithArray:headersAndFooters];
        [startMsg addObject:titleInfo];
        [startMsg addObject:startMsgDictionary];
        
        [pdf drawTexts:startMsg onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    if (productInfoString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼产品简介"};
        NSDictionary *productInfoDictionary = @{
                                                kPDFTextColor: [UIColor blackColor],
                                                kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                                kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                                kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                                kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                                kPDFText: productInfoString};
        
        NSMutableArray *productInfo = [NSMutableArray arrayWithArray:headersAndFooters];
        [productInfo addObject:titleInfo];
        [productInfo addObject:productInfoDictionary];
        [pdf drawTexts:productInfo onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    [pdf releaseContext];
    if (isuresInterestString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼民生人寿保险股份有限公司简介"};
        
        NSDictionary *isuresInterestDictionary = @{
                                                   kPDFTextColor: [UIColor blackColor],
                                                   kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                                   kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                                   kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                                   kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                                   kPDFText: isuresInterestString};
        NSMutableArray *isuresInterest = [NSMutableArray arrayWithArray:headersAndFooters];
        //        [isuresInterest addObject:titleInfo];
        //        [isuresInterest addObject:isuresInterestDictionary];
        //        [pdf drawTexts:isuresInterest onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
        [pdf drawTexts:isuresInterest andHTML:isuresInterestString onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:NO endPage:NO];
    }
    if (isuresInterestTableString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼民生人寿保险股份有限公司简介"};
        NSDictionary *isuresInterestTableDictionary = @{
                                                        kPDFTextColor: [UIColor blackColor],
                                                        kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                                        kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                                        kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                                        kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                                        kPDFText: isuresInterestTableString};
        NSMutableArray *isuresInterestTable = [NSMutableArray arrayWithArray:headersAndFooters];
        [isuresInterestTable addObject:titleInfo];
        [isuresInterestTable addObject:isuresInterestTableDictionary];
        //        [pdf drawTexts:isuresInterestTable andHTML:isuresInterestTableString onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:NO endPage:NO];
        NSData *data = [isuresInterestTableString dataUsingEncoding:NSUTF8StringEncoding];
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *localPath = [DocumentOperation getPathWithComponent:@"3.pdf" withIntermediateDirectories:NO error:nil];
        [PDFRenderer drawPDF:localPath data:result];
    }
    GeneralPDF *pdf1 = [[GeneralPDF alloc] initWithPath:@"4.pdf"];
    if (importTipString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼重要提示"};
        NSDictionary *importTipDictionary = @{
                                              kPDFTextColor: [UIColor blackColor],
                                              kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                              kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                              kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                              kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                              kPDFText: importTipString};
        NSMutableArray *importTip = [NSMutableArray arrayWithArray:headersAndFooters];
        [importTip addObject:titleInfo];
        [importTip addObject:importTipDictionary];
        
        [pdf1 drawTexts:importTip onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    if (endMsgString.length != 0) {
        
        NSDictionary *titleInfo = @{
                                    kPDFTextColor: [UIColor blackColor],
                                    kPDFTextFont: [UIFont boldSystemFontOfSize:20.0f],
                                    kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentCenter],
                                    kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                    kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 70, PageSize.width - 40, 100)],
                                    kPDFText: @"￼结束语"};
        NSDictionary *endMsgDictionary = @{
                                           kPDFTextColor: [UIColor blackColor],
                                           kPDFTextFont: [UIFont systemFontOfSize:15.0f],
                                           kPDFTextAlignment: [NSNumber numberWithInteger:NSTextAlignmentLeft],
                                           kPDFLineBreakMode: [NSNumber numberWithInteger:NSLineBreakByCharWrapping],
                                           kPDFRect: [NSValue valueWithCGRect:CGRectMake(20, 140, PageSize.width - 40, PageSize.height)],
                                           kPDFText: endMsgString};
        NSMutableArray *endMsg = [NSMutableArray arrayWithArray:headersAndFooters];
        [endMsg addObject:titleInfo];
        [endMsg addObject:endMsgDictionary];
        [pdf1 drawTexts:endMsg onImage:[UIImage imageNamed:@"default_logo_temple.png"] andImageRect:[NSValue valueWithCGRect:headerImageRect] linesArray:lines beginPage:YES endPage:YES];
    }
    [pdf1 releaseContext];
    
    [PDFRenderer saveWithBasePDFPath:fileSavePath];
}
- (void) success:(NSNotification *) no {
    
    [PDFRenderer saveWithBasePDFPath:[no object]];
}
- (void) succeed:(NSNotification *) no {

    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileSavePath]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:fileSavePath error:&error];
        if (error == nil) {
            [[NSFileManager defaultManager] copyItemAtPath:[no object] toPath:fileSavePath error:&error];
            if (error == nil) {
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
            }
        }
    }
    else {
        if (error == nil) {
            [[NSFileManager defaultManager] copyItemAtPath:[no object] toPath:fileSavePath error:&error];
            if (error == nil) {
                
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
            }
        }
    }
}
- (void) delayMethod {
    
    [HUD hide:YES];
    [self loadHTMLInPath:nil savePDFPath:fileSavePath];
}
- (void) openPDF:(CDVInvokedUrlCommand *)command {
    
    NSDictionary *reciveFromJS = [command.arguments objectAtIndex:0];
    
    NSString *fileName = [reciveFromJS objectForKey:@"fileName"];
    if (![fileName hasSuffix:@".pdf"]) {
        fileName = [NSString stringWithFormat:@"%@.pdf",fileName];
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@",[reciveFromJS objectForKey:@"savePath"],fileName];

    NSError *fileError = nil;
    NSString *loadFilePath = [DocumentOperation getPathWithComponent:path withIntermediateDirectories:NO error:&fileError];
    
    if (!fileError) {
        
        [self loadHTMLInPath:nil savePDFPath:loadFilePath];
    }
}

- (void) loadHTMLInPath:(NSString *)path savePDFPath:(NSString *)savePath {
    
    if (![savePath hasSuffix:@".pdf"]) {
        savePath = [NSString stringWithFormat:@"%@.pdf",savePath];
    }
    PDFViewController *cvc;
    if ([[UIScreen mainScreen] bounds].size.height <= 568) {
        
        cvc = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:nil];
        
    } else {
        
        cvc = [[PDFViewController alloc] initWithNibName:@"PDFViewController~iPad" bundle:nil];
    }
    cvc.loadWebUrl = savePath;

    UIViewController *currentController = [GlobalVariables getGlobalVariables].currentController;
    [currentController presentViewController:cvc animated:YES completion:nil];
}

@end
