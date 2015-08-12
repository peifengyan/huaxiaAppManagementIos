//
//  GeneralPDF.m
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/19/14.
//
//

#import "GeneralPDF.h"
#import "PDFRenderer.h"

__strong static GeneralPDF *pdf = nil;

@interface GeneralPDF () <UIWebViewDelegate> {
    
    CGContextRef pdfContext;
    CGRect pageRect;
    
    NSString *pdfPath;
    NSString *pdfTmpPath;
    NSString *tmpPath;
    
    UIWebView *loadWebView;
}

@end

@implementation GeneralPDF

- ( id ) initWithPath:(NSString *) path {
    
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *saveDirectory = [paths objectAtIndex:0];
        NSString *filePath = [saveDirectory stringByAppendingPathComponent:path];
        
        pdfPath = filePath;
        
        tmpPath = [saveDirectory stringByAppendingPathComponent:@"2.pdf"];
        
        [[NSUserDefaults standardUserDefaults] setObject:pdfPath forKey:@"path"];
        
        const char *filename = [filePath UTF8String];
        pageRect = CGRectMake(0, 0, PageSize.width, PageSize.height);
        
        CFStringRef pathRef;
        CFURLRef url;
        CFMutableDictionaryRef myDictionary = NULL;
        // Create a CFString from the filename we provide to this method when we call it
        pathRef = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
        // Create a CFURL using the CFString we just defined
        url = CFURLCreateWithFileSystemPath (NULL, pathRef, kCFURLPOSIXPathStyle, 0);
        CFRelease (pathRef);
        // This dictionary contains extra options mostly for ‘signing’ the PDF
        myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
        CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
        // Create our PDF Context with the CFURL, the CGRect we provide, and the above defined dictionary
        pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
        // Cleanup our mess
        CFRelease(myDictionary);
        CFRelease(url);
    }
    return self;
}
- ( void ) drawTextRect:( CGRect ) rect text:( NSString * ) text beginPage:(BOOL) beginPage endPage:(BOOL) endPage {
    
    if (beginPage) {
        CGContextBeginPage (pdfContext, &pageRect);
    }
    //    CGContextSelectFont (pdfContext, "Helvetica", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
    
    UIGraphicsPushContext(pdfContext);  //将需要绘制的层push
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1, -1);
    //    CGContextShowTextAtPoint (pdfContext, 260, 390, [text UTF8String], strlen([text UTF8String])); //汉字不正常
    
    UIFont *font = [UIFont systemFontOfSize:15]; //自定义字体
    NSTextAlignment alignment = NSTextAlignmentLeft;
    NSLineBreakMode lineBreakMode = NSLineBreakByWordWrapping;
    
    CGContextSetFillColorWithColor(pdfContext, [UIColor redColor].CGColor); //颜色
    
    CGRect textSize = [text boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    
    CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, textSize.size.height);
    [text drawInRect:drawRect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
    
    UIGraphicsPopContext();
    
    CGContextStrokePath(pdfContext);
    
    if (endPage) {
        CGContextEndPage (pdfContext);
    }
}

- ( void ) drawImageRect:( CGRect ) rect image:( UIImage * ) image beginPage:(BOOL) beginPage endPage:(BOOL) endPage {
    
    if (beginPage) {
        CGContextBeginPage (pdfContext, &pageRect);
    }
    
    CGContextDrawImage(pdfContext, rect, [image CGImage]); //绘制图片
    
    CGContextStrokePath(pdfContext);
    
    if (endPage) {
        CGContextEndPage (pdfContext);
    }
}


