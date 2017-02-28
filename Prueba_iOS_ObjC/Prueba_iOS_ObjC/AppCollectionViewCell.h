//
//  AppCollectionViewCell.h
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/27/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *appImage;
@property (strong, nonatomic) IBOutlet UILabel *appTitle;
@property (strong, nonatomic) IBOutlet UILabel *appDescription;
@end
