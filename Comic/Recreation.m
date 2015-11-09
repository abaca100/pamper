//
//  Recreation.m
//  Comic
//
//  Created by Jack Lee on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recreation.h"


@implementation Recreation

@synthesize i_comicCode;

- (NSString *)serverURL
{
    NSLog(@"%@", i_comicCode);
    if (i_comicCode == nil) {
        i_comicCode = @"6";
    }
    if ([@"6" isEqualToString:i_comicCode] || [@"3" isEqualToString:i_comicCode]) {
        return @"http://mh.socomic.com/comiclist/%@/%@/%@";
    }
    return @"http://comic.kukudm.com/comiclist/%@/%@/%@";
}

- (NSString *)parseKeyword:(NSString *)html pre:(NSString *)key1 suffix:(NSString *)key2
{
    return nil;
}

- (NSString *)nextPage:(NSString *)str pos:(NSString *)s
{
    CGFloat pos = [str intValue];
    int cur = [s intValue];
	if (pos > 0) {
		cur--;
        if (cur <= 0) {
            cur = 0;
        }
	} else {
		cur++;
	}
    
    return [NSString stringWithFormat:@"%d", cur];
}

@end
