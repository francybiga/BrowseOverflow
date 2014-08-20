//
//  FakeURLResponse.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 20/08/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeURLResponse : NSObject

@property (nonatomic, assign) NSInteger statusCode;

- (instancetype)initWithStatusCode:(NSInteger)code;

@end
