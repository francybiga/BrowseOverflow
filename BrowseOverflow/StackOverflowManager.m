//
//  StackOverflowManager.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "StackOverflowManager.h"

#import "Topic.h"
#import "StackOverflowCommunicator.h"

NSString *StackOverflowManagerErrorDomain = @"StackOverflowManagerErrorDomain";

@implementation StackOverflowManager

- (void)setDelegate:(id<StackOverflowManagerDelegate>)newDelegate
{
    if (newDelegate && ![newDelegate conformsToProtocol:@protocol(StackOverflowManagerDelegate)]){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil]raise];
    }
    
    _delegate = newDelegate;
}

- (void)fetchQuestionsOnTopic:(Topic*)topic
{
    [self.communicator searchForQuestionsWithTag:[topic tag]];
}

- (void)searchingForQuestionsFailedWithError:(NSError*)error
{
    [self tellDelegateAbountQuestionSearchError:error];
}

- (void)receivedQuestionsJSON:(NSString*)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    
    if (!questions){
        [self tellDelegateAbountQuestionSearchError:error];
    }
    else {
        [self.delegate didReceivedQuestions:questions];
    }
}

- (void)tellDelegateAbountQuestionSearchError:(NSError*)error
{
    NSError *reportableError;
    
    if (error){
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                                       code:StackOverflowManagerErrorQuestionSearchCode
                                                   userInfo:@{NSUnderlyingErrorKey: error}];
    }
    else {
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                              code:StackOverflowManagerErrorQuestionSearchCode
                                          userInfo:nil];
    }
    
    [self.delegate fetchingQuestionsFailedWithError:reportableError];
}

- (void)fetchBodyForQuestion:(Question*)question
{

}
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{

}

- (void)receivedQuestionBodyJSON:(NSString*)json
{

}

@end