- (void) drawText:( NSString * ) text onImage:( UIImage * ) image withTextRect:( CGRect ) textRect andImageRect:( CGRect ) imageRect beginPage:(BOOL) beginPage endPage:(BOOL) endPage {
    //开始绘制页面
    if (beginPage) {
        CGContextBeginPage (pdfContext, &pageRect);
    }
    //开始绘制图片
    CGContextDrawImage(pdfContext, imageRect, [image CGImage]); //绘制图片
    //黑色弧度为50的圆角图片
    //    CGContextStrokeRect(pdfContext, CGRectMake(50, 50, pageRect.size.width - 100, pageRect.size.height - 100));
    //在图片上添加文字
    //    CGContextSelectFont (pdfContext, "Helvetica", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
    //将需要绘制的层push
    UIGraphicsPushContext(pdfContext);
    //转换Y轴坐标,  底层坐标与cocoa 组件不同 Y轴相反
    CGContextTranslateCTM(pdfContext, 0, PageSize.height);
    CGContextScaleCTM(pdfContext, 1, -1);
    //    CGContextShowTextAtPoint (pdfContext, 260, 390, [text UTF8String], strlen([text UTF8String])); //汉字不正常
    //自定义字体,颜色
    UIFont *font = [UIFont systemFontOfSize:15 ];
    CGContextSetFillColorWithColor(pdfContext, [UIColor blackColor].CGColor);
    [text drawAtPoint:textRect.origin forWidth:textRect.size.width withFont:font minFontSize:8 actualFontSize:NULL lineBreakMode:NSLineBreakByWordWrapping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    //将需要绘制的层pop
    UIGraphicsPopContext();
    CGContextStrokePath(pdfContext);
    //结束绘制图片
    CGContextEndPage (pdfContext);
}
- (void) releaseContext {
    
    CGContextRelease (pdfContext);
}

- ( void ) drawTexts:( NSArray * ) textArray onImage:( UIImage * ) image andImageRect:( NSValue * ) imageRect linesArray:(NSArray *) lineArray beginPage:(BOOL) beginPage endPage:(BOOL) endPage {
    
    //开始绘制页面
    if (beginPage) {
        CGContextBeginPage (pdfContext, &pageRect);
    }
    CGRect imageNewRect = [imageRect CGRectValue];
    //开始绘制图片
    CGContextDrawImage(pdfContext, imageNewRect, [image CGImage]); //绘制图片
    //黑色弧度为50的圆角图片
//    CGContextStrokeRect(pdfContext, CGRectMake(50, 50, pageRect.size.width - 100, pageRect.size.height - 100));
    //在图片上添加文字
//    CGContextSelectFont (pdfContext, "Helvetica", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode (pdfContext, kCGTextFill);
    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
    //将需要绘制的层push
    UIGraphicsPushContext(pdfContext);
    //转换Y轴坐标,  底层坐标与cocoa 组件不同 Y轴相反
    CGContextTranslateCTM(pdfContext, 0, PageSize.height);
    CGContextScaleCTM(pdfContext, 1, -1);
//    CGContextShowTextAtPoint (pdfContext, 260, 390, [text UTF8String], strlen([text UTF8String])); //汉字不正常
    //自定义字体,颜色
    
    for ( int i = 0 ; i < [textArray count] ; i ++ ) {
        
        NSDictionary *textObject = [textArray objectAtIndex:i];
        UIFont *font = [textObject objectForKey:kPDFTextFont];
        NSString *text = [textObject objectForKey:kPDFText];
        CGRect textRect = [[textObject objectForKey:kPDFRect] CGRectValue];
        UIColor *color = [textObject objectForKey:kPDFTextColor];
        NSTextAlignment alignment = (NSTextAlignment) [[textObject objectForKey:kPDFTextAlignment] integerValue];
        NSLineBreakMode lineBreakMode = (NSLineBreakMode) [[textObject objectForKey:kPDFLineBreakMode] integerValue];
        
        CGContextSetFillColorWithColor(pdfContext, [color CGColor]);
        
        CGRect textSize = [text boundingRectWithSize:textRect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        
        CGRect drawRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, textSize.size.height);
        [text drawInRect:drawRect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
        
    }
    
    for ( int i = 0 ; i < [lineArray count]; i ++ ) {
        
        CGRect rect = [[[lineArray objectAtIndex:i] objectForKey:kPDFRect] CGRectValue];
        CGFloat lineWidth = rect.size.height;
        CGSize lineSize = CGSizeMake(rect.origin.x + rect.size.width, rect.origin.y);
        if (rect.size.height > rect.size.width) {
            
            lineWidth = rect.size.width;
            lineSize = CGSizeMake(rect.origin.x, rect.origin.y + rect.size.height);
        }
        UIColor *color = [UIColor blackColor];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        CGContextSetLineWidth(context, lineWidth);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, lineSize.width, lineSize.height);
        CGContextStrokePath(context);
    }
    //将需要绘制的层pop
    UIGraphicsPopContext();
    CGContextStrokePath(pdfContext);
    //结束绘制图片
    if (endPage) {
        CGContextEndPage (pdfContext);
    }
}

- ( void ) drawTexts:( NSArray * ) textArray andHTML:( NSString * ) HTML onImage:( UIImage * ) image andImageRect:( NSValue * ) imageRect linesArray:(NSArray *) lineArray beginPage:(BOOL) beginPage endPage:(BOOL) endPage {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *s = [documentsDirectory stringByAppendingPathComponent:@"2.pdf"];
//    NSString *html = @"\n<div name=\"111301\">\n\t<table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"1\"\n\t\tstyle=\"font-size:10\">\n\t\t<tr>\n\t\t\t<td align=\"left\" style=\"font-size:12\">\n\t\t\t\t<B>&nbsp;&nbsp;&nbsp;&nbsp;民⽣生安康定期寿险(111301)-----------------------------</B>\n\t\t\t</td>\n\t\t</tr>\n\t\t\n\t\t<tr>\n\t\t\t<td align=\"left\">\n\t\t\t\t<B>&nbsp;&nbsp;&nbsp;&nbsp;⾝身故保险⾦金:</B>\n\t\t\t</td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td align=\"left\">\n\t\t\t\t<div>&nbsp;&nbsp;&nbsp;&nbsp;被保险⼈人于本合同⽣生效(或复效)之⽇日起⼀一年内因疾病⾝身故,本公司不承担给付⾝身故保险⾦金的责任,本公司向您⽆无息返 还所交保险费,本合同终⽌止。</div>\n\t\t\t\t<div>&nbsp;&nbsp;&nbsp;&nbsp;被保险⼈人因意外伤害⾝身故或于本 合同⽣生效(或复效)之⽇日起⼀一年后因疾病⾝身故,本公司按保险单载明的保险⾦金额给付⾝身 故保险⾦金,本合同终⽌止。</div>\n\t\t\t</td>\n\t\t</tr>\n\t</table>\n</div>\n";
    pdf = [NDHTMLtoPDF createPDFWithHTML:HTML pathForPDF:s pageSize:PageSize margins:UIEdgeInsetsMake(50, 20, 50, 20) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
        
        [self pdfWithPdfPath:pdfPath drawTexts:textArray onImage:image andImageRect:imageRect linesArray:lineArray];
        
        
    } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
        
        
    }];
}
- ( void ) pdfWithPdfPath:( NSString * ) pdfSavePath drawTexts:( NSArray * ) textArray onImage:( UIImage * ) image andImageRect:( NSValue * ) imageRect linesArray:(NSArray *) lineArray {
    
    // File URLs - bridge casting for ARC
    CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath: (NSString *)pdfSavePath];//(CFURLRef) NSURL
    CFURLRef pdfURL2 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath: (NSString *)tmpPath];//(CFURLRef)
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:  (NSString *)pdfSavePath];//(CFURLRef)
    
    // File references
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
    CGPDFDocumentRef pdfRef2 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL2);
    
    // Number of pages
    NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
    NSInteger numberOfPages2 = CGPDFDocumentGetNumberOfPages(pdfRef2);
    
    CFMutableDictionaryRef myDictionary = NULL;
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    CFDictionarySetValue(myDictionary, kCGPDFContextSubject, CFSTR("My Subject"));
    CGPDFDictionaryRef pdfDocDictionary = CGPDFDocumentGetCatalog(pdfRef1);
    CGPDFDictionaryApplyFunction(pdfDocDictionary, ListDictionaryObjects, NULL);
    
    // Create the output context
    CGContextRef writeContext = CGPDFContextCreateWithURL(pdfURLOutput, NULL, NULL);
    
    // Loop variables
    CGPDFPageRef page;
    CGRect mediaBox;
    
    // Read the first PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 1 (%li)...", (long)numberOfPages1);
    for (int i=1; i<=numberOfPages1; i++) {
        page = CGPDFDocumentGetPage(pdfRef1, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        CGContextDrawPDFPage(writeContext, page);
        CGContextEndPage(writeContext);
    }
    
    // Read the second PDF and generate the output pages
    NSLog(@"GENERATING PAGES FROM PDF 2 (%li)...", (long)numberOfPages2);
    page = CGPDFDocumentGetPage(pdfRef2, 1);
    mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextBeginPage(writeContext, &mediaBox);
    
    CGRect imageNewRect = [imageRect CGRectValue];
    CGContextDrawImage(writeContext, imageNewRect, [image CGImage]); //绘制图片
    CGContextSetTextDrawingMode (writeContext, kCGTextFill);
    CGContextSetRGBFillColor (writeContext, 0, 0, 0, 1);
    UIGraphicsPushContext(writeContext);
    CGContextTranslateCTM(writeContext, 0, PageSize.height);
    CGContextScaleCTM(writeContext, 1, -1);
    
    for ( int i = 0 ; i < [textArray count] ; i ++ ) {
        
        NSDictionary *textObject = [textArray objectAtIndex:i];
        UIFont *font = [textObject objectForKey:kPDFTextFont];
        NSString *text = [textObject objectForKey:kPDFText];
        CGRect textRect = [[textObject objectForKey:kPDFRect] CGRectValue];
        UIColor *color = [textObject objectForKey:kPDFTextColor];
        NSTextAlignment alignment = (NSTextAlignment) [[textObject objectForKey:kPDFTextAlignment] integerValue];
        NSLineBreakMode lineBreakMode = (NSLineBreakMode) [[textObject objectForKey:kPDFLineBreakMode] integerValue];
        
        CGContextSetFillColorWithColor(writeContext, [color CGColor]);
        
        CGRect textSize = [text boundingRectWithSize:textRect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
        
        CGRect drawRect = CGRectMake(textRect.origin.x, textRect.origin.y, textRect.size.width, textSize.size.height);
        [text drawInRect:drawRect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
        
    }
    
    for ( int i = 0 ; i < [lineArray count]; i ++ ) {
        
        CGRect rect = [[[lineArray objectAtIndex:i] objectForKey:kPDFRect] CGRectValue];
        CGFloat lineWidth = rect.size.height;
        CGSize lineSize = CGSizeMake(rect.origin.x + rect.size.width, rect.origin.y);
        if (rect.size.height > rect.size.width) {
            
            lineWidth = rect.size.width;
            lineSize = CGSizeMake(rect.origin.x, rect.origin.y + rect.size.height);
        }
        UIColor *color = [UIColor blackColor];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        CGContextSetLineWidth(context, lineWidth);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, lineSize.width, lineSize.height);
        CGContextStrokePath(context);
    }
//    //将需要绘制的层pop
//    UIGraphicsPopContext();
//    CGContextStrokePath(writeContext);
//    
    CGContextTranslateCTM(writeContext, 0, PageSize.height);
    CGContextScaleCTM(writeContext, 1, -1);
    CGContextDrawPDFPage(writeContext, page);
    CGContextEndPage(writeContext);
    NSLog(@"DONE!");
    
    
    // Finalize the output file
    CGPDFContextClose(writeContext);
    
    // Release from memory
    CFRelease(pdfURL1);
    //    CFRelease(pdfURL2);
    CFRelease(pdfURLOutput);
    CGPDFDocumentRelease(pdfRef1);
    //    CGPDFDocumentRelease(pdfRef2);
    CGContextRelease(writeContext);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"generalSuccess" object:pdfSavePath];
}

void ListDictionaryObjects (const char *key, CGPDFObjectRef object, void *info) {
    NSLog(@"key: %s", key);
    CGPDFObjectType type = CGPDFObjectGetType(object);
    if (type == kCGPDFObjectTypeDictionary) {
        CGPDFDictionaryRef objectDictionary;
        if (CGPDFObjectGetValue(object, kCGPDFObjectTypeDictionary, &objectDictionary)) {
            CGPDFDictionaryApplyFunction(objectDictionary, ListDictionaryObjects, NULL);
        }
    }
    else if (type == kCGPDFObjectTypeInteger) {
        CGPDFInteger objectInteger;
        if (CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &objectInteger)) {
            NSLog(@"pdf integer value: %ld", (long int)objectInteger);
        }
    }
}
@end
