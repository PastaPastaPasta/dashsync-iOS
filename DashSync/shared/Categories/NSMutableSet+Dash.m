//
//  Created by Vladimir Pirogov
//  Copyright © 2021 Dash Core Group. All rights reserved.
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

#import "NSMutableSet+Dash.h"

@implementation NSMutableSet (Dash)

- (NSMutableSet *)compactMap:(id (^)(id obj))block {
    NSParameterAssert(block != nil);
    NSMutableSet *result = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        id mObj = block(obj);
        if (mObj && mObj != [NSNull null]) {
            [result addObject:mObj];
        }
    }];
    return result;
}

- (NSMutableSet *)map:(id (^)(id obj))block {
    NSParameterAssert(block != nil);
    NSMutableSet *result = [NSMutableSet setWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, BOOL *_Nonnull stop) {
        [result addObject:block(obj) ?: [NSNull null]];
    }];
    return result;
}

@end
