//
//  AbstractRequest.m
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "AbstractRequest.h"

@implementation AbstractRequest

- (NSURLRequest *)request
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.envertlaterre.fr/PHP/%@", [self serviceEndpoint]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
 
    NSString *post = [self postArguments];
    
    //NSLog(@"%@", post);
    
    if (post.length > 0) {
        NSData *dataToSend =[NSData dataWithBytes:[post UTF8String] length:[post length]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:dataToSend];
    } else {
        [request setHTTPMethod:@"GET"];
    }
    
    return request;

}

- (NSString *)postArguments
{
    return @"subclasses should override";
}

- (NSString *)serviceEndpoint
{
    return @"subclasses should override";
}

- (id)parseObject:(id)object
{
    return nil;
}

@end
