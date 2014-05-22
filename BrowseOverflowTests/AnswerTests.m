//
//  AnswerTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 08/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Topic.h"
#import "Person.h"
#import "Answer.h"

@interface AnswerTests: XCTestCase

@end


@implementation AnswerTests{
    Answer *answer;
    Answer *otherAnswer;
}

- (void)setUp
{
    [super setUp];
    answer = [[Answer alloc]init];
    answer.text = @"The answer is 42";
    answer.person = [[Person alloc] initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
    answer.score= 42;
    otherAnswer = [[Answer alloc] init];
    otherAnswer.text = @"I have the answer you need";
    otherAnswer.score = 42;
}

- (void)tearDown
{
    answer = nil;
    [super tearDown];
}

- (void)testAnswerHasSomeText
{
    XCTAssertEqualObjects(answer.text, @"The answer is 42",@"Answers need to contain some value");
}

- (void)testSomeoneProvidesTheAnswer
{
    XCTAssertTrue([answer.person isKindOfClass:[Person class]],@"A person gave this answer");
}

- (void)testAnswersNotAcceptedByDefault
{
    XCTAssertFalse(answer.accepted,@"Answer not accepted by default");
}

- (void)testAnswersCanBeAccepted
{
    XCTAssertNoThrow(answer.accepted = YES,@"It is possible to accept an answer");
}

- (void)testAnswerHasAScore
{
    XCTAssertTrue(answer.score == 42,@"Answer's score can be retrieved");
}

- (void)testAcceptedAnswerComesBeforeUnaccepted
{
    otherAnswer.accepted = YES;
    otherAnswer.score = answer.score+10;

    XCTAssertEqual([answer compare:otherAnswer],NSOrderedDescending,@"Accepted answer should came first");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending,@"Unaccepted answer should came last");
}

- (void)testAnswersWithEqualScoresCompareEqually
{
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedSame,@"Both answers of equal rank");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedSame,@"Each answer has the same rank");
}

- (void)testLowerScoringAnswerComesAfterHigher
{
    otherAnswer.score = answer.score+10;
    XCTAssertEqual([answer compare:otherAnswer], NSOrderedDescending,@"Higher score come first");
    XCTAssertEqual([otherAnswer compare:answer], NSOrderedAscending,@"Lower score comes last");
}


@end
