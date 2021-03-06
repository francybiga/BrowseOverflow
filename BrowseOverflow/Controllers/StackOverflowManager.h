//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StackOverflowManagerDelegate.h"
#import "StackOverflowCommunicatorDelegate.h"
#import "QuestionBuilder.h"
#import "AnswerBuilder.h"

@class StackOverflowCommunicator;
@class Topic;

extern NSString *StackOverflowManagerErrorDomain;

enum{
    StackOverflowManagerErrorQuestionSearchCode, 
    StackOverflowManagerErrorBodyFetchCode,
    StackOverflowManagerErrorAnswersFetchCode
};

@interface StackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>

@property (nonatomic, weak) id<StackOverflowManagerDelegate> delegate;
@property (nonatomic, strong) StackOverflowCommunicator *communicator;
@property (nonatomic, strong) QuestionBuilder *questionBuilder;
@property (nonatomic, strong) AnswerBuilder *answerBuilder;

- (void)fetchQuestionsOnTopic:(Topic*)topic;
- (void)fetchBodyForQuestion:(Question*)question;
- (void)fetchAnswersForQuestion:(Question *)question;

@end
