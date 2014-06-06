//
// Created by francesco bigagnoli on 07/04/14.
// Copyright (c) 2014 BF. All rights reserved.
//

#import "Person.h"


@implementation Person


- (id)initWithName:(NSString*)aName avatarLocation:(NSString*) aLocation
{
    if (self = [super init]){
        _name = [aName copy];
        _avatarUrl = [[NSURL alloc] initWithString:aLocation];
    }
    return self;
}


@end