#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NDHTMLtoPDF.h"

#define PageSize CGSizeMake(595.2,841.8)

@interface GeneralPDF : NSObject {
    
    NDHTMLtoPDF *pdf;
}

- ( id ) initWithPath:(NSString *) pdfPath ;

- ( void ) drawTexts:( NSArray * ) textArray onImage:( UIImage * ) image andImageRect:( NSValue * ) imageRect linesArray:(NSArray *) lineArray beginPage:(BOOL) beginPage endPage:(BOOL) endPage ;

- ( void ) drawTexts:( NSArray * ) textArray andHTML:( NSString * ) HTML onImage:( UIImage * ) image andImageRect:( NSValue * ) imageRect linesArray:(NSArray *) lineArray beginPage:(BOOL) beginPage endPage:(BOOL) endPage ;

- ( void ) releaseContext ;

@end