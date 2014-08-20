//
//  FakeURLResponse.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 20/08/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "FakeURLResponse.h"

@implementation FakeURLResponse

- (instancetype)initWithStatusCode:(NSInteger)code
{
    if (self = [super init]) {
        _statusCode = code;
    }
    return self;
}

@end
