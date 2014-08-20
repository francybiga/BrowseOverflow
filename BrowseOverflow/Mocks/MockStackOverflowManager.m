//
//  MockStackOverflowManager.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 20/08/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "MockStackOverflowManager.h"

@implementation MockStackOverflowManager


- (void)fetchQuestionsOnTopic:(Topic *)topic
{
    self.wasAskedToFetchQuestions = YES;
}

- (void)fetchBodyForQuestion:(Question *)question
{
    self.wasAskedToFetchBody = YES;
}

- (void)fetchAnswersForQuestion:(Question *)question
{
    self.wasAskedToFetchAnswers = YES;
}

#pragma mark - StackOverflowCommunicatorDelegate

- (void)searchingForQuestionsFailedWithError:(NSError*)error {
    self.topicFailureErrorCode = [error code];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    self.bodyFailureErrorCode = [error code];
}

- (void)fetchingAnswersFailedWithError:(NSError *)error {
    self.answerFailureErrorCode = [error code];
}

- (void)receivedQuestionsJSON:(NSString*)objectNotation {
    self.topicSearchString = objectNotation;
}


- (void)receivedQuestionBodyJSON:(NSString*)objectNotation{
    self.questionBodyString = objectNotation;
}
- (void)receivedAnswerListJSON:(NSString *)objectNotation {
    self.answerListString = objectNotation;
}

@end
