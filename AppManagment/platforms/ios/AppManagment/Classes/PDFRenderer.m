//
//  PDFRenderer.m
//  iOSPDFRenderer
//
//  Created by Tope on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
//#import "GeneralPDF.h"

#define PageSize CGSizeMake(595.2,841.8)

NSMutableArray *resultArray;

@implementation PDFRenderer

+(void)drawPDF:(NSString*)fileName data:( id ) data {
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectMake(0, 0, PageSize.width, PageSize.height), nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, PageSize.width, PageSize.height), nil);
    
    PDFDrawInfo *pdf = [[PDFDrawInfo alloc] init];
    pdf.kText = @"呈敬:张学友先生";
    pdf.kTextFont = [UIFont systemFontOfSize:12];
    pdf.kTextFontName = @"STHeitiSC-Medium";
    pdf.kColor = [UIColor blackColor];
    pdf.kTextFontSize = 12.0f;
    pdf.kRect = CGRectMake(PageSize.width - 320, 35, 300, 25);
    pdf.kTextAlignment = kCTTextAlignmentRight;
    pdf.kLineBreakMode = kCTLineBreakByWordWrapping;
    [self drawTextInfo:pdf];
    
    pdf.kText = @"理财顾问:mrzhou 业务代码:8611018517";
    pdf.kRect = CGRectMake(PageSize.width - 320, 55, 300, 25);
    [self drawTextInfo:pdf];
    
    pdf.kText = @"￼郑重声明:本保障计划单位为人民币元,假定被保险人为标准体,所列产品、费率、基本保险金额等与保险合 同不一定一致,请以保险合同为准。";
    pdf.kRect = CGRectMake(40, PageSize.height + 55, PageSize.width - 80, 100);
    pdf.kTextAlignment = kCTTextAlignmentLeft;
    [self drawTextInfo:pdf];

    pdf.kPointArray = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(20, 50)], [NSValue valueWithCGPoint:CGPointMake(PageSize.width - 40, 50)], nil];
    pdf.kColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self drawLineInfo:pdf];
    
    pdf.kPointArray = [NSMutableArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(20, PageSize.height - 50)], [NSValue valueWithCGPoint:CGPointMake(PageSize.width - 40, PageSize.height - 50)], nil];
    [self drawLineInfo:pdf];

    [self drawImage: [UIImage imageNamed:@"default_logo_temple.png"] inRect:CGRectMake(20, 25, 173, 23)];
    
    int xOrigin = 20;
    int yOrigin = 100;
    
    resultArray = [data mutableCopy];
    
    int numberOfRows = [[[resultArray objectAtIndex:0] objectForKey:@"data"] count] + 1;
    int numberOfColumns = [resultArray count];
    
    int rowHeight = 20;
    int columnWidth = 80;

    [self drawTableAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    [self drawTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
//    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"path"];
//    [self pdfWithPdfPath:path];
}

+ ( void ) drawLineFromPoint:( CGPoint ) from toPoint:( CGPoint ) to {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}
+ ( void ) drawLineInfo:( PDFDrawInfo * ) pointInfo {
    
    CGPoint from = [[pointInfo.kPointArray objectAtIndex:0] CGPointValue];
    CGPoint to = [[pointInfo.kPointArray objectAtIndex:1] CGPointValue];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    UIColor *uiColor = pointInfo.kColor;
    CGColorRef color = [uiColor CGColor];
    
    CGContextSetStrokeColorWithColor(context, color);
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
}

#pragma mark - 绘制图片
+ ( void ) drawImage:( UIImage * ) image inRect:( CGRect ) rect {
    
    [image drawInRect:rect];
}
+ ( void ) drawImageInfo:( PDFDrawInfo * ) imageInfo {
    
    [self drawImage:imageInfo.kImage inRect:imageInfo.kRect];
}
#pragma mark - 绘制文字
+ ( void ) drawTextInfo:( PDFDrawInfo * ) textInfo {
    
    NSString *fontName = textInfo.kTextFontName;
    CGFloat fontSize = textInfo.kTextFontSize;
    NSString *text = textInfo.kText;
    CGRect textRect = textInfo.kRect;
    CTTextAlignment textAlignment = textInfo.kTextAlignment;
    
    //    create attributed string
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) text);
    //    create font
    CTFontRef font = CTFontCreateWithName(( __bridge CFStringRef ) fontName, fontSize, NULL);
    //    create paragraph style and assign text alignment to it
    CTTextAlignment alignment = textAlignment;
    CTParagraphStyleSetting _settings[] = {    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
    //    set paragraph style attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    //    set font attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    //    release paragraph style and font
    CFRelease(paragraphStyle);
    CFRelease(font);
    
    CFStringRef stringRef = (__bridge CFStringRef) text;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef) attrStr);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, textRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, textRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1) * textRect.origin.y * 2);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}

+ ( void ) drawText:( NSString * ) textToDraw inFrame:( CGRect ) frameRect {
    //    create attributed string
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) textToDraw);
    //    create font
    CTFontRef font = CTFontCreateWithName(CFSTR("STHeitiSC-Medium"), 12, NULL);
    //    create paragraph style and assign text alignment to it
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CTParagraphStyleSetting _settings[] = {    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
    //    set paragraph style attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    //    set font attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    //    release paragraph style and font
    CFRelease(paragraphStyle);
    CFRelease(font);
    
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    // Prepare the text using a Core Text Framesetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef) attrStr);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
}

