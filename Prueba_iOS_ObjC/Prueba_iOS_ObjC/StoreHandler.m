//
//  StoreHandler.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "StoreHandler.h"
#import <Realm.h>
#import "App.h"
#import "Category.h"

@implementation StoreHandler

- (NSString *) imageNameFromCategoryName:(NSString *)categoryName{

    if ([categoryName isEqualToString:@"Undefined"])
    {
        return @"undefined_image";
    }
    else if ([categoryName isEqualToString:@"Sports"])
    {
        return @"sport_image";
    }
    else if ([categoryName isEqualToString:@"Games"])
    {
        return @"games_image";
    }
    else if ([categoryName isEqualToString:@"Lifestyles"])
    {
        return @"life_style_image";
    }
    else if ([categoryName isEqualToString:@"Entertainment"])
    {
        return @"entertainment_image";
    }
    
    return @"";
}

- (void) createLocalDataBaseWIthJson:(NSDictionary *)dic{
 
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if (dic)
    {
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
    }
    
    NSMutableDictionary *categories = [NSMutableDictionary dictionary];
    
    NSArray *children = dic[@"data"][@"children"];
    
    for (NSDictionary *child in children)
    {
        NSDictionary *interestingData = child[@"data"];
        
        App *newApp = [[App alloc] init];
        newApp.bannerImg    = (![interestingData[@"banner_img"]     isKindOfClass:[NSNull class]]) ? interestingData[@"banner_img"]    : @"";
        newApp._id          = (![interestingData[@"id"]             isKindOfClass:[NSNull class]]) ? interestingData[@"id"]            : @"";
        newApp.summitText   = (![interestingData[@"submit_text"]    isKindOfClass:[NSNull class]]) ? interestingData[@"submit_text"]   : @"";
        newApp.displayText  = (![interestingData[@"display_name"]   isKindOfClass:[NSNull class]]) ? interestingData[@"display_name"]  : @"";
        newApp.title        = (![interestingData[@"title"]          isKindOfClass:[NSNull class]]) ? interestingData[@"title"]         : @"";
        newApp.iconImg      = (![interestingData[@"icon_img"]       isKindOfClass:[NSNull class]]) ? interestingData[@"icon_img"]      : @"";
        
        NSString *categoryName = (![interestingData[@"advertiser_category"] isKindOfClass:[NSNull class]]) ? interestingData[@"advertiser_category"]: @"Undefined";
        Category *currentCategory = categories[categoryName];
        
        if (currentCategory)
        {
            newApp.category = currentCategory;
        }
        else
        {
            currentCategory = [[Category alloc] init];
            currentCategory._id = categoryName;
            currentCategory.name = categoryName;
            currentCategory.imageName = [self imageNameFromCategoryName:categoryName];
            categories[categoryName] = currentCategory;
            
            [realm transactionWithBlock:^{
                [realm addObject:currentCategory];
            }];
        }
        
        [realm transactionWithBlock:^{
            [realm addObject:newApp];
        }];
    }
}

@end
