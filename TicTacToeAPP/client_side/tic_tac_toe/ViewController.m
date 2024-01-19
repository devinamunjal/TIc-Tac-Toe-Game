//
//  ViewController.m
//  tic_tac_toe
//
//  Created by Devina Munjal on 12/28/23.
//

#import "ViewController.h"
#import "TicTacToeClient.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (assign, nonatomic) BOOL isPlayer1Turn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //intializing player 1
    self.isPlayer1Turn = YES;
    
    // Set up your TicTacToeClient
//    self.ticTacToeClient = [[TicTacToeClient alloc] initWithServerIP:@"127.0.0.1" port:12348];
    //    [self.ticTacToeClient connectToServer];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.ticTacToeClient = appDelegate.ticTacToeClient;
    self.ticTacToeClient.vcObj = self;
    
}

//helper method
-(void)buttonClicked:(UIButton *)sender {
    //checked if button has been clicked
    if ([sender.titleLabel.text isEqualToString:@" "]) {
        if(_isPlayer1Turn == YES)
            [sender setTitle:@"X" forState:(UIControlStateNormal)];
        else
            [sender setTitle:@"O" forState:(UIControlStateNormal)];
        // Access the title text
        [self.ticTacToeClient readAndUpdateBoard];
        if(_isPlayer1Turn == YES){
            if([self isWinner: @"X" ] == YES){
                _winner.hidden = NO;
                [_winner setTitle:@"Player 1 Wins" forState:UIControlStateNormal];
                [self disableButtonsEnablePA];
                return;
            }
        }
        if (!_isPlayer1Turn){
            if([self isWinner: @"O" ] == YES){
                _winner.hidden = NO;
                [_winner setTitle:@"Player 2 Wins" forState:UIControlStateNormal];
                [self disableButtonsEnablePA];
                return;
            }
        }
        //check for draw
        [self checkForDraw];
        //change turn to next player
        self.isPlayer1Turn = !self.isPlayer1Turn;
        
    }
}
-(void)checkForDraw{
    if (![_button1.titleLabel.text isEqualToString:@" "] &&
        ![_button2.titleLabel.text isEqualToString:@" "] &&
        ![_button3.titleLabel.text isEqualToString:@" "] &&
        ![_button4.titleLabel.text isEqualToString:@" "] &&
        ![_button5.titleLabel.text isEqualToString:@" "] &&
        ![_button6.titleLabel.text isEqualToString:@" "] &&
        ![_button7.titleLabel.text isEqualToString:@" "] &&
        ![_button8.titleLabel.text isEqualToString:@" "] &&
        ![_button9.titleLabel.text isEqualToString:@" "]) {
        _winner.hidden = NO;
        [_winner setTitle:@"Draw" forState:UIControlStateNormal];
        [self disableButtonsEnablePA];
        return;
    }
}
-(void)disableButtonsEnablePA{
    _button1.enabled = NO;
    _button2.enabled = NO;
    _button3.enabled = NO;
    _button4.enabled = NO;
    _button5.enabled = NO;
    _button6.enabled = NO;
    _button7.enabled = NO;
    _button8.enabled = NO;
    _button9.enabled = NO;
    _playAgain.hidden = NO;
    //[_playAgain setTitle:(@"Play Again")
           //     forState:(UIControlStateNormal)];
}
- (void)updateBoardUIWithState:(NSString *)boardState {
    // Assuming boardState is a string representation of your board, e.g., "X O X  O X O X O"
    NSArray *boardArray = [boardState componentsSeparatedByString:@" "];
    
    // Assuming you have buttons in your view controller named button1, button2, ..., button9
    NSArray<UIButton *> *buttons = @[self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, self.button9];
    
    // Iterate through the board array and update button labels
    for (int i = 0; i < boardArray.count; i++) {
        NSString *symbol = boardArray[i];
        [buttons[i] setTitle:symbol forState:UIControlStateNormal];
    }
}
-(BOOL)isWinner:(NSString *) player {
    //check row1
    
    if([_button1.titleLabel.text isEqualToString:player] && [_button2.titleLabel.text isEqualToString:player] && [_button3.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check row2
    if([_button4.titleLabel.text isEqualToString:player] && [_button5.titleLabel.text isEqualToString:player] && [_button6.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check row3
    if([_button7.titleLabel.text isEqualToString:player] && [_button8.titleLabel.text isEqualToString:player] && [_button9.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check col1
    if([_button1.titleLabel.text characterAtIndex:0] == [player characterAtIndex:0] &&
        [_button4.titleLabel.text characterAtIndex:0] == [player characterAtIndex:0] &&
        [_button7.titleLabel.text characterAtIndex:0] == [player characterAtIndex:0]){
        NSLog(@"col state passed: %@", _button1.titleLabel.text);
        return YES;
    }
    else
        NSLog(@"col state failed: %@", _button1.titleLabel.text);
    //check col2
    if([_button2.titleLabel.text isEqualToString:player] && [_button5.titleLabel.text isEqualToString:player] && [_button8.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check col3
    if([_button3.titleLabel.text isEqualToString:player] && [_button6.titleLabel.text isEqualToString:player] && [_button9.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check diag1
    if([_button1.titleLabel.text isEqualToString:player] && [_button5.titleLabel.text isEqualToString:player] && [_button9.titleLabel.text isEqualToString:player]){
        return YES;
    }
    //check diag2
    if([_button3.titleLabel.text isEqualToString:player] && [_button6.titleLabel.text isEqualToString:player] && [_button7.titleLabel.text isEqualToString:player]){
        return YES;
    }
    return NO;
}

- (IBAction)winnerDisplay:(id)sender {
}

- (IBAction)button1click:(id)sender {
    [self buttonClicked: sender];
    NSString *move = _button1.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button1.titleLabel.text,
        @"value": @(1)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

    
}

- (IBAction)playAgainClick:(id)sender {
    _playAgain.hidden = YES;
    _winner.hidden = YES;
    [_button1 setTitle:@" " forState:UIControlStateNormal ];
    [_button2 setTitle:@" " forState:UIControlStateNormal ];
    [_button3 setTitle:@" " forState:UIControlStateNormal ];
    [_button4 setTitle:@" " forState:UIControlStateNormal ];
    [_button5 setTitle:@" " forState:UIControlStateNormal ];
    [_button6 setTitle:@" " forState:UIControlStateNormal ];
    [_button7 setTitle:@" " forState:UIControlStateNormal ];
    [_button8 setTitle:@" " forState:UIControlStateNormal ];
    [_button9 setTitle:@" " forState:UIControlStateNormal ];
    _button1.enabled = YES;
    _button2.enabled = YES;
    _button3.enabled = YES;
    _button4.enabled = YES;
    _button5.enabled = YES;
    _button6.enabled = YES;
    _button7.enabled = YES;
    _button8.enabled = YES;
    _button9.enabled = YES;
}
- (IBAction)button2click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button2.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button2.titleLabel.text,
        @"value": @(2)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

        
    
}
- (IBAction)button3click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button3.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button3.titleLabel.text,
        @"value": @(3)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

 
    
}
- (IBAction)button4click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button4.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button4.titleLabel.text,
        @"value": @(4)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

  
        
}
- (IBAction)button5click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button5.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button5.titleLabel.text,
        @"value": @(5)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

  
        
}
- (IBAction)button6click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button6.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button6.titleLabel.text,
        @"value": @(6)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

    
}
- (IBAction)button7click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button7.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button7.titleLabel.text,
        @"value": @(7)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

  
}
- (IBAction)button8click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button8.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button8.titleLabel.text,
        @"value": @(8)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];


}
- (IBAction)button9click:(id)sender {
    [self buttonClicked:sender];
    NSString *move = _button9.titleLabel.text;
    
    // Create a dictionary with move information
    NSDictionary *moveDict = @{
        @"move": _button9.titleLabel.text,
        @"value": @(9)
    };
    // Print move and ticTacToeClient
    printf("what is move %s\n", [move UTF8String]);// Assuming self.ticTacToeClient is a string
    
    // Send the move to the server
    [self.ticTacToeClient sendMove:moveDict];

   
}


@end
