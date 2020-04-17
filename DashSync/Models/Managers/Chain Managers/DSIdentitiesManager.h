//  
//  Created by Sam Westrich
//  Copyright © 2020 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DSChain,DSBlockchainIdentity;

@protocol DSDAPINetworkServiceRequest;

typedef void (^IdentitiesCompletionBlock)(NSArray <DSBlockchainIdentity*> * _Nullable blockchainIdentities, NSError * _Nullable error);

@interface DSIdentitiesManager : NSObject

@property (nonatomic, readonly) DSChain * chain;

- (instancetype)initWithChain:(DSChain*)chain;

- (void)retrieveAllBlockchainIdentitiesChainStates;

- (id<DSDAPINetworkServiceRequest>)searchIdentitiesByNamePrefix:(NSString*)namePrefix withCompletion:(IdentitiesCompletionBlock)completion;

- (id<DSDAPINetworkServiceRequest>)searchIdentitiesByNamePrefix:(NSString*)namePrefix offset:(uint32_t)offset limit:(uint32_t)limit withCompletion:(IdentitiesCompletionBlock)completion;

- (void)searchIdentitiesByDPNSRegisteredBlockchainIdentityUniqueID:(NSString*)userID withCompletion:(IdentitiesCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
