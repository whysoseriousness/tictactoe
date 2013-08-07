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
@synthesize session, disconnect, type, button, DataToPack, DataToUnpack, playernumber, opponentnumber;

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
    [self PackData:SendGeneratedNumber :playernumber :nil];

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

+ (NSDictionary *) datatypes
{
    return @
    {
        @(SendGeneratedNumber) : @"SendGeneratedNumber",
        @(ReceiveGeneratedNumber) : @"ReceiveGeneratedNumber",
        @(PlayerMove) : @"PlayerMove"
    };
}

+ (NSDictionary *) gamebuttons
{
    return @
    {
        @(ButtonZero) : @"ButtonZero",   @(ButtonOne) : @"ButtonOne",     @(ButtonTwo) : @"ButtonTwo",
        @(ButtonThree) : @"ButtonThree", @(ButtonFour) : @"ButtonFour",   @(ButtonFive) : @"ButtonFive",
        @(ButtonSix) : @"ButtonSix",     @(ButtonSeven) : @"ButtonSeven", @(ButtonEight) : @"ButtonEight"
    };
}

- (GKSession *) peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    GKSession* gamesession = [[GKSession alloc] initWithSessionID:@"TicTacToe" displayName:nil sessionMode:GKSessionModePeer];
    return gamesession;
}

- (void) peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
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

//prototype function: note that is doesnt work right

- (void) PackData :(Datatype) datatype :(NSInteger) generatednumber :(GameButtons) gamebutton
{
    if (datatype == 0) //Player Generated Number
    {
        NSString *pgn = [[self class] datatypes][@(SendGeneratedNumber)]; //Pack Datatype
        [DataToPack addObject: pgn];
        
        NSNumber *gn = [NSNumber numberWithInteger:(generatednumber)]; //Pack Generated Number
        [DataToPack addObject: gn];
    }
    
    if (datatype == 2) //Player Move
    {
        NSString *gb = [[self class] datatypes][@(PlayerMove)]; //Pack Datatype
        [DataToPack addObject: gb];
    
        if (gamebutton < 9 & gamebutton > -1)   //Pack Player Move
        {
            switch (gamebutton) {
                case 0:
                {
                    NSString *gb0 = [[self class] datatypes][@(ButtonZero)];
                    [DataToPack addObject: gb0];
                    break;
                }
                case 1:
                {
                    NSString *gb1 = [[self class] datatypes][@(ButtonOne)];
                    [DataToPack addObject: gb1];
                    break;
                }
                case 2:
                {
                    NSString *gb2 = [[self class] datatypes][@(ButtonTwo)];
                    [DataToPack addObject: gb2];
                    break;
                }
                case 3:
                {
                    NSString *gb3 = [[self class] datatypes][@(ButtonThree)];
                    [DataToPack addObject: gb3];
                    break;
                }
                case 4:
                {
                    NSString *gb4 = [[self class] datatypes][@(ButtonFour)];
                    [DataToPack addObject: gb4];
                    break;
                }
                case 5:
                {
                    NSString *gb5 = [[self class] datatypes][@(ButtonFive)];
                    [DataToPack addObject: gb5];
                    break;
                }
                case 6:
                {
                    NSString *gb6 = [[self class] datatypes][@(ButtonSix)];
                    [DataToPack addObject: gb6];
                    break;
                }
                case 7:
                {
                    NSString *gb7 = [[self class] datatypes][@(ButtonSeven)];
                    [DataToPack addObject: gb7];
                    break;
                }
                case 8:
                {
                    NSString *gb8 = [[self class] datatypes][@(ButtonEight)];
                    [DataToPack addObject: gb8];
                    break;
                }
                default:
                    break;
            }
        }
    }
    
    NSLog(@"DATATYPE %@", [DataToPack objectAtIndex:0]);
    NSLog(@"VALUE %@", [DataToPack objectAtIndex:1]);
    
    // PACKING WILL MOST NOT LIKELY WORK. MAY NEED TO CREATE SEPERATE FILE
    NSData *PackedData = [NSKeyedArchiver archivedDataWithRootObject:DataToPack];
    [self Send:PackedData];
}

- (void) Send:(NSData *)send //NOT YET TESTED
{
    [self.session sendDataToAllPeers:send withDataMode:GKSendDataReliable error:nil];
}

- (void) Recieve:(NSData *)recieve fromPeer:(NSString *)peer session:(GKSession *)gamesession //NOT YET TESTED
{
    DataToUnpack = [NSKeyedUnarchiver unarchiveObjectWithData:recieve];
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
    
    playernumber = arc4random_uniform(1000);
    
    [self PackData:SendGeneratedNumber :playernumber :nil];
    [self ChooseFirstPlayer];
}


- (void) ChooseFirstPlayer
{

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