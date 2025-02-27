//
//  DSChainEntity+CoreDataClass.h
//
//
//  Created by Sam Westrich on 5/20/18.
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

#import "DSChain.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class DSAccountEntity, DSBlockchainIdentityEntity, DSBlockchainInvitationEntity, DSDashpayUserEntity, DSDerivationPathEntity, DSGovernanceObjectHashEntity, DSGovernanceVoteHashEntity, DSMerkleBlockEntity, DSPeerEntity, DSQuorumEntryEntity, DSSimplifiedMasternodeEntryEntity, DSSporkHashEntity, DSTransactionHashEntity, DSChainLockEntity;

NS_ASSUME_NONNULL_BEGIN

@interface DSChainEntity : NSManagedObject

+ (DSChainEntity *_Nonnull)chainEntityForType:(DSChainType)type devnetIdentifier:(NSString *_Nullable)devnetIdentifier devnetVersion:(uint16_t)devnetVersion checkpoints:(NSArray *_Nullable)checkpoints inContext:(NSManagedObjectContext *)context;
- (instancetype)setAttributesFromChain:(DSChain *_Nonnull)chain;
- (DSChain *_Nonnull)chain;

@end

NS_ASSUME_NONNULL_END

#import "DSChainEntity+CoreDataProperties.h"
