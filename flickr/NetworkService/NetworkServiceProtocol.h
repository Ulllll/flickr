//
//  NetworkServiceProtocol.h
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

@protocol NetworkServiceOutputProtocol <NSObject>
@optional

- (void)loadingContinuesWithProgress:(double)progress;
- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved;

@end

@protocol NetworkServiceIntputProtocol <NSObject>
@optional

- (void)configureUrlSessionWithParams:(NSDictionary *)params;
- (void)startImageLoading;

- (BOOL)resumeNetworkLoading;
- (void)suspendNetworkLoading;

- (void)findFlickrPhotoWithSearchString:(NSString *)searcSrting  plus:(NSString *)page;

@end
