//
//  ImageCacheHandler.h
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCacheHandler : NSObject
- (void) imageForUrl:(NSString *)url withBlock:(void(^)(UIImage *image))block;
@end
