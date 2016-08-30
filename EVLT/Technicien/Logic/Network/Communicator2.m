//
//  Communicator.m
//  Commercial
//
//  Created by Benjamin Petit on 29/10/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "Communicator2.h"

@implementation Communicator

- (id)performRequest:(AbstractRequest *)request {
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request.request returningResponse:nil error:&error];
    
    if (error) {
        NSLog(@"Error fetching data : %@", error);
    }
    
    if (data) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        // DONNEES RECUES
       //  NSLog(@"%@ DONNEES RECUES", jsonObject);
        
        return [request parseObject:jsonObject];
    } else {
        return nil;
    }
}

@end
