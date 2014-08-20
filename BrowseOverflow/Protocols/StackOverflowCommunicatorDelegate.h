//
//  StackOverflowCommunicatorDelegate.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 19/08/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StackOverflowCommunicatorDelegate <NSObject>

- (void)searchingForQuestionsFailedWithError:(NSError*)error;
- (void)fetchingQuestionBodyFailedWithError:(NSError *)error;
- (void)fetchingAnswersFailedWithError:(NSError *)error;

- (void)receivedQuestionBodyJSON:(NSString*)objectNotation;
- (void)receivedQuestionsJSON:(NSString*)objectNotation;
- (void)receivedAnswerListJSON:(NSString *)objectNotation;

@end
