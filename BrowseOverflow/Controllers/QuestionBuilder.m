//
//  FakeQuestionBuilder.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "QuestionBuilder.h"
#import "Question.h"
#import "Answer.h"
#import "PersonBuilder.h"

NSString *QuestionBuilderErrorDomain= @"BrowseOverflowQuestionBuilderError";

static NSString *kQuestionsListJSONKey = @"items";
static NSString *kQuestionIDJSONKey = @"question_id";
static NSString *kQuestionCreationDateJSONKey = @"creation_date";
static NSString *kQuestionTitleJSONKey = @"title";
static NSString *kQuestionScoreJSONKey = @"score";
static NSString *kQuestionBodyJSONKey = @"body";
static NSString *kQuestionAskerJSONKey = @"owner";

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
            NSDictionary *userInfo = nil;
            if (localError) {
                userInfo = @{NSUnderlyingErrorKey: localError};
            }
            *error = [NSError errorWithDomain: QuestionBuilderErrorDomain
                                         code:QuestionBuilderInvalidJSONError
                                     userInfo:userInfo];
        }
        return nil;
    }
    
    NSArray *questionsJSONArray = [parsedObject objectForKey:kQuestionsListJSONKey];
    if (!questionsJSONArray){
        if (error != NULL){
            *error = [NSError errorWithDomain:QuestionBuilderErrorDomain
                                         code:QuestionBuilderMissingDataError
                                     userInfo:nil];
        }
        return nil;
    }
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    for (NSDictionary *questionJSON in questionsJSONArray) {
        Question *question = [self questionFromJSON:questionJSON];
        [questions addObject:question];
    }
    
    return questions;
}

- (void)fillInDetailsForQuestion:(Question*)question fromJSON:(NSString*)jsonString
{
    NSParameterAssert(question);
    NSParameterAssert(jsonString);
    
    NSData *unicodeNotation = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                                 options:0
                                                                   error:NULL];
    if (![parsedObject isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *questionBody = [[parsedObject[kQuestionsListJSONKey] lastObject] objectForKey:kQuestionBodyJSONKey];
    if (questionBody) {
        question.body = questionBody;
    }
}

- (Question *)questionFromJSON:(NSDictionary *)questionJSON
{
    Question *question = [[Question alloc] init];
    question.questionID = [questionJSON[kQuestionIDJSONKey] integerValue];
    question.date = [NSDate dateWithTimeIntervalSince1970:[questionJSON[kQuestionCreationDateJSONKey] integerValue]];
    question.title = questionJSON[kQuestionTitleJSONKey];
    question.score = [questionJSON[kQuestionScoreJSONKey] integerValue];
    
    PersonBuilder *personBuilder = [[PersonBuilder alloc] init];
    question.asker = [personBuilder personFromDictionary:questionJSON[kQuestionAskerJSONKey]];
    
    return question;
}

@end
