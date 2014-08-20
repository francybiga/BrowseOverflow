//
//  StackOverflowCommunicatorTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "InspectableStackOverflowCommunicator.h"
#import "NonNetworkedStackOverflowCommunicator.h"

@interface StackOverflowCommunicatorTests : XCTestCase

@property (nonatomic, strong) InspectableStackOverflowCommunicator *communicator;
@property (nonatomic, strong) NonNetworkedStackOverflowCommunicator *nnCommunicator;
@property (nonatomic, strong) MockStackOverflowManager *manager;
@property (nonatomic, strong) FakeURLResponse *fourOhFourResponse;
@property (nonatomic, strong) NSData *receivedData;

@end

static NSString *kQuestionsWithTagiOSURLString = @"http://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=ios&site=stackoverflow";
static NSString *kQuestionWithID12345URLString = @"http://api.stackexchange.com/2.2/questions/12345?order=desc&sort=activity&site=stackoverflow&filter=withbody";
static NSString *kAnswersForQuestionWithID12345URLString = @"http://api.stackexchange.com/2.2/questions/12345/answers?order=desc&sort=activity&site=stackoverflow&filter=withbody";
static NSString *kResponseString = @"Result";

@implementation StackOverflowCommunicatorTests

- (void)setUp
{
    [super setUp];
    self.communicator = [[InspectableStackOverflowCommunicator alloc] init];
    self.nnCommunicator = [[NonNetworkedStackOverflowCommunicator alloc] init];
    self.manager = [[MockStackOverflowManager alloc] init];
    self.fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode:404];
    self.receivedData = [kResponseString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    self.communicator = nil;
    self.nnCommunicator = nil;
    self.manager = nil;
    self.fourOhFourResponse = nil;
    self.receivedData = nil;
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

- (void)testFetchingAnswersToQuestionCallsQuestionAPI
{
    [self.communicator downloadAnswersToQuestionWithID:12345];
    XCTAssertEqualObjects([[self.communicator urlToFetch] absoluteString], kAnswersForQuestionWithID12345URLString, @"Use the question API to get the body for a question");
}

- (void)testSearchingForQuestionsCreatesURLConnection
{
    [self.communicator searchForQuestionsWithTag:@"ios"];
    XCTAssertNotNil([self.communicator currentURLConnection], @"There should be a URL connection in flight now");
    [self.communicator cancelAndDiscardURLConnection];
}

- (void)testStartingNewSearchThrowsOutOldConnection
{
    [self.communicator searchForQuestionsWithTag:@"ios"];
    NSURLConnection *firstConnection = [self.communicator currentURLConnection];
    [self.communicator searchForQuestionsWithTag:@"cocoa"];
    XCTAssertFalse([[self.communicator currentURLConnection] isEqual:firstConnection], @"The communicator needs to replace its URL connection to start a new one");
    [self.communicator cancelAndDiscardURLConnection];
}

- (void)testReceivingResponseDiscardsExistingData
{
    self.nnCommunicator.receivedData = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connection:nil didReceiveResponse:nil];
    XCTAssertEqual([self.nnCommunicator.receivedData length], 0, @"Data should have been discarded");
}

- (void)testReceivingResponseWith404StatusPassesErrrorToDelegate
{
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connection:nil didReceiveResponse:self.fourOhFourResponse];
    XCTAssertEqual([self.manager topicFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
}

- (void)noErrorReceivedOn200Status
{
    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode:200];
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator connection:nil didReceiveResponse:twoHundredResponse];
    XCTAssertFalse([self.manager topicFailureErrorCode] == 200, @"No need for error on 200 response");
}

- (void)testConnectionFailingPassesErrorToDelegate
{
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    NSError *error = [NSError errorWithDomain:@"Fake domain" code:12345 userInfo:nil];
    [self.nnCommunicator connection: nil didFailWithError:error];
    XCTAssertEqual([self.manager topicFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
}

- (void)testSuccessfulQuestion
{
    [self.nnCommunicator searchForQuestionsWithTag:@"ios"];
    [self.nnCommunicator didReceivedData: self.receivedData];
    [self.nnCommunicator connectionDidFinishLoading:nil];
    XCTAssertEqualObjects([self.manager topicSearchString], kResponseString, @"The delegate should have received data on success");
}

- (void)testAdditionalDataAppendedToDownload
{
    [self.nnCommunicator setReceivedData:_receivedData];
    NSString *stringToAppend = @"appended";
    NSData *extraData = [stringToAppend dataUsingEncoding:NSUTF8StringEncoding];
    [self.nnCommunicator connection:nil didReceiveData:extraData];
    NSString *combinedString = [kResponseString stringByAppendingString:stringToAppend];
    NSString *communicatorCombinedString = [[self.nnCommunicator receivedData] encodeWithCoder:NSUTF8StringEncoding];
    XCTAssertEqualObjects(communicatorCombinedString, combinedString, @"Received data should be appended to the downloaded data");
}


@end