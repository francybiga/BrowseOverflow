//
//  PersonBuilder.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "PersonBuilder.h"
#import "Person.h"

NSString *PersonBuilderErrorDomain = @"BrowseOverflowPersonBuilderError";

NSString *PersonBuilderNameJSONKey = @"display_name";
NSString *PersonBuilderAvatarURLJSONKey = @"profile_image";


@implementation PersonBuilder

- (Person *)personFromDictionary:(NSDictionary *)personDictionary
{
    if (!personDictionary) {
        return nil;
    }
    
    Person *person = [[Person alloc] init];
    person.name = personDictionary[PersonBuilderNameJSONKey];
    person.avatarUrl = [NSURL URLWithString:personDictionary[PersonBuilderAvatarURLJSONKey]];
    
    return person;
}


@end
