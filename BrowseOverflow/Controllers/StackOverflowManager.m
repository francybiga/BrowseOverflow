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
@property (nonatomic, strong) Question *questionToFill;

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
    [self.communicator  fetchBodyForQuestion:question.questionID];
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
                                              code:StackOverflowManagerErrorBodyFetchCode
                                          userInfo:nil];
    }
    
    [self.delegate fetchingBodyFailedWithError:reportableError];
}

- (void)fetchAnswersForQuestion:(Question *)question
{
    self.questionToFill = question;
    [self.communicator downloadAnswersToQuestionWithID:question.questionID];
}


- (void)tellDelegateAboutAnswersSearchError:(NSError*)error
{
    NSError *reportableError;
    
    if (error){
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                              code:StackOverflowManagerErrorAnswersFetchCode
                                          userInfo:@{NSUnderlyingErrorKey: error}];
    }
    else {
        reportableError = [NSError errorWithDomain:StackOverflowManagerErrorDomain
                                              code:StackOverflowManagerErrorAnswersFetchCode
                                          userInfo:nil];
    }
    
    [self.delegate fetchingQuestionsFailedWithError:reportableError];
}

#pragma mark - StackOverflowCommunicatorDelegate

- (void)searchingForQuestionsFailedWithError:(NSError*)error
{
    [self tellDelegateAboutQuestionSearchError:error];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error
{
    [self tellDelegateAboutBodySearchError:error];
}

- (void)fetchingAnswersFailedWithError:(NSError *)error
{
    [self tellDelegateAboutAnswersSearchError:error];
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

- (void)receivedQuestionBodyJSON:(NSString*)objectNotation
{
    [self.questionBuilder fillInDetailsForQuestion:self.questionNeedingBody fromJSON:objectNotation];
}

- (void)receivedAnswerListJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *answers = [self.answerBuilder answersFromJSON:objectNotation error:&error];
    
    if (!answers) {
        [self tellDelegateAboutAnswersSearchError:error];
    } else {
        [self.delegate didReceivedAnswers:answers];
    }    
}


@end
