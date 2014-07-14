//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "StackOverflowCommunicator.h"

@interface StackOverflowCommunicator ()

@property (nonatomic, assign) BOOL fetchBodyAsked;

@end

@implementation StackOverflowCommunicator

- (void)fetchContentAtURL:(NSURL *)url
{
    _fetchingURL = url;
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    [self fetchContentAtURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=%@&site=stackoverflow",tag]]];    
}

@end
