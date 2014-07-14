//
//  StackOverflowCommunicatorTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "InspectableStackOverflowCommunicator.h"

@interface StackOverflowCommunicatorTests : XCTestCase

@property (nonatomic, strong) InspectableStackOverflowCommunicator *communicator;

@end

static NSString *kQuestionsWithTagiOSURLString = @"http://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=ios&site=stackoverflow";
static NSString *kQuestionWithID12345URLString = @"http://api.stackexchange.com/2.2/questions/12345?order=desc&sort=activity&site=stackoverflow&filter=withbody";


@implementation StackOverflowCommunicatorTests

- (void)setUp
{
    [super setUp];
    self.communicator = [[InspectableStackOverflowCommunicator alloc] init];
}

- (void)tearDown
{
    self.communicator = nil;
    [super tearDown];
}

- (void)testSearchingForQuestionsOnTopicCallsTopicAPI
{
    [self.communicator searchForQuestionsWithTag:@"ios"];
    XCTAssertEqualObjects([[self.communicator urlToFetch] absoluteString], kQuestionsWithTagiOSURLString, @"Use the search API to find questions with a particular tag");
}

- (void)testFillingInQuestionBodyCallsQuestionAPI
{
    [self.communicator downloadInformationForQuestionWithID:12345];
    XCTAssertEqualObjects([[self.communicator urlToFetch] absoluteString], kQuestionWithID12345URLString, @"Use the question API to get the body for a question");
}

@end