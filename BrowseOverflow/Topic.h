//
// Created by francesco bigagnoli on 28/03/14.
// Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"


@interface Topic : NSObject

@property (nonatomic,readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *tag;

- (id)initWithName:(NSString *)name tag:(NSString*)tag;
- (NSArray*) recentQuestions;
- (void)addQuestion:(Question*)question;

@end