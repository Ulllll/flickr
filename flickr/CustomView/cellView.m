//
//  cellView.m
//  flickr
//
//  Created by Анастасия Рябова on 10/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "cellView.h"

@interface cellView ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation cellView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
        _imgView.center = self.view.center;
        [self.view addSubview:_imgView];
        [_imgView didMoveToSuperview];
    }
    return self;
}

- (void)setImg:(UIImage *)img
{
    [self.imgView setImage: img];
}
@end
