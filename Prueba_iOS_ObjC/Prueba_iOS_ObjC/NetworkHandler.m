//
//  NetworkHandler.m
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/25/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import "NetworkHandler.h"

@implementation NetworkHandler

- (void) jSonWithUrl:(NSString *)url andBlock:(void(^)(NSDictionary *dic, NSError *error))block{
 
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encondedUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encondedUrlString]
           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        
        if (error)
        {
            block(nil, error); return;
        }
        
        NSError *jsonError;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!jsonError)
        {
            block(jsonDic, nil);
        }
        else
        {
            block(nil, jsonError);
        }
        
    }] resume];
}

@end
