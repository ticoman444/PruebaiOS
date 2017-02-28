//
//  CategoryViewController.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/25/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "CategoryViewController.h"
#import <Realm.h>
#import <AFNetworking.h>
#import "AGPushNoteView.h"

#import "NetworkHandler.h"
#import "StoreHandler.h"

#import "CategoryTableViewCell.h"
#import "UIViewController+ViewControllerShowing.h"
#import "Category.h"

#import "AppsTableViewController.h"
#import "AppCollectionViewController.h"

@interface CategoryViewController ()
@property (nonatomic, strong) RLMResults<Category *> *dataSource;
@property (nonatomic) BOOL isIpadOrIphonePlus;
@end

@implementation CategoryViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.isIpadOrIphonePlus = self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad ||
    (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPhone && self.traitCollection.displayScale == 3.0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDetailTargetDidChange:)
                                                 name:UIViewControllerShowDetailTargetDidChangeNotification
                                               object:nil];
    
    void (^loadObjects)(void) = ^{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataSource = [Category allObjects];
            [self.tableView reloadData];
        });
    };
    
    void (^createDatabase)(void) = ^{
        
        NetworkHandler *handler = [[NetworkHandler alloc] init];
        [handler jSonWithUrl:@"https://www.reddit.com/reddits.json" andBlock:^(NSDictionary *dic, NSError *error) {
            
            if (!error)
            {
                StoreHandler *storeHandler = [[StoreHandler alloc] init];
                [storeHandler createLocalDataBaseWIthJson:dic];
                loadObjects();
            }
        }];
    };
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            AGPushNote *message = [[AGPushNote alloc] init];
            [message setDefaultUI];
            message.message = @"Funcionando en modo Offline";
            message.iconImage = [UIImage imageNamed:@"no_wifi"];
            message.showAtBottom = YES;
            [AGPushNoteView showNotification:message];
            [AGPushNoteView setCloseAction:^{}];
            [AGPushNoteView setMessageAction:^(AGPushNote *pushNote) {}];
            loadObjects();
        }
        else
        {
            [AGPushNoteView closeWithCompletion:^{}];
            createDatabase();
        }
    }];
    
    [manager startMonitoring];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-------------------------------------------------------------------------------------

- (void) showDetailTargetDidChange:(NSNotification *)notification{
    
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self tableView:self.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    if ([segue.identifier isEqualToString:@"ShowApp"])
    {
        AppsTableViewController *controller = (AppsTableViewController *)segue.destinationViewController;
        controller.category = (indexPath.row == 0) ? nil : [_dataSource objectAtIndex:indexPath.row - 1];
    }
    else if ([segue.identifier isEqualToString:@"ShowApp_iPad"])
    {
        UINavigationController *navController = segue.destinationViewController;
        AppCollectionViewController *controller = (AppCollectionViewController *)navController.viewControllers.firstObject;
        controller.category = (indexPath.row == 0) ? nil : [_dataSource objectAtIndex:indexPath.row - 1];
    }
}

//-------------------------------------------------------------------------------------

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 67.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     return _dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = (_isIpadOrIphonePlus) ? @"CategoryCell_iPad" : @"CategoryCell";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    CategoryTableViewCell *categoryCell = (CategoryTableViewCell *)cell;

    if (indexPath.row == 0)
    {
        NSString *imageName  = (_isIpadOrIphonePlus) ? @"all_ipad_image" : @"all_iphone_image";
        categoryCell.categoryLabel.text = @"Mostrar todo";
        categoryCell.categoryImage.image = [UIImage imageNamed:imageName];
    }
    else
    {
        Category *category = [_dataSource objectAtIndex:indexPath.row - 1];
        categoryCell.categoryLabel.text = ([category.name isEqualToString:@"Undefined"]) ? @"Sin Categoría" : category.name;
        categoryCell.categoryImage.image = [UIImage imageNamed:category.imageName];
    }
    
    categoryCell.accessoryType = ([self willShowingDetailViewControllerPushWithSender:self]) ? UITableViewCellAccessoryDisclosureIndicator: UITableViewCellAccessoryNone;
}

@end
