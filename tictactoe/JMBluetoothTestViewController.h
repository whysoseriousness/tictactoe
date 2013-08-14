//
//  JMBluetoothTestViewController.h
//  tictactoe
//
//  Created by Joshua Martin on 8/14/13.
//  Copyright (c) 2013 Joshua Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface JMBluetoothTestViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *ReceivedMessageLabel;
@property (weak, nonatomic) IBOutlet UITextField *OutgoingMessageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) GKSession *session;
- (IBAction)SendMessage:(id)sender;
- (IBAction)connectToDevice:(id)sender;

@end
