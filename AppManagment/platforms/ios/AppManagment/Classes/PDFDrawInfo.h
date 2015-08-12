//
//  PDFDrawInfo.h
//  AppManagment
//
//  Created by Elvis_J_Chan on 12/29/14.
//
//

#import <Foundation/Foundation.h>

#define PageSize CGSizeMake(595.2,841.8)

@interface PDFDrawInfo : NSObject

@property (nonatomic, copy) NSString *kText;
@property (nonatomic, copy) UIImage *kImage;
@property (nonatomic, copy) NSMutableArray *kPointArray;
@property (nonatomic, copy) UIFont *kTextFont;
@property (nonatomic, copy) NSString *kTextFontName;
@property (nonatomic, copy) UIColor *kColor;

@property (nonatomic) CGFloat kTextFontSize;
@property (nonatomic) CGRect kRect;
@property (nonatomic) CTTextAlignment kTextAlignment;
@property (nonatomic) CTLineBreakMode kLineBreakMode;

@end
