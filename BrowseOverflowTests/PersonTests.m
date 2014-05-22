//
//  PersonTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 07/04/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

@interface PersonTests : XCTestCase

@end

@implementation PersonTests{
    Person *person;
}

- (void)setUp
{
    [super setUp];
    person = [[Person alloc]initWithName:@"Graham Lee" avatarLocation:@"http://example.com/avatar.png"];
}

- (void)tearDown
{
    person = nil;
    [super tearDown];
}

- (void)testThatPersonHasTheRightName
{
    XCTAssertEqualObjects(person.name,@"Graham Lee",@"expecting a person to provide its name");
}

- (void)testThatPersonHasAnAvatarURL
{
    NSURL *url = person.avatarUrl;
    XCTAssertEqualObjects([url absoluteString], @"http://example.com/avatar.png",@"The Person's avatar should be represented by a URL");
}

@end
