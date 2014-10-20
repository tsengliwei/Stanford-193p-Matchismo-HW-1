//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Li-Wei Tseng on 9/18/14.
//  Copyright (c) 2014 Li-Wei Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype) initWithCardCount:(NSUInteger)count
                         usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger maxMatchingCards;
@property (nonatomic) NSArray *lastChosenCards;
@property (nonatomic) NSInteger lastScore;
@end
