//
//  UIViewController+ViewControllerShowing.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "UIViewController+ViewControllerShowing.h"

@implementation UIViewController (ViewControllerShowing)

- (BOOL) willShowingViewControllerPushWithSender:(id)sender{
    
    UIViewController *taget = [self targetViewControllerForAction:@selector(willShowingViewControllerPushWithSender:)
                                                           sender:sender];
    if (taget)
    {
        return [taget willShowingViewControllerPushWithSender:sender];
    }
    else
    {
        return NO;
    }
}

- (BOOL) willShowingDetailViewControllerPushWithSender:(id)sender{
    
    UIViewController *taget = [self targetViewControllerForAction:@selector(willShowingDetailViewControllerPushWithSender:)
                                                           sender:sender];
    if (taget)
    {
        return [taget willShowingDetailViewControllerPushWithSender:sender];
    }
    else
    {
        return NO;
    }
}

@end

//---------------------------------------------------------------------------------------

@implementation UINavigationController (ViewControllerShowing)

- (BOOL) willShowingViewControllerPushWithSender:(id)sender{
    
    return YES;
}

@end

//---------------------------------------------------------------------------------------

@implementation UISplitViewController (ViewControllerShowing)


- (BOOL) willShowingViewControllerPushWithSender:(id)sender{
 
    return NO;
}

- (BOOL) willShowingDetailViewControllerPushWithSender:(id)sender{
    
    if (self.isCollapsed)
    {
        UIViewController *target = self.viewControllers.lastObject;
        
        if (target)
        {
            return [target willShowingViewControllerPushWithSender:sender];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

@end
