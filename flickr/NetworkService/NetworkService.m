//
//  NetworkService.m
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkSearch.h"
#import "CustomCell.h"

@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation NetworkService

- (void)configureUrlSessionWithParams:(NSDictionary *)params
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfiguration setAllowsCellularAccess:YES];
    if (params)
    {
        [sessionConfiguration setHTTPAdditionalHeaders:params];
    }
    else
    {
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    }


    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)findFlickrPhotoWithSearchString:(NSString *)searchSrting plus:(NSString *)page
{
    NSString *urlString = [NetworkSearch URLForSearchString:searchSrting];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&page=%@", page]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];

    NSURLSessionDataTask *sessionDataTask = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@", temp);

        NSString *farm;
        NSString *serverId;
        NSString *idSecret;
        NSString *stringFinalURL;
        
        dispatch_queue_t newQ = dispatch_queue_create("newQ", nil);
        for (id url in [temp valueForKeyPath:@"photos.photo"])
        {
            //        photos =     {
            //            page = 1;
            //            pages = 28014;
            //            perpage = 25;
            //            photo =         (
            //                             {
            //                                 farm = 66;
            //                                 id = 48248406167;
            //                                 isfamily = 0;
            //                                 isfriend = 0;
            //                                 ispublic = 1;
            //                                 owner = "73561613@N06";
            //                                 secret = 01634876e6;
            //                                 server = 65535;
            //                                 title = "High Tide Swells Up Sunrise Seascape";
            //                             },

            farm = [NSString stringWithFormat:@"farm%@", [url valueForKey:@"farm"]];
            serverId = [url valueForKey:@"server"];
            idSecret = [NSString stringWithFormat:@"%@_%@", [url valueForKey:@"id"], [url valueForKey:@"secret"]];
            stringFinalURL = [NSString stringWithFormat:@"https://%@.staticflickr.com/%@/%@.jpg", farm, serverId, idSecret];
            
            dispatch_async(newQ, ^{
                [self startImageLoadingWithString:stringFinalURL];
            });
        };

    }];
    [sessionDataTask resume];
}

- (void)startImageLoadingWithString:(NSString *)urlString
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:urlString]];
    [self.downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}


@end
