//
//  StackOverflowManager.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StackOverflowManagerDelegate.h"
#import "QuestionBuilder.h"

@class StackOverflowCommunicator;
@class Topic;

extern NSString *StackOverflowManagerErrorDomain;

enum{
    StackOverflowManagerErrorQuestionSearchCode
};

@interface StackOverflowManager : NSObject

@property (nonatomic, weak) id<StackOverflowManagerDelegate> delegate;
@property (nonatomic, strong) StackOverflowCommunicator *communicator;
@property (nonatomic, strong) QuestionBuilder *questionBuilder;

- (void)fetchQuestionsOnTopic:(Topic*)topic;
- (void)searchingForQuestionsFailedWithError:(NSError*)error;
- (void)receivedQuestionsJSON:(NSString*)objectNotation;

@end