+ ( void ) drawTableAt:( CGPoint ) origin withRowHeight:( int ) rowHeight andColumnWidth:( int ) columnWidth andRowCount:( int ) numberOfRows andColumnCount:(int)numberOfColumns {
   
    for (int i = 0; i <= numberOfRows; i++) {
        
        int newOrigin = origin.y + (rowHeight*i);
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
    }
    
    for (int i = 0; i <= numberOfColumns; i++) {
        
        int newOrigin = origin.x + (columnWidth*i);
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        
        [self drawLineFromPoint:from toPoint:to];
    }
}

+(void)drawTableDataAt:(CGPoint)origin withRowHeight:(int)rowHeight andColumnWidth:(int)columnWidth andRowCount:(int)numberOfRows andColumnCount:(int)numberOfColumns {
    
    int padding = 5;
    
    for(int i = 0; i < [resultArray count]; i++) {
        
        NSDictionary* infoToDraw = [resultArray objectAtIndex:i];
        
        for (int j = 0; j < [[infoToDraw objectForKey:@"data"] count] + 1; j++) {
            
            int newOriginY = origin.y + ( (j + 1) * rowHeight );
            int newOriginX = origin.x + ( i * columnWidth );
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            if ( j == 0 ) {
                
                [self drawText:[infoToDraw objectForKey:@"title"] inFrame:frame];

            }
            else {
                
                NSString *string = [NSString stringWithFormat:@"%@",[[infoToDraw objectForKey:@"data"] objectAtIndex:j-1]];
                [self drawText:string inFrame:frame];
            }
        }
    }
}
+ (void) saveWithBasePDFPath:(NSString *) basePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // File paths
    NSString *pdfPath1 = [documentsDirectory stringByAppendingPathComponent:@"1.pdf"];
    NSString *pdfPath3 = [documentsDirectory stringByAppendingPathComponent:@"3.pdf"];
    NSString *pdfPath4 = [documentsDirectory stringByAppendingPathComponent:@"4.pdf"];

    NSString *pdfPathOutput = [documentsDirectory stringByAppendingPathComponent:@"out.pdf"];
    
    // File URLs - bridge casting for ARC
    CFURLRef pdfURL1 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath: (NSString *)pdfPath1];//(CFURLRef) NSURL
    CFURLRef pdfURL3 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath: (NSString *)pdfPath3];//(CFURLRef)
    CFURLRef pdfURL4 = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath: (NSString *)pdfPath4];//(CFURLRef)
    CFURLRef pdfURLOutput =(__bridge_retained CFURLRef) [[NSURL alloc] initFileURLWithPath:  (NSString *)pdfPathOutput];//(CFURLRef)
    
    // File references
    CGPDFDocumentRef pdfRef1 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL1);
    CGPDFDocumentRef pdfRef3 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL3);
    CGPDFDocumentRef pdfRef4 = CGPDFDocumentCreateWithURL((CFURLRef) pdfURL4);

    // Number of pages
    NSInteger numberOfPages1 = CGPDFDocumentGetNumberOfPages(pdfRef1);
    NSInteger numberOfPages3 = CGPDFDocumentGetNumberOfPages(pdfRef3);
    NSInteger numberOfPages4 = CGPDFDocumentGetNumberOfPages(pdfRef4);

    CFMutableDictionaryRef myDictionary = NULL;
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("My PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("My Name"));
    CFDictionarySetValue(myDictionary, kCGPDFContextSubject, CFSTR("My Subject"));
    CGPDFDictionaryRef pdfDocDictionary = CGPDFDocumentGetCatalog(pdfRef1);
    CGPDFDictionaryApplyFunction(pdfDocDictionary, ListDictionaryObject, NULL);
    //    CGPDFDocumentRelease(pdfDocument);
    
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
    
    NSLog(@"GENERATING PAGES FROM PDF 3 (%li)...", (long)numberOfPages3);
    for (int i=1; i<=numberOfPages3; i++) {
        
        page = CGPDFDocumentGetPage(pdfRef3, 1);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        
        CGContextStrokePath(writeContext);
        CGContextDrawPDFPage(writeContext, page);
        CGContextSetStrokeColorWithColor(writeContext, [UIColor clearColor].CGColor);
        CGContextEndPage(writeContext);
    }

    NSLog(@"GENERATING PAGES FROM PDF 4 (%li)...", (long)numberOfPages4);
    for (int i=1; i<=numberOfPages4; i++) {
        page = CGPDFDocumentGetPage(pdfRef4, i);
        mediaBox = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGContextBeginPage(writeContext, &mediaBox);
        
        CGContextStrokePath(writeContext);
        CGContextDrawPDFPage(writeContext, page);
        CGContextSetStrokeColorWithColor(writeContext, [UIColor clearColor].CGColor);
        CGContextEndPage(writeContext);
    }
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
    
    [[NSFileManager defaultManager] copyItemAtPath:pdfPathOutput toPath:pdfPathOutput error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"generalSucceed" object:pdfPathOutput];
}
void ListDictionaryObject (const char *key, CGPDFObjectRef object, void *info) {
    NSLog(@"key: %s", key);
    CGPDFObjectType type = CGPDFObjectGetType(object);
    switch (type) {
        case kCGPDFObjectTypeDictionary: {
            CGPDFDictionaryRef objectDictionary;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeDictionary, &objectDictionary)) {
                CGPDFDictionaryApplyFunction(objectDictionary, ListDictionaryObject, NULL);
            }
        }
        case kCGPDFObjectTypeInteger: {
            CGPDFInteger objectInteger;
            if (CGPDFObjectGetValue(object, kCGPDFObjectTypeInteger, &objectInteger)) {
                NSLog(@"pdf integer value: %ld", (long int)objectInteger);
            }
        }
    }
}

@end
