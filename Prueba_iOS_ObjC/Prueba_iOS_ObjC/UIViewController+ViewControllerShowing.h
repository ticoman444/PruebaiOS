//
//  UIViewController+ViewControllerShowing.h
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (ViewControllerShowing)
- (BOOL) willShowingViewControllerPushWithSender:(id)sender;
- (BOOL) willShowingDetailViewControllerPushWithSender:(id)sender;
@end

@interface UINavigationController (ViewControllerShowing)
- (BOOL) willShowingViewControllerPushWithSender:(id)sender;
@end

@interface UISplitViewController (ViewControllerShowing)
- (BOOL) willShowingViewControllerPushWithSender:(id)sender;
- (BOOL) willShowingDetailViewControllerPushWithSender:(id)sender;
@end
