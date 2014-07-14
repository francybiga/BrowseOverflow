//
//  QuestionBuilderTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 21/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "QuestionBuilder.h"
#import "Question.h"
#import "Person.h"
#import "StackOverflowCommunicator.h"

@interface QuestionBuilderTests : XCTestCase

@end

@implementation QuestionBuilderTests {
    QuestionBuilder *questionBuilder;
    Question *question;
}

static NSString *kQuestionJSON = @"{"
@"\"items\":"
@"["
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
@"\"title\": \"How can I programmatically determine if my app is running in the iphone simulator?\","
@"\"body\":\"<p>As the question states, I would mainly like to know whether or not my code is running in the simulator, but would also be interested in knowing the specific iphone version that is running or being simulated.</p>\\n\\n<p>EDIT: I added the word 'programmatically' to the question name. The point of my question is to be able to dynamically include / exclude code depending on which version / simulator is running, so I'd really be looking for something like a pre-processor directive that can provide me this info.</p>\\n\""
@"}"
@"],"
@"\"has_more\":true"
@",\"quota_max\":10000"
@",\"quota_remaining\":9990"
@"}";

static NSString *kNoQuestionJSONString = @"{[]}";

static NSString *kQuestionBodyString = @"<p>As the question states, I would mainly like to know whether or not my code is running in the simulator, but would also be interested in knowing the specific iphone version that is running or being simulated.</p>\n\n<p>EDIT: I added the word 'programmatically' to the question name. The point of my question is to be able to dynamically include / exclude code depending on which version / simulator is running, so I'd really be looking for something like a pre-processor directive that can provide me this info.</p>\n";

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    questionBuilder = [[QuestionBuilder alloc]init];
    question = [[questionBuilder questionsFromJSON:kQuestionJSON error:NULL] objectAtIndex:0];
}

- (void)tearDown
{
    questionBuilder = nil;
    question = nil;
    [super tearDown];
}

- (void)testNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([questionBuilder questionsFromJSON:nil error:NULL], @"Lack of data should be handled elsewhere");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"This parameter should be parsable");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [questionBuilder questionsFromJSON:@"Not JSON" error:&error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPassingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([questionBuilder questionsFromJSON:@"Not JSON" error:NULL], @"Using a NULL error parameter should not be a problem");
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

- (void)testJSONWithOneQuestionReturnsOneQuestionObject
{
    NSError *error = nil;
    NSArray *questions = [questionBuilder questionsFromJSON:kQuestionJSON error:&error];
    XCTAssertEqual([questions count],1,@"The builder should have created one question");
}

- (void)testQuestionCreatedFromJSONHasPropertiesPresentedInJSON
{
    XCTAssertEqual(question.questionID,458304, @"The question ID should match the data we sent");
    XCTAssertEqual([question.date timeIntervalSince1970], (NSTimeInterval)1232384132,@"The date of the question should match the data");
    XCTAssertEqualObjects(question.title,@"How can I programmatically determine if my app is running in the iphone simulator?", @"Title should match the provided data");
    XCTAssertEqual(question.score,110,@"Score should match the data");
    Person *asker = question.asker;
    XCTAssertEqualObjects(asker.name, @"Jeffrey Meyer",@"Asker name must match the data");
    XCTAssertEqualObjects([asker.avatarUrl absoluteString],@"https://www.gravatar.com/avatar/383547b38bd4ade50df21ecbc866c7f4?s=128&d=identicon&r=PG",@"The avatar URL should be based on the supplied email hash");
}

- (void)testQuestionCreatedFromEmptyObjectIsStillValidObject
{
    NSString *emptyQuestion = @"{\"items\": [ {} ] }";
    NSArray *questions = [questionBuilder questionsFromJSON:emptyQuestion error:NULL];
    XCTAssertEqual([questions count], 1,@"question builder must handle partial input");
}

- (void)testBuildingQuestionBodyWithNoDataCannotBeTried
{
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:question fromJSON:nil],@"not receiving data should have been handled earlier");
}

- (void)testBuildingQuestionBodyWithNoQuestionCannotBeTried
{
    XCTAssertThrows([questionBuilder fillInDetailsForQuestion:nil fromJSON:kQuestionJSON],@"No reason to expect that a nil question is passed");
}

- (void)testNonHSONDataDoesNotCauseABodyToBeAddeedToAQuestion
{
    [questionBuilder fillInDetailsForQuestion: question fromJSON:@"This is not a JSON String"];
    XCTAssertNil(question.body, @"Body should not have been added");
}

- (void)testJSONWhichDoesNotContainABodyDoesNotCauseBodyToBeAdded
{
    [questionBuilder fillInDetailsForQuestion: question fromJSON: kNoQuestionJSONString];
    XCTAssertNil(question.body,@"There was no body to add");
}

- (void)testBodyContainedInJSONIsAddedToQuestion
{
    [questionBuilder fillInDetailsForQuestion: question fromJSON: kQuestionJSON];

    XCTAssertEqualObjects(question.body, kQuestionBodyString,@"The correct question body is added");
}

@end
