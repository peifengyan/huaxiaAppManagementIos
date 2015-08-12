//
//  LibScrollView.h
//  PhotoDemo
//
//  Created by andy on 14-1-18.
//
//

#import <UIKit/UIKit.h>

@interface LibScrollView : UIScrollView

@property (nonatomic, strong) NSMutableOrderedSet *pictureSet;
@property (nonatomic, strong) NSMutableArray *pickerViewArray;

- (id)initWithFrame:(CGRect)frame withPictures:(NSMutableOrderedSet *)set;

- (void)refreshScrollView;

@end
