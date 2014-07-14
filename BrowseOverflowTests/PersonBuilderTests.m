//
//  PersonBuilderTests.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PersonBuilder.h"
#import "Person.h"

@interface PersonBuilderTests : XCTestCase

@property (nonatomic, strong) PersonBuilder *personBuilder;
@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) NSDictionary *personDictionary;

@end

@implementation PersonBuilderTests

- (void)setUp
{
    [super setUp];
    self.personDictionary = @{PersonBuilderNameJSONKey: @"onmyway133", PersonBuilderAvatarURLJSONKey : @"https://www.gravatar.com/avatar/16bebb36e0e28572a316ba0450e190d1?s=128&d=identicon&r=PG"};
    self.personBuilder = [[PersonBuilder alloc] init];
    self.person = [self.personBuilder personFromDictionary:self.personDictionary];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPassingNilParametersReturnsANilPerson
{
    XCTAssertNil([self.personBuilder personFromDictionary:nil], @"Building a person from nil dict should return nil");
}
- (void)testPassingAnEmptyDictionaryReturnsAnEmptyPersonInstance
{
    Person *emptyPerson = [self.personBuilder personFromDictionary:@{}];
    XCTAssertNotNil(emptyPerson, @"Building a person from an empty dict should return an empty Person instance");
    XCTAssertNil(emptyPerson.name,@"Empty person name should be nil");
    XCTAssertNil(emptyPerson.avatarUrl,@"Empty person avatar URL should be nil");
}

- (void)testPersonCreatedFromDictionaryHasProperties
{
    XCTAssertEqualObjects(self.person.name, self.personDictionary[PersonBuilderNameJSONKey], @"Person name should match dict value");
    XCTAssertEqualObjects([self.person.avatarUrl absoluteString], self.personDictionary[PersonBuilderAvatarURLJSONKey],@"Person avatar URL should match dict value");
}

@end
