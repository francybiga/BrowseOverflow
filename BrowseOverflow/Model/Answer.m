//
//  Answer.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 08/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "Answer.h"
#import "Person.h"

@implementation Answer

- (NSComparisonResult) compare: (Answer *)otherAnswer
{
    if (self.accepted && !(otherAnswer.accepted)){
        return NSOrderedAscending;
    } else if (!self.accepted && otherAnswer.accepted){
        return NSOrderedDescending;
    }
    if (self.score > otherAnswer.score){
        return NSOrderedAscending;
    } else if (self.score < otherAnswer.score){
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end
