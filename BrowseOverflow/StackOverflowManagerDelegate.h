//
//  StackOverflowManagerDelegate.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Topic;

@protocol StackOverflowManagerDelegate <NSObject>

- (void)fetchingQuestionsFailedWithError:(NSError*)error;
- (void)didReceivedQuestions:(NSArray*)questions;

- (void)fetchingBodyFailedWithError:(NSError*)error;

@end
