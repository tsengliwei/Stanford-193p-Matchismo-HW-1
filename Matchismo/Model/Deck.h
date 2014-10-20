//
//  Deck.h
//  Matchismo
//
//  Created by Li-Wei Tseng on 9/17/14.
//  Copyright (c) 2014 Li-Wei Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
