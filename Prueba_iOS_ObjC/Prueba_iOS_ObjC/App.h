//
//  App.h
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm.h>

@class Category;
@interface App : RLMObject

@property (nonatomic, strong) NSString *bannerImg;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *summitText;
@property (nonatomic, strong) NSString *displayText;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconImg;
@property (nonatomic, strong) Category *category;

@end
