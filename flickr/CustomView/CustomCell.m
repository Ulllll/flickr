//
//  CustomCell.m
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "CustomCell.h"


@interface CustomCell()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _imgView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1];
        [self.contentView addSubview:_imgView];
        [_imgView didMoveToSuperview];
    }
    return self;
}

- (void)setImg:(UIImage *)img
{
    self.imgView.image = img;
}


- (void)preapeForReuse
{
    [super prepareForReuse];
    
    self.imgView.image = nil;
}

@end
