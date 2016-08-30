//
//  AbstractRequest.h
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AbstractRequest : NSObject

- (NSURLRequest *)request;

#pragma mark - Overriden by subclasses

- (NSString *)postArguments;
- (NSString *)serviceEndpoint;
- (id)parseObject:(id)object;

@end
