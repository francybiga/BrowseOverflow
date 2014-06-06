//
// Created by francesco bigagnoli on 28/03/14.
// Copyright (c) 2014 BF. All rights reserved.
//

#import "Topic.h"
#import "Question.h"

@interface Topic()

@property (strong, nonatomic) NSArray *questions;

@end

@implementation Topic {

}

- (id)initWithName:(NSString *)newName tag:(NSString*) newTag{
    if (self = [super init]){
        _name =  newName;
        _tag = newTag;
        _questions = [[NSArray alloc]init];
    }
    return self;
}

- (NSArray*) recentQuestions
{
    return [self sortQuestionsLaterFirst:self.questions];
}

- (NSArray *)sortQuestionsLaterFirst:(NSArray* )questionList
{
    return [questionList sortedArrayUsingComparator:^(id obj1, id obj2){
        Question *q1 = (Question*)obj1;
        Question *q2 = (Question*)obj2;
        return [q2.date compare:q1.date];
    }];
}

- (void)addQuestion:(Question*)question
{
    NSArray *newQuestions = [self.questions arrayByAddingObject:question];

    if ([newQuestions count] > 20){
        newQuestions = [self sortQuestionsLaterFirst:newQuestions];
        newQuestions = [newQuestions subarrayWithRange:NSMakeRange(0, 20)];
    }

    self.questions = newQuestions;
}


@end