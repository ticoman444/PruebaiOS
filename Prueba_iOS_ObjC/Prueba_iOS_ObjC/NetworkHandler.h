//
//  NetworkHandler.h
//  Prueba_iOS_ObjC
//
//  Created by Humberto Cetina on 2/25/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandler : NSObject
- (void) jSonWithUrl:(NSString *)url andBlock:(void(^)(NSDictionary* , NSError* ))block;
@end
