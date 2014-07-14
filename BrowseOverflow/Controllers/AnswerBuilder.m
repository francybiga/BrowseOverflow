//
//  AnswerBuilder.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "AnswerBuilder.h"
#import "Answer.h"
#import "PersonBuilder.h"

NSString *AnswerBuilderErrorDomain = @"BrowseOverflowAnswerBuilderError";

static NSString *kAnswersListJSONKey = @"items";
static NSString *kAnswerBodyJSONKey = @"body";
static NSString *kAnswerIsAcceptedJSONKey = @"is_accepted";
static NSString *kAnswerScoreJSONKey = @"score";
static NSString *kAnswerPersonJSONKey = @"owner";

@interface AnswerBuilder ()

@property (nonatomic, strong) PersonBuilder *personBuilder;

@end

@implementation AnswerBuilder

- (NSArray *)answersFromJSON:(NSString *)objectNotation error:(NSError **)error
{
    NSParameterAssert(objectNotation != nil);
    
    NSData *unicodeNotation = [objectNotation dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:unicodeNotation
                                                    options:0
                                                      error:&localError];
    NSDictionary *parsedObject = (NSDictionary *)jsonObject;
    
    if (!parsedObject) {
        if (error != NULL) {
            NSDictionary *userInfo = nil;
            if (localError) {
                 userInfo = @{NSUnderlyingErrorKey:localError};
            }
            
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain
                                         code:AnswerBuilderInvalidJSONError
                                     userInfo:userInfo];
        }
        return nil;
    }
    
    NSArray *answersJSONArray = parsedObject[kAnswersListJSONKey];
    if (!answersJSONArray) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:AnswerBuilderErrorDomain
                                         code:AnswerBuilderMissingDataError
                                     userInfo:nil];
        }
        return nil;
    }
    
    self.personBuilder = [[PersonBuilder alloc] init];
    
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    for (NSDictionary *answerJSON in answersJSONArray) {
        Answer *answer = [[Answer alloc] init];
        answer.text = answerJSON[kAnswerBodyJSONKey];
        [answer setAccepted:[answerJSON[kAnswerIsAcceptedJSONKey] boolValue]];
        answer.score = [answerJSON[kAnswerScoreJSONKey] integerValue];
        answer.person = [self.personBuilder personFromDictionary:answerJSON[kAnswerPersonJSONKey]];
        
        [answers addObject:answer];
    }
    
    return answers;
}

@end
