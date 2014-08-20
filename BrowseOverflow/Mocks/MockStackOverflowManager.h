//
//  MockStackOverflowManager.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 20/08/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StackOverflowCommunicatorDelegate.h"

@interface MockStackOverflowManager : NSObject <StackOverflowCommunicatorDelegate>

@property (nonatomic, assign) NSInteger topicFailureErrorCode;
@property (nonatomic, assign) NSInteger bodyFailureErrorCode;
@property (nonatomic, assign) NSInteger answerFailureErrorCode;

@property (nonatomic, copy) NSString *topicSearchString;
@property (nonatomic, copy) NSString *questionBodyString;
@property (nonatomic, copy) NSString *answerListString;

@property (nonatomic, assign) BOOL wasAskedToFetchQuestions;
@property (nonatomic, assign) BOOL wasAskedToFetchAnswers;
@property (nonatomic, assign) BOOL wasAskedToFetchBody;

@end
