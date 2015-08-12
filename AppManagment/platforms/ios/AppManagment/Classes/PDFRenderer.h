//
//  PDFRenderer.h
//  iOSPDFRenderer
//
//  Created by Tope on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFDrawInfo.h"

@interface PDFRenderer : NSObject


+ ( void ) drawPDF:( NSString * ) fileName data:( id ) data ;

+ ( void ) drawLineFromPoint:( CGPoint ) from toPoint:( CGPoint ) to ;

+ ( void ) drawImage:( UIImage * ) image inRect:( CGRect ) rect ;

+ ( void ) drawText:( NSString * ) textToDraw inFrame:( CGRect ) frameRect ;

+ ( void ) drawTextInfo:( PDFDrawInfo * ) textInfo ;
+ ( void ) drawImageInfo:( PDFDrawInfo * ) imageInfo ;
+ ( void ) drawLineInfo:( PDFDrawInfo * ) pointInfo ;


+ (void) saveWithBasePDFPath:(NSString *) basePath;

+(void)drawTableAt:(CGPoint)origin 
     withRowHeight:(int)rowHeight 
    andColumnWidth:(int)columnWidth 
       andRowCount:(int)numberOfRows 
    andColumnCount:(int)numberOfColumns;


+(void)drawTableDataAt:(CGPoint)origin 
         withRowHeight:(int)rowHeight 
        andColumnWidth:(int)columnWidth 
           andRowCount:(int)numberOfRows 
        andColumnCount:(int)numberOfColumns;

@end
