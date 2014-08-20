//
//  StackOverflowCommunicator.m
//  BrowseOverflow
//
//  Created by francesco bigagnoli on 12/05/14.
//  Copyright (c) 2014 BF. All rights reserved.
//

#import "StackOverflowCommunicator.h"

NSString *StackOverflowCommunicatorErrorDomain = @"StackOverflowCommunicatorErrorDomain";

@interface StackOverflowCommunicator ()

@property (nonatomic, assign) BOOL fetchBodyAsked;

@end

@implementation StackOverflowCommunicator

- (void)launchConnectionForRequest:(NSURLRequest *)request
{
    [self cancelAndDiscardURLConnection];
    _fetchingConnection = [NSURLConnection connectionWithRequest:request
                                                        delegate:self];
}

- (void)fetchContentAtURL:(NSURL *)url
             errorHandler:(void (^)(NSError *))errorBlock
           successHandler:(void (^)(NSString *))successBlock
{
    _fetchingURL = url;
    errorHandler = [errorBlock copy];
    successHandler = [successBlock copy];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_fetchingURL];
    [self launchConnectionForRequest:request];
}

- (void)searchForQuestionsWithTag:(NSString *)tag
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=%@&site=stackoverflow",tag];
    NSURL *url = [NSURL URLWithString:urlString];
    [self fetchContentAtURL:url errorHandler:^(NSError *error){
                                [self.delegate searchingForQuestionsFailedWithError:error];
                            } successHandler:^(NSString *objectNotation){
                                [self.delegate receivedQuestionsJSON: objectNotation];
    }];
}

- (void)downloadInformationForQuestionWithID:(NSInteger)identifier
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.2/questions/%ld?order=desc&sort=activity&site=stackoverflow&filter=withbody", (long)identifier];
    NSURL *url = [NSURL URLWithString:urlString];
    [self fetchContentAtURL:url errorHandler:^(NSError *error){
        [self.delegate fetchingQuestionBodyFailedWithError:error];
    } successHandler:^(NSString *objectNotation){
        [self.delegate receivedQuestionBodyJSON: objectNotation];
    }];

}

- (void)downloadAnswersToQuestionWithID:(NSInteger)identifier
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.stackexchange.com/2.2/questions/%ld/answers?order=desc&sort=activity&site=stackoverflow&filter=withbody", (long)identifier];
    NSURL *url = [NSURL URLWithString:urlString];
    [self fetchContentAtURL:url errorHandler:^(NSError *error){
        [self.delegate fetchingAnswersFailedWithError:error];
    } successHandler:^(NSString *objectNotation){
        [self.delegate receivedAnswerListJSON: objectNotation];
    }];
}

- (void)cancelAndDiscardURLConnection
{
    [_fetchingConnection cancel];
    _fetchingConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedData = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] != 200) {
        NSError *error = [NSError errorWithDomain:StackOverflowCommunicatorErrorDomain
                                             code:[httpResponse statusCode]
                                         userInfo:nil];
        errorHandler(error);
        [self cancelAndDiscardURLConnection];
    } else {
        _receivedData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _receivedData = nil;
    _fetchingConnection = nil;
    _fetchingURL = nil;
    errorHandler(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _fetchingConnection = nil;
    _fetchingURL = nil;
    NSString *receivedText = [[NSString alloc] initWithData:_receivedData
                                                   encoding:NSUTF8StringEncoding];
    _receivedData = nil;
    successHandler(receivedText);
}

@end
