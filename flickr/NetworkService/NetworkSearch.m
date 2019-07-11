//
//  NetworkSearch.m
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "NetworkSearch.h"

@implementation NetworkSearch

+ (NSString *)URLForSearchString:(NSString *)searchString
{
    NSString *APIKey = @"5a8d2dd56754ab4d6948d9a9df438b4c";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=25&format=json&nojsoncallback=1", APIKey, searchString];
}

@end
