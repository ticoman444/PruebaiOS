//
//  AppCollectionViewController.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "AppCollectionViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "DetailViewController.h"
#import "AppCollectionViewCell.h"
#import "ImageCacheHandler.h"
#import "Category.h"
#import "App.h"

@interface AppCollectionViewController ()
@property (nonatomic, strong) RLMResults<App *> *dataSource;
@property (nonatomic, strong) ImageCacheHandler *imageHandler;
@end

@implementation AppCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (BOOL) navigationShouldPopOnBackButton {
    
    if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
         self.traitCollection.displayScale == 3.0))
    {
        [self.navigationController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationController.navigationBar.shadowImage = nil;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shadow"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

    if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
         self.traitCollection.displayScale == 3.0))
    {
        [self.navigationController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shadow"] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
    
    
    self.imageHandler = [[ImageCacheHandler alloc] init];
    
    
    if (_category)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"category.name = %@", _category.name];
        self.dataSource =  [App objectsWithPredicate:pred];
    }
    else
    {
        self.dataSource =  [App allObjects];
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
     NSIndexPath *indexPath = indexPaths.firstObject;
     
     UINavigationController *nacController = segue.destinationViewController;
     DetailViewController *controller = (DetailViewController *)nacController.viewControllers.firstObject;
     controller.app = [_dataSource objectAtIndex:indexPath.row];
 }

#pragma mark <UICollectionViewDataSource>

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AppCollectionViewCell *appCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCell" forIndexPath:indexPath];
    
    App *app = [_dataSource objectAtIndex:indexPath.row];
    appCell.appTitle.text = app.title;
    appCell.appDescription.text = app.summitText;
    appCell.appImage.contentMode = (app.bannerImg.length != 0) ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
    
    NSString *imageUlr = (app.bannerImg.length != 0) ? app.bannerImg : app.iconImg;
    
    if (imageUlr.length == 0)
    {
        appCell.appImage.image = [UIImage imageNamed:@"no_image"];
    }
    else
    {
        [_imageHandler imageForUrl:imageUlr withBlock:^(UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                appCell.appImage.image = image;
            });
        }];
    }
    
    return appCell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(182, 182);
}

- (void) collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:cell.layer.transform],
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1)];
    animation.duration = 0.3;
    
    cell.layer.transform = CATransform3DMakeScale(0.85, 0.85, 1);
    [cell.layer addAnimation:animation forKey:@"basic"];
}

- (void) collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:cell.layer.transform],
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)];
    animation.duration = 0.1;
    
    cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    [cell.layer addAnimation:animation forKey:@"basic"];
}

@end
