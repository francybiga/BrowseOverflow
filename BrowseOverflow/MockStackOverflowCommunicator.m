//
//  MockStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"

@interface MockStackOverflowCommunicator ()

@property (nonatomic, assign) BOOL wasAskedToFetchQuestions;
@property (nonatomic, assign) BOOL wasAskedToFetchBody;

@end

@implementation MockStackOverflowCommunicator

- (void)searchForQuestionsWithTag:(NSString*)tag{
    self.wasAskedToFetchQuestions = YES;
}

- (BOOL)wasAskedToFetchQuestions
{
    return _wasAskedToFetchQuestions;
}

- (BOOL)wasAskedToFetchBody
{
    return _wasAskedToFetchBody;
}

- (void)searchBodyForQuestion:(Question*)question
{
    self.wasAskedToFetchBody = YES;
}


@end
