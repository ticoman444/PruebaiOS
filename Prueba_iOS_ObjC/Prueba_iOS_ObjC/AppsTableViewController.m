//
//  AppsTableViewController.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "AppsTableViewController.h"
#import "DetailViewController.h"
#import "AppTableViewCell.h"
#import "ImageCacheHandler.h"
#import "Category.h"
#import "App.h"

@interface AppsTableViewController ()
@property (nonatomic, strong) RLMResults<App *> *dataSource;
@property (nonatomic, strong) ImageCacheHandler *imageHandler;
@property (nonatomic) BOOL isIpadOrIphonePlus;
@end

@implementation AppsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imageHandler = [[ImageCacheHandler alloc] init];
    self.isIpadOrIphonePlus = self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad ||
    (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && self.traitCollection.displayScale == 3.0);
    
    if (_category)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"category.name = %@", _category.name];
        self.dataSource =  [App objectsWithPredicate:pred];
    }
    else
    {
        self.dataSource =  [App allObjects];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 106.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    AppTableViewCell *appCell = (AppTableViewCell *)cell;
    App *app = [_dataSource objectAtIndex:indexPath.row];
    appCell.appTitle.text = app.title;
    appCell.appDescription.text = app.summitText;
    appCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *imageUlr = (app.iconImg.length != 0) ? app.iconImg : app.bannerImg;
    
    if (imageUlr.length == 0)
    {
        appCell.appImage.image = [UIImage imageNamed:@"no_image_black"];
    }
    else
    {
        [_imageHandler imageForUrl:imageUlr withBlock:^(UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                appCell.appImage.image = image;
            });
        }];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
    controller.app = [_dataSource objectAtIndex:indexPath.row];
}


@end
