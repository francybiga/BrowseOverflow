//
//  FakeQuestionBuilder.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "QuestionBuilder.h"

NSString *QuestionBuilderErrorDomain= @"StackOverflowQuestionBuilderError";

@implementation QuestionBuilder

- (NSArray*)questionsFromJSON:(NSString*)objectNotation error:(NSError**)error {
    
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                    options:0
                                                      error:&localError];
    NSDictionary *parsedObject = (id)jsonObject;
    
    if (parsedObject == nil){
        if (error != NULL){
            *error = [NSError errorWithDomain: QuestionBuilderErrorDomain
                                         code:QuestionBuilderInvalidJSONError
                                     userInfo:nil];
        }
        return nil;
    }
    
    NSArray *questions = [parsedObject objectForKey:@"items"];
    if (questions == nil){
        if (error != NULL){
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderMissingDataError
                                     userInfo:nil];
        }
        return nil;
    }
    return nil;
}




@end
