//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Li-Wei Tseng on 9/17/14.
//  Copyright (c) 2014 Li-Wei Tseng. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray *flipsHistory;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

- (NSMutableArray *)flipsHistory
{
    if (!_flipsHistory) {
        _flipsHistory = [NSMutableArray array];
    }
    return _flipsHistory;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
        [self segmentedControl:self.segmentedControl];
    }
    return _game;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
    self.segmentedControl.enabled = NO;
    //[self switchSegmentedControl:self.segmentedControl switchOn:NO]; // Once a flip starts, disable the segmented control
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int chosenButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:chosenButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if (self.game) {
        NSString *description = @"";
        
        if ([self.game.lastChosenCards count]) {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards) {
                [cardContents addObject:card.contents];
            }
            description = [cardContents componentsJoinedByString:@" "];
        }
        if (self.game.lastScore > 0) {
            description = [NSString stringWithFormat:@"Matched %@ for %d points", description, self.game.lastScore];
        } else if (self.game.lastScore < 0) {
            description = [NSString stringWithFormat:@"%@ don't match! %d penalty!", description, -self.game.lastScore];
        }
        self.statusLabel.text = description;
        self.statusLabel.alpha = 1;
        
        if (![description isEqualToString:@""]
            && ![[self.flipsHistory lastObject] isEqualToString:description]) {
            [self.flipsHistory addObject:description];
            [self setSliderRange];
        }
    }
}

- (NSString *)titleForCard: (Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard: (Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)reDeal:(UIButton *)sender {
    self.game = nil;
    self.flipsHistory = nil;
    //[self switchSegmentedControl:self.segmentedControl switchOn:YES]; // Re-enable the segmented control when the user re-deal the game
    self.segmentedControl.enabled = YES;
    [self updateUI];
}

- (IBAction)segmentedControl:(UISegmentedControl *)sender {
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (void)switchSegmentedControl: (UISegmentedControl *)segmentedControl
                      switchOn: (BOOL)change
{
    // switch the segmentedControl
    for (int i = 0; i < [segmentedControl numberOfSegments] ; i++) {
        [segmentedControl setEnabled:change forSegmentAtIndex:i];
    }
}

- (IBAction)changeSlider:(UISlider *)sender {
    int sliderValue;
    sliderValue = lroundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    if ([self.flipsHistory count]) {
        self.statusLabel.alpha = (sliderValue + 1 < [self.flipsHistory count]) ? 0.6 : 1.0;
        self.statusLabel.text =
        [self.flipsHistory objectAtIndex:sliderValue];
    }
}

- (void)setSliderRange
{
    int maxValue = [self.flipsHistory count] - 1;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES];
}


@end
