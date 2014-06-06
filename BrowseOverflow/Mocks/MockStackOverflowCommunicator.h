//
//  MockStackOverflowCommunicator.h
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StackOverflowCommunicator.h"


@interface MockStackOverflowCommunicator : StackOverflowCommunicator

- (BOOL)wasAskedToFetchQuestions;
- (BOOL)wasAskedToFetchBody;

@end
