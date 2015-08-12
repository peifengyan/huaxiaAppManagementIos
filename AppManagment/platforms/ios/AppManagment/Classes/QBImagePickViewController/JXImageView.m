//
//  JXImageView.m
//  PhotoDemo
//
//  Created by andy on 14-1-18.
//
//

#import "JXImageView.h"

@implementation JXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置圆角
        CALayer *layer = self.layer;
        [layer setMasksToBounds:YES];
        layer.cornerRadius = 10.0;
    }
    return self;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
