//
//  FakeQuestionBuilder.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *QuestionBuilderErrorDomain;

enum{
    QuestionBuilderInvalidJSONError,
    QuestionBuilderMissingDataError
};


@interface QuestionBuilder : NSObject

- (NSArray*)questionsFromJSON:(NSString*)objectNotation error:(NSError**)error;

@end
