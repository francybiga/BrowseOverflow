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


@interface StackOverflowManager ()

@property (nonatomic, strong) Question *questionNeedingBody;

@end

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
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)receivedQuestionsJSON:(NSString*)objectNotation
{
    NSError *error = nil;
    NSArray *questions = [self.questionBuilder questionsFromJSON:objectNotation error:&error];
    
    if (!questions){
        [self tellDelegateAboutQuestionSearchError:error];
    }
    else {
        [self.delegate didReceivedQuestions:questions];
    }
}

- (void)tellDelegateAboutQuestionSearchError:(NSError*)error
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
    self.questionNeedingBody = question;
    [self.communicator  searchBodyForQuestion:question];
}
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    [self tellDelegateAboutBodySearchError:error];
}

- (void)tellDelegateAboutBodySearchError:(NSError*)error
{
    NSError *reportableError;
    
    if (error){
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                              code:StackOverflowManagerErrorQuestionSearchCode
                                          userInfo:@{NSUnderlyingErrorKey: error}];
    }
    else {
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                              code:StackOverflowManagerErrorBodySearchCode
                                          userInfo:nil];
    }
    
    [self.delegate fetchingBodyFailedWithError:reportableError];
}


- (void)receivedQuestionBodyJSON:(NSString*)objectNotation
{
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON:objectNotation];
}

@end
