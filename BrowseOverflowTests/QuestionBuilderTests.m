//
//  QuestionBuilderTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 21/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "QuestionBuilder.h"

@interface QuestionBuilderTests : XCTestCase

@end

@implementation QuestionBuilderTests {
    QuestionBuilder *questionBuilder;
}

static NSString *questionJSON = @"{"
@"\"items\":"
@"[\""
@"{"
@"\"tags\": ["
@"\"iphone\","
@"\"ios-simulator\""
@"],"
@"\"owner\": {"
@"\"reputation\": 1788,"
@"\"user_id\": 2323,"
@"\"user_type\": \"registered\","
@"\"accept_rate\": 62,"
@"\"profile_image\": \"https://www.gravatar.com/avatar/383547b38bd4ade50df21ecbc866c7f4?s=128&d=identicon&r=PG\","
@"\"display_name\": \"Jeffrey Meyer\","
@"\"link\": \"http://stackoverflow.com/users/2323/jeffrey-meyer\""
@"},"
@"\"is_answered\": true,"
@"\"view_count\": 50089,"
@"\"accepted_answer_id\": 458388,"
@"\"answer_count\": 7,"
@"\"score\": 110,"
@"\"last_activity_date\": 1400686503,"
@"\"creation_date\": 1232384132,"
@"\"last_edit_date\": 1232950754,"
@"\"question_id\": 458304,"
@"\"link\": \"http://stackoverflow.com/questions/458304/how-can-i-programmatically-determine-if-my-app-is-running-in-the-iphone-simulato\","
@"\"title\": \"How can I programmatically determine if my app is running in the iphone simulator?\""
@"},"
@"],"
@"\"has_more\": true,"
@"\"quota_max\": 10000,"
@"\"quota_remaining\": 9990"
@"};";

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    questionBuilder = [[QuestionBuilder alloc]init];
}

- (void)tearDown
{
    questionBuilder = nil;
    [super tearDown];
}

- (void)testNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should be handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"This parameter should not be parsable");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [questionBuilder questionsFromJSON:@"Not JSON" error:&error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"Using a NULL parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError
{
    NSString *jsonString = @"{\"noitems\":true}";
    XCTAssertNil([questionBuilder questionsFromJSON:jsonString error:NULL], @"No questions to parse in this JSON");
}

- (void)testRealJSONWithoutQuestionsArrayReturnsMissingDataError
{
    NSString *jsonString = @"{\"noitems\":true}";
    NSError *error = nil;
    [questionBuilder questionsFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], QuestionBuilderMissingDataError, @"This case should NOT be an invalid JSON error");
}

@end
