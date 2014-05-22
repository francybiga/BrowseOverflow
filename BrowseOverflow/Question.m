//
//  Question.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 03/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)init
{

    if (self =[super init]){
        answerSet = [[NSMutableSet alloc]init];
    }
    return self;
}

- (void)addAnswer:(Answer *)answer
{
    [answerSet addObject:answer];
}

- (NSArray*)answers
{
    return [[answerSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

@end
