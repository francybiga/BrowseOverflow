//
//  AnswerBuilder.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//
#import <Foundation/Foundation.h>

extern NSString *QuestionBuilderErrorDomain;

enum {
    AnswerBuilderInvalidJSONError,
    AnswerBuilderMissingDataError
};

@interface AnswerBuilder : NSObject

- (NSArray *)answersFromJSON:(NSString *)objectNotation error:(NSError **)error;

@end
