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

-(void) evolveStep {
    // update each creature's neighbor count
    [self countNeighbors];
    
    // update each creature's state
    [self updateCreatures];
    
    // update the generation so the label's text will display the correct generation
    _generation++;
    
}

-(void) countNeighbors {
    // iterate through the rows
    // note that NSArray has a method 'count' that will return the number of elements
    
    for (int i = 0; i < [_gridArray count]; i++) {
        
        // iterate through all the columns for a given row
        for (int j = 0; j < [_gridArray[i] count]; j++) {
            
            // access the creature in the cell that corresponds to the current row/column
            Creature *currentCreature = _gridArray[i][j];
            
            // remember that every creature has a livingNeighbors property that we created earlier
            currentCreature.livingNeighbors = 0;
            
            // now examine every cell around the current one
            
            // go through the row on the top of the current cell, the row the cell is in,
            // and the row below the current cell
            for (int x = (i-1); x <= (i+1); x++) {
                
                // go through the column to the left of the current cell, the column the current cell
                // is in and the column to the right of the current cell.
                for (int y = (j-1); y <= (j+1); y++) {
                    
                    // check that the cell we're checking isn't off the screen
                    BOOL isIndexValid = [self isIndexValidForX:x andY:y];
                    
                    // skip over all cells that are off the screen AND the cell that contains the
                    // creature we are currently updating.
                    if (!((x == i) && (y == j)) && isIndexValid) {
                        Creature *neighbor = _gridArray[x][y];
                        if (neighbor.isAlive) {
                            currentCreature.livingNeighbors += 1;
                        }
                    }
                }
                
            }
        }
    }
    
}

-(void) updateCreatures {
    for (int row = 0; row < [_gridArray count]; row++) {
        
        for (int col = 0; col < [_gridArray[row] count]; col++) {
            
            Creature *currentCreature = _gridArray[row][col];
            
            if (currentCreature.livingNeighbors == 3) {
                currentCreature.isAlive = YES;
            } else if (currentCreature.livingNeighbors <= 1 || currentCreature.livingNeighbors >= 4) {
                currentCreature.isAlive = NO;
            }
        }
    }
    
}

-(BOOL)isIndexValidForX:(int)x andY:(int)y {
    BOOL isIndexValid = YES;
    if(x < 0 || x >= GRID_ROWS || y >= GRID_COLUMNS) {
        isIndexValid = NO;
    }
    
    return isIndexValid;
}


@end
