//
//  Grid.m
//  GameOfLife
//
//  Created by ChaoticDawgSoftware on 10/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Grid.h"
#import "Creature.h"

// these are variables that cannot be changed
static const int GRID_ROWS = 8;
static const int GRID_COLUMNS = 10;

@implementation Grid {
    NSMutableArray *_gridArray;
    float _cellWidth;
    float _cellHeight;
}

-(void) onEnter {
    [super onEnter];
    
    [self setupGrid];
    
    // accept touches from the grid
    self.userInteractionEnabled = YES;
}

-(void) setupGrid {
    // divide the grid's size by the number of the columns/rows tp figure out the right width and height
    // of each cell
    _cellWidth = self.contentSize.width / GRID_COLUMNS;
    _cellHeight = self.contentSize.height / GRID_ROWS;
    
    float x = 0;
    float y = 0;
    
    // initialize the array as a blank NSMutableArray
    _gridArray = [NSMutableArray array];
    
    // initialize Creatures
    for (int i = 0; i < GRID_ROWS; i++) {
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < GRID_COLUMNS; j++) {
            Creature *creature = [[Creature alloc] initCreature];
            creature.anchorPoint = ccp(0,0);
            creature.position = ccp(x,y);
            [self addChild:creature];
            
            // this is shorthand to access an array inside an array
            _gridArray[i][j] = creature;
            
            // make creatures visible to test this method, remove this once we know we have filled the grid
            //creature.isAlive = YES;
            
            x += _cellWidth;
        }
        y += _cellHeight;
    }
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // get the x, y cordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    
    // get the Creature at that location
    Creature *creature = [self creatureForTouchPosition:touchLocation];
    
    // invert it's state - kill it if it's alive, bring it to life if it's dead.
    creature.isAlive = !creature.isAlive;
}

-(Creature *)creatureForTouchPosition:(CGPoint) touchPostion {
    // get the row and column that was touched, return the Creature inside the corresponding cell
    int row = touchPostion.y / _cellHeight;
    int column = touchPostion.x / _cellWidth;
    
    return _gridArray[row][column];
}

@end
