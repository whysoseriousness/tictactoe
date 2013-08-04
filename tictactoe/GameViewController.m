//
//  GameViewController.m
//  tictactoe
//
//  Created by Joshua Martin on 8/1/13.
//  Copyright (c) 2013 Joshua Martin. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
NSArray * buttons;
NSMutableArray * boardValues;
NSString * currentPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttons = [NSArray arrayWithObjects: _button0,_button1,_button2,
                                         _button3,_button4,_button5,
                                         _button6,_button7,_button8, nil];
    
    boardValues = [NSMutableArray arrayWithObjects: @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
	currentPlayer = @"X";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) movePlayerTo: (int) spot
{
    UIButton * btn = buttons[spot];
    [btn setEnabled:false];
    [btn setTitle:currentPlayer forState:UIControlStateDisabled];
    [boardValues replaceObjectAtIndex:spot withObject:currentPlayer];
}

-(void) switchPlayers
{
    if([currentPlayer isEqualToString: @"X" ])
    {
        currentPlayer = @"O";
        
    }else{
        currentPlayer = @"X";
    }
    [_infoLabel setText:[NSString stringWithFormat:@"Player %@'s turn", currentPlayer]];
}

- (void) setButtonsEnabledTo: (bool) e
{
    for (UIButton *btn in buttons) {
        [btn setEnabled:e];
    }
}

- (void) gameWonBy: (NSString*) player
{
    if ([player isEqualToString:@""]) {  return; }
    [_infoLabel setText:[NSString stringWithFormat:@"Player %@ wins!", player]];
    [self setButtonsEnabledTo:false];
}

-(bool) allSpotsFull
{
    for (NSString *s in boardValues) {
        if([s isEqualToString:@""]){
            return false;
        }
    }
    return true;
}

-(void) gameTied
{
    [_infoLabel setText:@"Cat's Game!"];
    [self setButtonsEnabledTo:false];
}

-(NSString*) getBoardValueAtX: (int) x andY: (int) y
{
    if (x >= 3 || y >= 3) { return NULL; }
    if (y*3 + x >= 9){ return NULL; }
    
    return boardValues[y*3 + 9];
    
}

-(void) computerMoveAsPlayer: (NSString *) player
{
//    int winningPermutations[4] = {1, 3, 2, 4};
    int winningPermutations [4][2] = {{0,1}, {1,0}, {1,1}, {-1,1}};
    for (int i = 0; i < 3; i++) {
//        if(){ [self getBoardValueAtX:(i + dx) andY:(i + dy)]
    }
    
    

}

-(void) checkForWin
{
    for (int i = 0; i < boardValues.count; i++) {
        if(i < 3){ //Check vertical cases
            if([boardValues[i] isEqualToString:boardValues[i + 3]] && [boardValues[i+3] isEqualToString:boardValues[i + 6]]){
                [self gameWonBy:boardValues[i]];
                return;
                
            }
        }
        
        if(i%3 == 0){//Check horizontal cases
            if([boardValues[i] isEqualToString:boardValues[i+1]] && [boardValues[i+1] isEqualToString:boardValues[i+2]]){
                [self gameWonBy:boardValues[i]];
                return;
            }
        }
    }
        
    //forward slash case
    if([boardValues[0] isEqualToString:boardValues[4]] && [boardValues[4] isEqualToString:boardValues[8]]){
        [self gameWonBy:boardValues[0]];
        return;
    }

    //backslash case
    if([boardValues[2] isEqualToString:boardValues[4]] && [boardValues[4] isEqualToString:boardValues[6]]){
        [self gameWonBy:boardValues[4]];
        return;
    }
    
    
    if ([self allSpotsFull]) {
        [self gameTied];
        return;
    }
    
}

- (IBAction)buttonWasTouchedUpInside:(UIButton *)sender {
    for (int i = 0; i < buttons.count; i++) {
        UIButton *btn = buttons[i];
        if (sender == btn) {
            [self movePlayerTo:i];
            [self switchPlayers];
            [self checkForWin];
        }
    }
}
@end
