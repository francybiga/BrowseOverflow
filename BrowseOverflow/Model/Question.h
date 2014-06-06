//
//  Question.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 03/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//


@class Answer;
@class Person;

@interface Question : NSObject{
    NSMutableSet *answerSet;
}

@property (assign, nonatomic) NSInteger questionID;
@property (strong, nonatomic) NSDate *date;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic, readonly) NSArray *answers;
@property (strong, nonatomic) Person *asker;
@property (copy, nonatomic) NSString *body;

- (void)addAnswer:(Answer *)answer;

@end
