//
//  JMBluetoothTestViewController.m
//  tictactoe
//
//  Created by Joshua Martin on 8/14/13.
//  Copyright (c) 2013 Joshua Martin. All rights reserved.
//

#import "JMBluetoothTestViewController.h"

@interface JMBluetoothTestViewController ()

@end

@implementation JMBluetoothTestViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SendMessage:(id)sender {
    //package text field text as NSData object
    NSData *textData = [_OutgoingMessageField.text dataUsingEncoding:NSASCIIStringEncoding];
    //send data to all connected devices
    [self.session sendDataToAllPeers:textData withDataMode:GKSendDataReliable error:nil];
}

- (void)connectToDevice:(id)sender {
    if (self.session == nil) {
        //create peer picker and show picker of connections
        GKPeerPickerController *peerPicker = [[GKPeerPickerController alloc] init];
        peerPicker.delegate = self;
        peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        [peerPicker show];
    }
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    //create ID for session
    NSString *sessionIDString = @"JMBluetoothTestSessionID";
    //create GKSession object
    GKSession *session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    //set session delegate and dismiss the picker
    session.delegate = self;
    self.session = session;
    picker.delegate = nil;
    [picker dismiss];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateConnected){
        [session setDataReceiveHandler:self withContext:nil]; //set ViewController to receive data
        _sendButton.enabled = YES; //enable send button when session is connected
    }
    else {
        _sendButton.enabled = NO; //disable send button if session is disconnected
        self.session.delegate = nil;
        self.session = nil; //allow session to reconnect if it gets disconnected
    }
}


- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    //unpackage NSData to NSString and set incoming text as label's text
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    _ReceivedMessageLabel.text = receivedString;
}

@end
