//
//  QuestionCreationTests.m 
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 22/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "StackOverflowManager.h"
#import "Topic.h"
#import "StackOverflowManagerDelegate.h"

#import "MockStackOverflowManagerDelegate.h"
#import "MockStackOverflowCommunicator.h"
#import "FakeQuestionBuilder.h"

@interface QuestionCreationWorkflowTests : XCTestCase
@end

@implementation QuestionCreationWorkflowTests{
    StackOverflowManager *mgr;
    MockStackOverflowManagerDelegate *delegate;
    NSError *underlyingError;
    FakeQuestionBuilder *questionBuilder;
    NSArray *questionArray;
    Question *questionToFetch;
    StackOverflowCommunicator *communicator;
}

- (void)setUp
{
    [super setUp];
    mgr = [[StackOverflowManager alloc]init];
    delegate = [[MockStackOverflowManagerDelegate alloc]init];
    mgr.delegate = delegate;
    underlyingError = [NSError errorWithDomain:@"Test domain" code:0 userInfo:nil];
    questionBuilder = [[FakeQuestionBuilder alloc]init];
    mgr.questionBuilder = questionBuilder;

    /*da cancellare?*/
   /* Question *question = [[Question alloc]init];
    questionArray = @[question];*/

    questionToFetch = [[Question alloc]init];
    questionToFetch.questionID = 1234;
    questionArray = @[questionToFetch];

    communicator = [[MockStackOverflowCommunicator alloc]init];
    mgr.communicator = communicator;
}

- (void)tearDown
{
    mgr = nil;
    delegate = nil;
    underlyingError = nil;
    questionBuilder = nil;
    questionArray = nil;
    questionToFetch = nil;
    communicator = nil;

    [super tearDown];
}

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(mgr.delegate = (id <StackOverflowManagerDelegate>)[NSNull null], @"NSNull should not be used as the delegate as doesn't conform to the delegate protocol");
}

- (void)testConformingObjectCanBeDelegate
{
    XCTAssertNoThrow(mgr.delegate = delegate, @"Object conforming to the delegate protocol should be used as the delegate");
}

- (void)testManagerAcceptsNilAsADelegate
{
    XCTAssertNoThrow(mgr.delegate = nil, @"It should be acceptable to use nil as an object's delegate");
}

- (void)testsAskingForQuestionsMeansRequestingData
{
    MockStackOverflowCommunicator *mockCommunicator = (MockStackOverflowCommunicator*)communicator;
    mgr.communicator = mockCommunicator;
    Topic *topic = [[Topic alloc]initWithName:@"iPhone" tag:@"iphone"];
    [mgr fetchQuestionsOnTopic:topic];
    XCTAssertTrue([mockCommunicator wasAskedToFetchQuestions], @"The communicator should need to fetch data");
}

- (void)testErrorReturnedToDelegateIsNotErrorNotifiedByCommunicator
{
    [mgr searchingForQuestionsFailedWithError:underlyingError];
    XCTAssertFalse(underlyingError == [delegate fetchError], @"Error should be at the correct level of abstraction");
}

- (void)testErrorReturnedToDelegateDocumentsUnderlyingError
{
    [mgr searchingForQuestionsFailedWithError: underlyingError];
    XCTAssertEqualObjects([[[delegate fetchError]userInfo]objectForKey:NSUnderlyingErrorKey], underlyingError, @"The underlying error should be available to client code");
}

- (void)testQuestionJSONIsPassedToQuestionBuilder
{
    [mgr receivedQuestionsJSON: @"Fake JSON"];
    XCTAssertEqualObjects(questionBuilder.JSON, @"Fake JSON", @"Downloaded JSON is sent to the builder");
    mgr.questionBuilder = nil;
}

- (void)testDelegateNotifiedOfErrorWhenQuestionBuilderFails
{
    questionBuilder.arrayToReturn = nil;
    questionBuilder.errorToSet = underlyingError;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNotNil([[[delegate fetchError]userInfo]objectForKey:NSUnderlyingErrorKey], @"The delegate  should have found out about the error");
    mgr.questionBuilder = nil;
}

- (void)testDelegateNotToldAboutErrorWhenQuestionsReceived
{
    questionBuilder.arrayToReturn = questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertNil([delegate fetchError], @"No error should be received on success");
}

- (void)testDelegateReceivesTheQuestionsDiscoveredByManager
{
    questionBuilder.arrayToReturn = questionArray;
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedQuestions], questionArray, @"The manager should have sent its questions to the delegate");
}

- (void)testEmptyArrayIsPassedToDelegate
{
    questionBuilder.arrayToReturn = @[];
    [mgr receivedQuestionsJSON:@"Fake JSON"];
    XCTAssertEqualObjects([delegate receivedQuestions], @[], @"Returning an empty array of questions is not an error");
}

- (void)testAskingForQuestionBodyMeansRequestingData
{
    [mgr fetchBodyForQuestion:questionToFetch];
    MockStackOverflowCommunicator *mockCommunicator = (MockStackOverflowCommunicator*)communicator;
    XCTAssertTrue([mockCommunicator wasAskedToFetchBody],@"The communicator should need to retrieve data for the question body");
}

- (void)testDelegateNotifiedOfFailureToFetchQuestionBody
{
    [mgr fetchingQuestionBodyFailedWithError:underlyingError];
    XCTAssertNotNil([[[delegate fetchError] userInfo] objectForKey:NSUnderlyingErrorKey],@"Delegate should have found out about this error");
}

- (void)testManagerPassesRetrievedQuestionBodyToQuestionBuilder
{
    [mgr receivedQuestionBodyJSON:@"Fake JSON"];
    XCTAssertEqualObjects(questionBuilder.JSON, @"Fake JSON",@"Succesfully retrieved data should be passed to the builder");
}

- (void)testManagerPassesQuestionItWasSentToQuestionBuilderForFillingIn
{
    [mgr fetchBodyForQuestion:questionToFetch];
    [mgr receivedQuestionBodyJSON:@"Fake JSON"];
    XCTAssertEqualObjects(questionBuilder.questionToFill,questionToFetch,@"The question should have been passed to the builder");
}



@end
