//
//  PersonBuilder.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

extern NSString *PersonBuilderErrorDomain;
extern NSString *PersonBuilderNameJSONKey;
extern NSString *PersonBuilderAvatarURLJSONKey;

enum {
    PersonBuilderInvalidJSONError
};

@interface PersonBuilder : NSObject

- (Person *)personFromDictionary:(NSDictionary *)personDictionary;

@end
