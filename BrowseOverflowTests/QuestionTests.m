//
//  QuestionTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 03/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Question.h"
#import "Answer.h"

@interface QuestionTests : XCTestCase
@end

@implementation QuestionTests{
    Question *question;
    Answer *lowScore;
    Answer *highScore;
}


- (void)setUp
{
    [super setUp];
    question = [[Question alloc]init];
    question.date = [NSDate distantPast];
    question.title = @"Do iPhone also dream of electric sheep?";
    question.score = 42;

    Answer *accepted = [[Answer alloc]init];
    accepted.score = 1;
    accepted.accepted = YES;
    [question addAnswer:accepted];


    lowScore = [[Answer alloc]init];
    lowScore.score = -4;
    [question addAnswer:lowScore];

    highScore = [[Answer alloc]init];
    highScore.score = 4;
    [question addAnswer:highScore];
}


- (void)tearDown
{
    question = nil;
    highScore = nil;
    lowScore = nil;
    [super tearDown];
}

- (void)testQuestionHasADate
{
    NSDate *testDate = [NSDate distantPast];
    XCTAssertEqualObjects(question.date, testDate,@"Question needs to provide its date");
}

- (void)testQuestionHasATitle
{
    NSString *testTitle = @"Do iPhone also dream of electric sheep?";
    XCTAssertEqualObjects(question.title, testTitle,@"Question needs to provide its title");
}

- (void)testQuestionHasAScore
{
    NSInteger testScore = 42;
    XCTAssertEqual(question.score, testScore,@"Question needs to provide its score");
}

- (void)testQuestionCanHaveAnswersAdded
{
    Answer *myAnswer = [[Answer alloc]init];
    XCTAssertNoThrow([question addAnswer:myAnswer],@"Must be able to add answer");
}

- (void)testAcceptedAnswerIsFirst
{
    XCTAssertTrue([[question.answers objectAtIndex:0]isAccepted],@"Accepted anser comes first");
}

- (void)testHighScoreAnswerBeforeLow
{
    NSArray *answers = question.answers;
    NSInteger highIndex = [answers indexOfObject: highScore];
    NSInteger lowIndex = [answers indexOfObject: lowScore];
    XCTAssertTrue(highIndex < lowIndex,@"High.scoring answer comes first");
}


@end
