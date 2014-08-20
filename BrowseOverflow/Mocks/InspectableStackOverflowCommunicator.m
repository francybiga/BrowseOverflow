//
//  InspectableStackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 14/07/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "InspectableStackOverflowCommunicator.h"

@implementation InspectableStackOverflowCommunicator

- (NSURL *)urlToFetch
{
    return _fetchingURL;
}

- (NSURLConnection *)currentURLConnection
{
    return _fetchingConnection;
}

@end
