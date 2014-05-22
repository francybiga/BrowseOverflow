//
//  TopicTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 28/03/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Topic.h"
#import "Question.h"

@interface TopicTests : XCTestCase

@end

@implementation TopicTests{
    Topic *topic;
}

- (void)setUp
{
    [super setUp];
    topic = [[Topic alloc] initWithName:@"iPhone" tag:@"iphone"];
}

- (void)tearDown
{
    topic = nil;
    [super tearDown];
}

- (void)testThatTopicExists
{
    XCTAssertNotNil(topic,@"Should be able to create a Topic instance");
}

- (void)testThatTopicCanBeNamed
{
    XCTAssertEqualObjects(topic.name, @"iPhone",@"The Topic should have the name I gave it");
}

- (void)testThatTopicHasATag
{
    XCTAssertEqualObjects(topic.tag, @"iphone",@"Topic need to have tags");
}

- (void)testForAListOfQuestions
{
    XCTAssertTrue([[topic recentQuestions] isKindOfClass:[NSArray class]],@"Topics should provide a list of recent questions");
}

- (void)testForInitiallyEmptyQuestionList
{
    XCTAssertEqual([[topic recentQuestions]count], (NSUInteger)0,@"No quiestions added yet, count should be zero");
}

- (void)testAddingAQuestionToTheList
{
    Question *question = [[Question alloc]init];
    [topic addQuestion:question];
    XCTAssertEqual([[topic recentQuestions]count], (NSUInteger)1, @"Add a question, and the cpount of questions should go up");
}

- (void)testQuestionsAreListedChronologically
{
    Question *q1 = [[Question alloc] init];
    q1.date = [NSDate distantPast];

    Question *q2 = [[Question alloc]init];
    q2.date = [NSDate distantFuture];

    [topic addQuestion:q1];
    [topic addQuestion:q2];

    NSArray *questions = [topic recentQuestions];
    Question *listedFirst = [questions objectAtIndex:0];
    Question *listedSecond = [questions objectAtIndex:1];

    XCTAssertEqual([listedFirst.date laterDate:listedSecond.date], listedFirst.date,@"The later question should appear first in the list");
}

- (void)testLimitOfTwentyQuestions
{
    Question *q1 = [[Question alloc]init];
    for (NSInteger i=0; i<25;i++){
        [topic addQuestion:q1];
    }
    XCTAssertTrue([[topic recentQuestions]count]< 21, @"There should never be more than twenty questions");
}


@end
