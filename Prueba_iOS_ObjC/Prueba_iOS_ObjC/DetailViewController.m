//
//  DetailViewController.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "DetailViewController.h"
#import "UIViewController+ViewControllerShowing.h"
#import "ImageCacheHandler.h"
#import "App.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *appImage;
@property (strong, nonatomic) IBOutlet UILabel *appTitle;
@property (strong, nonatomic) IBOutlet UILabel *appDescription;

@end

@implementation DetailViewController

- (BOOL) navigationShouldPopOnBackButton {
    
    if ((self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
         self.traitCollection.displayScale == 3.0))
    {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = nil;
    }
    
    return YES;
}

- (IBAction)dismissController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"shadow"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    
    if (![self.parentViewController.childViewControllers.firstObject isEqual:self])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    _appTitle.text = _app.title;
    _appDescription.text = _app.summitText;
    
    NSString *imageUlr = (_app.bannerImg.length != 0) ? _app.bannerImg : _app.iconImg;
    
    if (imageUlr.length == 0)
    {
        _appImage.image = [UIImage imageNamed:@"no_image_black"];
    }
    else
    {
        [[[ImageCacheHandler alloc] init] imageForUrl:imageUlr withBlock:^(UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _appImage.image = image;
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return 100;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
