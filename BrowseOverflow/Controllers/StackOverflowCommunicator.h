//
//  StackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StackOverflowCommunicatorDelegate.h"

@class Question;

extern NSString *StackOverflowCommunicatorErrorDomain;

@interface StackOverflowCommunicator : NSObject <NSURLConnectionDataDelegate> {
@protected
    NSURL *_fetchingURL;
    NSURLConnection *_fetchingConnection;
@private
    void (^errorHandler)(NSError *);
    void (^successHandler)(NSString *);
}

@property (nonatomic, assign) id<StackOverflowCommunicatorDelegate> delegate;
@property (nonatomic, strong) NSMutableData *receivedData;

- (void)searchForQuestionsWithTag:(NSString*)tag;
- (void)downloadInformationForQuestionWithID: (NSInteger)identifier;
- (void)downloadAnswersToQuestionWithID: (NSInteger)identifier;

- (void)cancelAndDiscardURLConnection;

- (void)fetchBodyForQuestion:(NSInteger)questionID;


@end

