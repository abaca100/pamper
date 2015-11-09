//
//  Recreation.h
//  Comic
//
//  Created by Jack Lee on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recreation : NSObject
{
    NSString *i_comicCode;
}

@property (strong, nonatomic) NSString *i_comicCode;

- (NSString *)serverURL;
- (NSString *)parseKeyword:(NSString *)html pre:(NSString *)key1 suffix:(NSString *)key2;
- (NSString *)nextPage:(NSString *)str pos:(NSString *)s;

@end
