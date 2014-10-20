//
//  PlayingCard.h
//  Matchismo
//
//  Created by Li-Wei Tseng on 9/17/14.
//  Copyright (c) 2014 Li-Wei Tseng. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) int rank;

+ (NSArray *)validSuits;
+ (NSInteger)maxRank;
@end
