//
//  DSTransactionManager.h
//  DashSync
//
//  Created by Sam Westrich on 11/21/18.
//  Copyright (c) 2018 Dash Core Group <contact@dash.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "BigIntTypes.h"
#import "DSChain.h"
#import "DSPeer.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString* _Nonnull const DSTransactionManagerSyncStartedNotification;
FOUNDATION_EXPORT NSString* _Nonnull const DSTransactionManagerSyncFinishedNotification;
FOUNDATION_EXPORT NSString* _Nonnull const DSTransactionManagerSyncFailedNotification;
FOUNDATION_EXPORT NSString* _Nonnull const DSTransactionManagerTransactionStatusDidChangeNotification;
FOUNDATION_EXPORT NSString* _Nonnull const DSTransactionManagerTransactionReceivedNotification;

@class DSChain, DSPaymentRequest,DSPaymentProtocolRequest,DSShapeshiftEntity,DSTransaction;

@interface DSTransactionManager : NSObject <DSChainTransactionsDelegate,DSPeerTransactionDelegate>

@property (nonatomic,readonly) DSChain * chain;

- (instancetype)initWithChain:(DSChain*)chain;

- (void)fetchMempoolFromPeer:(DSPeer*)peer;

- (void)fetchMempoolFromNetwork;

- (void)fetchTransactionHavingHash:(UInt256)transactionHash;

- (NSUInteger)relayCountForTransaction:(UInt256)txHash; // number of connected peers that have relayed the transaction

- (DSBloomFilter *)transactionsBloomFilterForPeer:(DSPeer *)peer;

- (void)publishTransaction:(DSTransaction *)transaction completion:(void (^)(NSError *error))completion;

- (void)confirmPaymentRequest:(DSPaymentRequest *)paymentRequest fromAccount:(DSAccount*)account forceInstantSend:(BOOL)forceInstantSend signedCompletion:(void (^)(NSError *error, BOOL cancelled))signedCompletion publishedCompletion:(void (^)(NSError *error, BOOL waiting, BOOL sent))publishedCompletion;

- (void)confirmTransaction:(DSTransaction *)tx createdFromProtocolRequest:(DSPaymentProtocolRequest*)protocolRequest fromAccount:(DSAccount*)account toAddress:(NSString*)address withPrompt:(NSString *)prompt forAmount:(uint64_t)amount signedCompletion:(void (^)(NSError *error, BOOL cancelled))signedCompletion publishedCompletion:(void (^)(NSError *error, BOOL waiting, BOOL sent))publishedCompletion;

- (void)confirmProtocolRequest:(DSPaymentProtocolRequest *)protoReq forAmount:(NSUInteger)requestedAmount fromAccount:(DSAccount*)account currency:(NSString*)currency associatedShapeshift:(DSShapeshiftEntity*)shapeshift acceptReusingAddress:(BOOL)acceptReusingAddress addressIsFromPasteboard:(BOOL)addressIsFromPasteboard acceptUncertifiedPayee:(BOOL)acceptUncertifiedPayee requestingAdditionalInfo:(void (^)(BOOL needsAmount,BOOL cancelOrChangeAmount))additionalInfoRequest presentChallenge:(void (^)(NSString * challengeTitle, NSString * challengeMessage,NSString * actionTitle, void (^actionBlock)(void), void (^cancelBlock)(void) ))challenge errorCompletion:(void (^)(NSString *errorTitle, NSString * errorMessage,BOOL shouldCancel))errorCompletion completion:(void (^)(DSTransaction *tx, NSString * prompt, uint64_t amount))completion;
@end

NS_ASSUME_NONNULL_END
