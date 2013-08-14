//
//  BluetoothGameViewController.h
//  tictactoe
//
//  Created by Dylan Ellington on 8/2/13.
//  Copyright (c) 2013 Joshua Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

typedef NS_ENUM(NSUInteger, Datatype)
{
    SendGeneratedNumber = 0,
    ReceiveGeneratedNumber = 1,
    PlayerMove = 2
};

typedef NS_ENUM(NSUInteger, GameButtons)
{
    ButtonZero, ButtonOne, ButtonTwo,
    ButtonThree,ButtonFour,ButtonFive,
    ButtonSix, ButtonSeven,ButtonEight
//    nil
};

@interface BluetoothGameViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate, NSCoding>
{
    GKSession *session;
    IBOutlet UIButton *disconnect;
    Datatype type;
    GameButtons button;
}

@property (nonatomic, retain) GKSession *session;
@property (nonatomic, retain) UIButton *disconnect;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic) Datatype type;
@property (nonatomic) GameButtons button;
@property (nonatomic, strong) NSMutableArray *DataToPack;
@property (nonatomic, strong) NSMutableArray *DataToUnpack;
@property (nonatomic) int playernumber;
@property (nonatomic) int opponentnumber;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;

- (IBAction) disconnect:(id) sender;

- (void) LoadGame;

@end