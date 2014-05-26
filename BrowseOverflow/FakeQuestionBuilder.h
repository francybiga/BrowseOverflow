//
//  FakeQuestionBuilder.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionBuilder.h"

@class Question;

@interface FakeQuestionBuilder : QuestionBuilder

@property (nonatomic, copy) NSString *JSON;
@property (nonatomic, strong) NSArray *arrayToReturn;
@property (nonatomic, strong) NSError *errorToSet;
@property (nonatomic, strong) Question *questionToFill;


@end
