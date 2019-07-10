//
//  NetworkService.h
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceProtocol.h"

@interface NetworkService : NSObject<NetworkServiceIntputProtocol, NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> output;

@end

