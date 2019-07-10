//
//  collectionViewController.h
//  flickr
//
//  Created by Анастасия Рябова on 10/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface collectionViewController : UICollectionViewController

- (void)downloadString:(NSString *)searchString;

@end

NS_ASSUME_NONNULL_END
