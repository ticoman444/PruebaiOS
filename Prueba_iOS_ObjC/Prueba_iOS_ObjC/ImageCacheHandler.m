//
//  ImageCacheHandler.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/26/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "ImageCacheHandler.h"


@implementation ImageCacheHandler

- (NSString *) imageNameFromUrl:(NSString *)url{
    
    NSArray *urlSeparated = [url componentsSeparatedByString:@"/"];
    NSString *imageName = urlSeparated.lastObject;
    return imageName;
}

- (void) imageForUrl:(NSString *)url withBlock:(void(^)(UIImage *image))block{
    
    NSURL *tmpFolderUrl = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    
    NSString *imageName = [self imageNameFromUrl:url];
    NSURL *imageUrl = [tmpFolderUrl URLByAppendingPathComponent:imageName];
    UIImage *cacheImage = [UIImage imageWithContentsOfFile:imageUrl.path];
    
    if (cacheImage)
    {
        block(cacheImage);
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *imageNameEncoded = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        [[session dataTaskWithURL:[NSURL URLWithString:imageNameEncoded]
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
            
            if (error)
            {
                block(nil);
            }
            else
            {
                [data writeToURL:imageUrl atomically:YES];
                UIImage *imageCached = [UIImage imageWithData:data];
                block(imageCached);
            }
        }] resume];
    }
}

@end
