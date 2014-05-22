//
//  Question.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 03/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//


@class Answer;
@interface Question : NSObject{
    NSMutableSet *answerSet;
}

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic, readonly) NSArray *answers;

- (void)addAnswer:(Answer *)answer;

@end
