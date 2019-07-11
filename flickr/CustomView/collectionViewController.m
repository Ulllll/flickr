//
//  collectionViewController.m
//  flickr
//
//  Created by Анастасия Рябова on 10/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkServiceProtocol.h"
#import "cellView.h"
#import "CustomCell.h"
#import "collectionViewController.h"

@interface collectionViewController() <NetworkServiceOutputProtocol>

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, copy) NSArray<UIImage *> *img;
@property (nonatomic, assign) NSInteger countPhotos;
@property (nonatomic, assign) NSInteger pageNow;

@end

@implementation collectionViewController

-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        _networkService = [NetworkService new];
        _networkService.output = self;
        [_networkService configureUrlSessionWithParams:nil];
        
        _img = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:206.0/255.0 blue:250.0/255.0 alpha:1];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    @try
    {
        [cell setImg:[self.img objectAtIndex:indexPath.row]];
        
    } @catch (NSException *exception)
    {
        
    } @finally {
        
    }

    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.countPhotos;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.img.count > 0)
    {
        cellView *cellViewNow = [cellView new];
        
        [UIView  beginAnimations: @"detailImgWithFilter"context: nil];
        [UIView setAnimationDuration:0.60];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseIn];

        UIImage *finalImage = [self setFilter: indexPath];
        
        [cellViewNow setImg:finalImage];
        
        [self.navigationController pushViewController: cellViewNow animated:NO];

        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    }
}

- (UIImage*) setFilter: (NSIndexPath *)indexPath
{
    CIContext *imageContext = [CIContext contextWithOptions:nil];
    CIImage *image = [[CIImage alloc]initWithImage:[self.img objectAtIndex:indexPath.row]];
    CIFilter *filter = [self getFilter:image];
    
    CIImage *result = [filter valueForKey: @"outputImage"];
    CGImageRef cgImageRef = [imageContext createCGImage:result fromRect:[result extent]];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImageRef];
    
    return finalImage;
}

- (CIFilter*) getFilter: (CIImage *)image
{
    CIFilter *filter;
    int randomNumber = arc4random_uniform(6);
    
    if (randomNumber == 0 || randomNumber == 3 || randomNumber == 5)
    {
        filter = [CIFilter filterWithName:@"CISepiaTone"
                                      keysAndValues: kCIInputImageKey, image,
                            @"inputIntensity", @1, nil];
        return filter;
    } else if (randomNumber == 1)
    {
        filter = [CIFilter filterWithName:@"CIDiscBlur"
                                      keysAndValues: kCIInputImageKey, image,
                            @"inputRadius", @3, nil];
        return filter;
    } else
    {
        filter = [CIFilter filterWithName:@"CILineOverlay"
                                      keysAndValues: kCIInputImageKey, image,
                            nil];
        return filter;
    }
    return nil;
}

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    UIImage *newImg = [[UIImage alloc] initWithData:dataRecieved];
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:self.img.mutableCopy];
    [newArray addObject:newImg];
    self.img = [newArray copy];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.img.count-1) inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)downloadString:(NSString *)searchString
{
    self.searchString = searchString;
    self.countPhotos = 25;
    self.pageNow = 0;
    
    self.img = [NSArray new];
    [self.collectionView reloadData];
    [self download];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.searchString isEqualToString:@""])
    {
        return;
        
    } else
    {
        self.countPhotos = self.countPhotos + 25;
        [self.collectionView reloadData];
        [self download];
    }
}

- (void)download
{
    self.pageNow = self.pageNow + 1;
    [self.networkService configureUrlSessionWithParams:nil];
    [self.networkService findFlickrPhotoWithSearchString:self.searchString plus:[NSString stringWithFormat:@"%li", self.pageNow]];
}

- (void)loadingContinuesWithProgress:(double)progress
{
    
}


@end
