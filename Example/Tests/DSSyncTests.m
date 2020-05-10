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

#import <XCTest/XCTest.h>

#import "DSChain.h"
#import "DSDerivationPath.h"
#import "NSString+Bitcoin.h"
#import "DSAccount.h"
#import "DSWallet.h"
#import "DSBLSKey.h"
#import "DSIncomingFundsDerivationPath.h"
#import "NSMutableData+Dash.h"
#import "DSAuthenticationKeysDerivationPath.h"
#import "DSDerivationPathFactory.h"
#import "DSECDSAKey.h"
#import "NSData+Encryption.h"
#import "DashSync.h"

@interface DSSyncTests : XCTestCase

@property (strong, nonatomic) DSChain *chain;
@property (strong, nonatomic) DSWallet *wallet;
@property (strong, nonatomic) id blocksObserver, txStatusObserver;

@end

@implementation DSSyncTests

- (void)setUp {
    self.chain = [DSChain testnet];
    [self.chain unregisterAllWalletsMissingExtendedPublicKeys];
    self.wallet = [DSWallet standardWalletWithRandomSeedPhraseForChain:self.chain storeSeedPhrase:YES isTransient:NO];

    [self.chain registerWallet:self.wallet];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.chain unregisterWallet:self.wallet];
}

- (void)testExample {
    if (@available(iOS 13.0, *)) {
        [self measureWithMetrics:@[[[XCTCPUMetric alloc] init],[[XCTMemoryMetric alloc] init],[[XCTClockMetric alloc] init]] block:^{
            [[DashSync sharedSyncController] wipePeerDataForChain:self.chain inContext:[NSManagedObjectContext viewContext]];
            [[DashSync sharedSyncController] wipeBlockchainDataForChain:self.chain inContext:[NSManagedObjectContext viewContext]];
            [[DashSync sharedSyncController] wipeSporkDataForChain:self.chain inContext:[NSManagedObjectContext viewContext]];
            [[DashSync sharedSyncController] wipeMasternodeDataForChain:self.chain inContext:[NSManagedObjectContext viewContext]];
            [[DashSync sharedSyncController] wipeGovernanceDataForChain:self.chain inContext:[NSManagedObjectContext viewContext]];
            [[DashSync sharedSyncController] wipeWalletDataForChain:self.chain forceReauthentication:YES inContext:[NSManagedObjectContext viewContext]]; //this takes care of blockchain info as well;
            XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
            [[DashSync sharedSyncController] startSyncForChain:self.chain];
            self.txStatusObserver =
            [[NSNotificationCenter defaultCenter] addObserverForName:DSChainInitialHeadersDidFinishSyncingNotification object:nil
                                                               queue:nil usingBlock:^(NSNotification *note) {
                [expectation fulfill];
            }];
            [self waitForExpectations:@[expectation] timeout:36000];
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
