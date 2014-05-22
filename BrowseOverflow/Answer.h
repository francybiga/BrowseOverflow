//
//  Answer.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 08/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

@class Person;

@interface Answer : NSObject

@property (strong,nonatomic) Person *person;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic, getter = isAccepted) BOOL accepted;
@property (copy, nonatomic) NSString *text;

- (NSComparisonResult) compare: (Answer *)otherAnswer;

@end
