//
//  MockStackOverflowManagerDelegate.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "MockStackOverflowManagerDelegate.h"

@interface MockStackOverflowManagerDelegate ()

@property (nonatomic, strong, readwrite) NSError *fetchError;
@property (nonatomic, strong, readwrite) NSArray *receivedQuestions;
@property (nonatomic, strong, readwrite) NSArray *receivedAnswers;

@end

@implementation MockStackOverflowManagerDelegate


#pragma mark - StackOverflowManagerDelegate

- (void)fetchingBodyFailedWithError:(NSError*)error
{
    self.fetchError = error;
}


- (void)fetchingQuestionsFailedWithError:(NSError*)error
{
    self.fetchError = error;
}

- (void)didReceivedQuestions:(NSArray *)questions
{
    self.receivedQuestions = questions;
}

- (void)didReceivedAnswers:(NSArray *)answers
{
    self.receivedAnswers = answers;
}

@end
