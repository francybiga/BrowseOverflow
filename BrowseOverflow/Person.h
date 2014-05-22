//
// Created by francesco bigagnoli on 07/04/14.
// Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *avatarUrl;

- (id)initWithName:(NSString*)aName avatarLocation:(NSString*) aLocation;

@end