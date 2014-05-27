//
//  FakeQuestionBuilder.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "FakeQuestionBuilder.h"
#import "Question.h"


@interface FakeQuestionBuilder ()
@end

@implementation FakeQuestionBuilder

- (NSArray*)questionsFromJSON:(NSString*)objectNotation error:(NSError**)error
{
    self.JSON = objectNotation;
    *error = self.errorToSet; //aggiunta da me
    return self.arrayToReturn;
}

- (void)fillInDetailsForQuestion:(Question *)question fromJSON:(NSString *)jsonString
{
    self.JSON = jsonString;
    self.questionToFill = question;
}

@end
