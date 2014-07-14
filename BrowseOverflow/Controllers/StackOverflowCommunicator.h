//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@interface StackOverflowCommunicator : NSObject {
    @protected NSURL *_fetchingURL;
}

- (void)searchForQuestionsWithTag:(NSString*)tag;
- (void)downloadInformationForQuestionWithID: (NSInteger)identifier;
- (void)downloadAnswersToQuestionWithID: (NSInteger)identifier;
- (void)fetchBodyForQuestion:(NSInteger)questionID;

@end
