//
//  AnswerBuilderTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Answer.h"
#import "AnswerBuilder.h"
#import "Person.h"

@interface AnswerBuilderTests : XCTestCase

@property (nonatomic, strong) Answer *answer;
@property (nonatomic, strong) AnswerBuilder *answerBuilder;

@end

static NSString *kAnswerJSON =
@"{\"items\":["
    @"\{\"owner\": {"
        @"\"reputation\": 2046,"
        @"\"user_id\": 1418457,"
        @"\"user_type\": \"registered\","
        @"\"accept_rate\": 85,"
        @"\"profile_image\": \"https://www.gravatar.com/avatar/16bebb36e0e28572a316ba0450e190d1?s=128&d=identicon&r=PG\","
        @"\"display_name\": \"onmyway133\","
        @"\"link\": \"http://stackoverflow.com/users/1418457/onmyway133\""
    "},"
    @"\"is_accepted\": false,"
    @"\"score\": -1,"
    @"\"last_activity_date\": 1403023082,"
    @"\"last_edit_date\": 1403023082,"
    @"\"creation_date\": 1402973838,"
    @"\"answer_id\": 24255059,"
    @"\"question_id\": 458304,"
    @"\"body\":\"<p>All those answer are good, but it somehow confuses newbie like me as it does not clarify compile check and runtime check. Preprocessor are before compile time, but we should make it clearer</p>\\n\\n<p>This blog article shows <a href=\\\"http://ios.biomsoft.com/2011/09/20/how-to-detect-the-iphone-simulator/\\\" rel=\\\"nofollow\\\">How to detect the iPhone simulator?</a> clearly </p>\\n\\n<p><strong>Runtime</strong></p>\\n\\n<p>First of all, let’s shortly discuss. UIDevice provides you already information about the device</p>\\n\\n<pre><code>[[UIDevice currentDevice] model]\\n</code></pre>\\n\\n<p>will return you “iPhone Simulator” or “iPhone” according to where the app is running.</p>\\n\\n<p><strong>Compile time</strong></p>\\n\\n<p>However what you want is to use compile time defines. Why? Because you compile your app strictly to be run either inside the Simulator or on the device. Apple makes a define called  <code>TARGET_IPHONE_SIMULATOR</code>. So let’s look at the code :</p>\\n\\n<pre><code>#if TARGET_IPHONE_SIMULATOR\\n\\nNSLog(@\\\"Running in Simulator - no app store or giro\\\");\\n\\n#endif\\n</code></pre>\\n\""
@"}],"
@"\"has_more\":false,"
@"\"quota_max\":300,\"quota_remaining\":281}";

@implementation AnswerBuilderTests

- (void)setUp
{
    [super setUp];
    self.answerBuilder = [[AnswerBuilder alloc] init];
    self.answer = [[self.answerBuilder answersFromJSON:kAnswerJSON error:NULL] objectAtIndex:0];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNilIsNotAnAcceptableParameter
{
    XCTAssertThrows([self.answerBuilder answersFromJSON:nil error:NULL], @"Can't create answers from nil JSON");
}

- (void)testNilReturnedWhenStringIsNotJSON
{
    XCTAssertNil([self.answerBuilder answersFromJSON:@"Not JSON" error:NULL], @"This parameter should be parsable");
}

- (void)testErrorSetWhenStringIsNotJSON
{
    NSError *error = nil;
    [self.answerBuilder answersFromJSON:@"Not JSON" error:&error];
    XCTAssertNotNil(error, @"An error occurred, we should be told");
}

- (void)testPasingNullErrorDoesNotCauseCrash
{
    XCTAssertNoThrow([self.answerBuilder answersFromJSON:@"Not JSON" error:NULL], @"Using a NULL error parameter should not be a problem");
}

- (void)testRealJSONWithoutQuestionsArrayIsError
{
    NSString *jsonString = @"{\"noitems\":true}";
    [self.answerBuilder answersFromJSON:jsonString error:NULL];
    XCTAssertNil([self.answerBuilder answersFromJSON:jsonString error:NULL], @"No questions to parse in this JSON");
}

- (void)testRealJSONWithoudQuestionsArrayReturnsMissingDataError
{
    NSString *jsonString = @"{\"noitems\":true}";
    NSError *error = nil;
    [self.answerBuilder answersFromJSON:jsonString error:&error];
    XCTAssertEqual([error code], AnswerBuilderMissingDataError, @"This method call must return a \"Missing Data Error\"");
}

- (void)testJSONWithOneAnswerReturnsOneAnswerObject
{
    NSError *error = nil;
    NSArray *answers = [self.answerBuilder answersFromJSON:kAnswerJSON error:&error];
    XCTAssertEqual([answers count], 1, @"The builder should have created one answer");
}

- (void)testAnswerCreatedFromJSONHasPropertiesPresentedInJSON
{
    XCTAssertEqualObjects(self.answer.text, @"<p>All those answer are good, but it somehow confuses newbie like me as it does not clarify compile check and runtime check. Preprocessor are before compile time, but we should make it clearer</p>\n\n<p>This blog article shows <a href=\"http://ios.biomsoft.com/2011/09/20/how-to-detect-the-iphone-simulator/\" rel=\"nofollow\">How to detect the iPhone simulator?</a> clearly </p>\n\n<p><strong>Runtime</strong></p>\n\n<p>First of all, let’s shortly discuss. UIDevice provides you already information about the device</p>\n\n<pre><code>[[UIDevice currentDevice] model]\n</code></pre>\n\n<p>will return you “iPhone Simulator” or “iPhone” according to where the app is running.</p>\n\n<p><strong>Compile time</strong></p>\n\n<p>However what you want is to use compile time defines. Why? Because you compile your app strictly to be run either inside the Simulator or on the device. Apple makes a define called  <code>TARGET_IPHONE_SIMULATOR</code>. So let’s look at the code :</p>\n\n<pre><code>#if TARGET_IPHONE_SIMULATOR\n\nNSLog(@\"Running in Simulator - no app store or giro\");\n\n#endif\n</code></pre>\n", @"Answer text should match the JSON data");
    XCTAssertEqual(self.answer.isAccepted, NO, @"Is accepted value should match JSON the data");
    XCTAssertEqual(self.answer.score, -1, @"Score should match the JSON data");
    Person *answerOwner = self.answer.person;
    XCTAssertEqualObjects(answerOwner.name, @"onmyway133", @"Asker name must match the JSON data");
    XCTAssertEqualObjects([answerOwner.avatarUrl absoluteString], @"https://www.gravatar.com/avatar/16bebb36e0e28572a316ba0450e190d1?s=128&d=identicon&r=PG", @"The avatar URL should be based on the supplied email hash");
}

- (void)testAnswerCreatedFromEmptyObjectIsStillValidObejct
{
    NSString *emptyAnswer = @"{\"items\": [ {} ] }";
    NSArray *answers = [self.answerBuilder answersFromJSON:emptyAnswer error:NULL];
    XCTAssertEqual([answers count], 1, @"The answer builder must handle partial input");
}

@end
