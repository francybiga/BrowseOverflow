//
//  MockStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "MockStackOverflowCommunicator.h"

@interface MockStackOverflowCommunicator ()

@property (nonatomic,assign) BOOL wasAskedToFetchQuestions;

@end

@implementation MockStackOverflowCommunicator

- (void)searchForQuestionsWithTag:(NSString*)tag{
    self.wasAskedToFetchQuestions = YES;
}

- (BOOL)wasAskedToFetchQuestions
{
    return _wasAskedToFetchQuestions;
}

@end
