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
@property (nonatomic, copy) NSArray *arrayToReturn;
@property (nonatomic, copy) NSError *errorToSet;


@end
