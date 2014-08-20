//
//  MockStackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowManagerDelegate.h"

@interface MockStackOverflowManagerDelegate : NSObject <StackOverflowManagerDelegate>

@property (nonatomic, strong,readonly) NSError *fetchError;
@property (nonatomic, strong,readonly) NSArray *receivedQuestions;
@property (nonatomic, strong,readonly) NSArray *receivedAnswers;

@end
