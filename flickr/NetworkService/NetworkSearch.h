//
//  NetworkSearch.h
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkSearch : NSObject

+ (NSString *)URLForSearchString:(NSString *)searchString;

@end

NS_ASSUME_NONNULL_END
