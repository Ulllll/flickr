//
//  ViewController.m
//  flickr
//
//  Created by Анастасия Рябова on 05/07/2019.
//  Copyright © 2019 Анастасия Рябова. All rights reserved.
//

#import "ViewController.h"
#import "collectionViewController.h"
@import UserNotifications;

@interface ViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) collectionViewController *collectionView;
@property (nonatomic, strong) NSString *lastSearch;

@end

static const NSString *identifierForActions = @"LCTReminderCategory";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Find image";
    
    [self initUI];
    [self setupConstraints];
}

- (void)initUI
{
    [self initSearchBar];
    [self initLayout];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.f)];
    self.searchBar.placeholder = @"What you whant to search?";
    self.searchBar.delegate = self;
    
    [self.view addSubview:self.searchBar];
}

- (void)initLayout
{
    UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
    
    newLayout.itemSize = CGSizeMake(self.view.frame.size.width/2-20.f, self.view.frame.size.width/2-20.f);
    
    self.collectionView = [[collectionViewController alloc] initWithCollectionViewLayout:newLayout];
    [self addChildViewController:self.collectionView];
    [self.view addSubview:self.collectionView.view];
    [self.collectionView didMoveToParentViewController:self];
}

- (void)setupConstraints
{
    self.collectionView.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray<NSLayoutConstraint *> *constraints =
    @[
      [self.collectionView.view.topAnchor constraintEqualToAnchor:self.searchBar.bottomAnchor constant:5.f],
      [self.collectionView.view.widthAnchor constraintEqualToConstant:self.view.frame.size.width],
      [self.collectionView.view.heightAnchor constraintEqualToConstant:self.view.frame.size.height],
      
      [self.searchBar.widthAnchor constraintEqualToConstant: self.view.frame.size.width],
      [self.searchBar.heightAnchor constraintEqualToConstant: 65.f],
      [self.searchBar.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:95.f],
      
      ];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self.collectionView downloadString:searchBar.text];
    self.lastSearch = self.searchBar.text;
    [self sheduleLocalNotification];
}

- (void)sheduleLocalNotification
{

    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Flickr notification";
    content.body = [NSString stringWithFormat:@"You have not been looking for '%@'", self.lastSearch];
    content.sound = [UNNotificationSound defaultSound];
    
    content.badge = @([self giveNewBadgeNumber] + 1);
    
    UNNotificationTrigger *intervalTrigger = [self intervalTrigger];
    
    NSString *identifier = @"NotificationId";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:intervalTrigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
     {
         if (error)
         {
             NSLog(@"Error:%@",error);
         }
     }];
}

- (UNTimeIntervalNotificationTrigger *)intervalTrigger
{
    return [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
}

- (NSInteger)giveNewBadgeNumber
{
    return [UIApplication sharedApplication].applicationIconBadgeNumber;
}

@end
