//
//  Creature.h
//  GameOfLife
//
//  Created by ChaoticDawgSoftware on 10/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Creature : CCSprite

//Stores the current state of the creature
@property (nonatomic, assign) BOOL isAlive;

//stores the amount of living neighbors
@property (nonatomic, assign) NSInteger livingNeighbors;

-(id) initCreature;

@end
