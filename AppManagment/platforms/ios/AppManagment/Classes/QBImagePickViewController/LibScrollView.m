//
//  LibScrollView.m
//  PhotoDemo
//
//  Created by andy on 14-1-18.
//
//

#import "LibScrollView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerAssetView.h"
#import "JXImageView.h"
@implementation LibScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withPictures:(NSMutableOrderedSet *)set {
    self = [super initWithFrame:frame];
    if (self) {
        self.pictureSet = set;
        self.pickerViewArray = [[NSMutableArray alloc] init];
        
        self.scrollEnabled = YES;
    }
    return self;
}

- (void)refreshScrollView {
    // 移除所有的子视图
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    if (self.pickerViewArray.count == 0) {
        return;
    }
    NSInteger count = self.pickerViewArray.count;
    float length = self.frame.size.height-10;
    self.contentSize = CGSizeMake(5+(length+5)*count, length);
    
    int i = 0;
    for (QBImagePickerAssetView *pickerView in self.pickerViewArray) {
        UIImage *image = [self getImageFromAsset:pickerView.asset];
        JXImageView *imageView = [[JXImageView alloc] initWithImage:image];
        
        // 添加__圆角
        CALayer *layer = imageView.layer;
        [layer setMasksToBounds:YES];
        layer.cornerRadius = 5.0;
        
        imageView.pickerView = pickerView;
        imageView.tag = i;
        imageView.frame = CGRectMake(5+(length+5)*i, 5, length, length);
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        i++;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickerImageView:)];
        [imageView addGestureRecognizer:tap];
    }
    float offset_x = self.contentSize.width - self.frame.size.width;
    if (offset_x > 0) {
        [self setContentOffset:CGPointMake(offset_x, 0) animated:YES];
    }
}
- (void)removePickerImageView:(UITapGestureRecognizer *)tap {
    JXImageView *imageView = (JXImageView *)tap.view;
    [imageView removeFromSuperview];
    [imageView.pickerView touchImageView];
}
- (UIImage *)getImageFromAsset:(ALAsset *)asset {
    return [UIImage imageWithCGImage:[asset thumbnail]];
}

@end
