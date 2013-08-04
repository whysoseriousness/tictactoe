//
//  BluetoothGameViewController.m
//  tictactoe
//
//  Created by Dylan Ellington on 8/2/13.
//  Copyright (c) 2013 Joshua Martin. All rights reserved.
//

#import "BluetoothGameViewController.h"

@interface BluetoothGameViewController ()

@end

@implementation BluetoothGameViewController
@synthesize session;
@synthesize disconnect;
@synthesize type;
@synthesize button;

//------------------------------------------ Default Functions ------------------------------------------

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
    
    if (self.session == nil)
    {
    GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
    [picker show];
    }
    
	// Do any additional setup after loading the view.

    [_infoLabel setHidden:YES];
    [_button0 setHidden:YES]; [_button1 setHidden:YES]; [_button2 setHidden:YES];
    [_button3 setHidden:YES]; [_button4 setHidden:YES]; [_button5 setHidden:YES];
    [_button6 setHidden:YES]; [_button7 setHidden:YES]; [_button8 setHidden:YES];
    [disconnect setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------ Variables ------------------------------------------

GKPeerPickerController *picker;
NSArray * buttons;
NSMutableArray * boardValues;

//------------------------------------------ Bluetooth Connection ------------------------------------------

- (GKSession *) peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    GKSession* gamesession = [[GKSession alloc] initWithSessionID:@"TicTacToe" displayName:nil sessionMode:GKSessionModePeer];
    return gamesession;
}

- (void) peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)gamepeerID toSession:(GKSession *)gamesession
{
    self.session = gamesession;
    self.session.delegate = self;
    [self.session setDataReceiveHandler:self withContext:nil];
    self.peerID = gamepeerID;
    
    picker.delegate = nil;
    [picker dismiss];
}

- (void) peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) session:(GKSession *)gamesession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateConnected)
    {
        [self LoadGame];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disconnected" message:@"Connection has been lost or the other player has quit." delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil, nil];
        [alert show];
        [gamesession disconnectFromAllPeers];
        [gamesession setDataReceiveHandler:nil withContext:nil];
        gamesession.delegate = nil;
        self.session = nil;
        
    }
}

- (void) Send:(NSData *)s_data Datatype:(Datatype *) type session:(GKSession *)gamesession
{
    switch (self.type) //very wrong just placeholding for now
    {
        case Player:
            [self.session sendDataToAllPeers:/*encoded data*/nil withDataMode:GKSendDataReliable error:nil];
            break;
            
        case Move:
            [self.session sendDataToAllPeers:/*encoded data*/nil withDataMode:GKSendDataReliable error:nil];
            
        default:
            break;
    }
}

- (void) Recieve:(NSData *)r_data fromPeer:(NSString *)peer inSession:(GKSession *)gamesession
{
    //decode data with type
    
    /*switch (type)
     {
     case FirstPlayer:
     set first player
     call current turn
     break;
     
     case TurnData
     recieve board update and game status
     break;
     
     default:
     break;
     }*/
    
}

//------------------------------------------ Game Functions ------------------------------------------

- (void) LoadGame
{
    [_infoLabel setHidden:NO];
    [_button0 setHidden:NO]; [_button1 setHidden:NO]; [_button2 setHidden:NO];
    [_button3 setHidden:NO]; [_button4 setHidden:NO]; [_button5 setHidden:NO];
    [_button6 setHidden:NO]; [_button7 setHidden:NO]; [_button8 setHidden:NO];
    [disconnect setHidden:NO];
    
    buttons = [NSArray arrayWithObjects: _button0,_button1,_button2,
               _button3,_button4,_button5,
               _button6,_button7,_button8, nil];
    
    boardValues = [NSMutableArray arrayWithObjects: @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    
    [self ChooseFirstPlayer];
}


- (void) ChooseFirstPlayer
{
    
    //send data
}

- (void) CurrentPlayerTurn
{
    //disable or enable buttons accordingly and update label
}

- (void) CheckForWin
{
    //check for win
    
    //send board update and game status
}

- (IBAction)buttonWasTouchedUpInside:(UIButton *)sender
{
    for (int i = 0; i < buttons.count; i++)
    {
        UIButton *btn = buttons[i];
        
        if (sender == btn)
        {
            //[self movePlayerTo:i];
            [self CurrentPlayerTurn];
            [self CheckForWin];
        }
    }
}

-(IBAction) disconnect:(id) sender
{
    [self.session disconnectFromAllPeers];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end