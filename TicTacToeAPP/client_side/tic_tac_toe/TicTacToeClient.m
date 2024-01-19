// TicTacToeClient.m
#import "TicTacToeClient.h"
#import <UIKit/UIKit.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#import "ViewController.h"

#define BUFFER_SIZE 1024

@interface TicTacToeClient ()

@property (nonatomic, copy) NSString *serverIP;
@property (nonatomic, assign) NSUInteger port;
@property (nonatomic, assign) int clientSocket;


//@property (assign, nonatomic) BOOL assignSymbols;
@end

@implementation TicTacToeClient

- (instancetype)initWithServerIP:(NSString *)serverIP port:(int)port {
    self = [super init];
    if (self) {
        self.serverIP = [serverIP copy];
        self.port = port;
        self.clientSocket = -1; // Initialize socket to an invalid value
        //_assignSymbols = NO;
    }
    return self;
}

- (void)connectToServer {
    // Use GCD to run the connection in a background queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create a socket
        self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
        if (self.clientSocket == -1) {
            perror("Error creating socket");
            exit(EXIT_FAILURE);
        }

        // Set up the server address
        struct sockaddr_in serverAddr;
        serverAddr.sin_family = AF_INET;
        serverAddr.sin_port = htons(self->_port);
        inet_pton(AF_INET, [self->_serverIP UTF8String], &(serverAddr.sin_addr));

        // Connect to the server
        if (connect(self.clientSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == -1) {
            perror("Error connecting to server");
            exit(EXIT_FAILURE);
        }

        NSLog(@"Connected to the server");
        // Perform any UI-related updates on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            // For example, you might update a label or enable/disable UI elements
            // [self updateStatusLabel:@"Connected"];
        });
    });
}
- (void)sendMove:(NSDictionary *)moveInfo;{
    NSString *move = moveInfo[@"move"];
    NSValue *value = moveInfo[@"value"];
    
    NSLog(@"Connected to the server. Sending move... %@", move);

    // Convert NSValue to int (assuming it contains an NSNumber)
    int intValue;
    [value getValue:&intValue];

    // Create a string representation of the integer value
    NSString *valueString = [NSString stringWithFormat:@"%d", intValue];

    // Combine move and value into a single string
    NSString *combinedString = [NSString stringWithFormat:@"%@ %@", move, valueString];

    const char *combinedStr = [combinedString UTF8String];

    // Send the combined string to the server
    ssize_t bytesSent = write(_clientSocket, combinedStr, strlen(combinedStr));
        
    // Handle any error checking for bytesSent if needed
    if (bytesSent == -1) {
        perror("Error sending move");
    }
   /* if(!_assignSymbols){
        //Now, read the server's response
        char responseBuffer[BUFFER_SIZE];
        ssize_t bytesRead = read(_clientSocket, responseBuffer, sizeof(responseBuffer) - 1);

        if (bytesRead <= 0) {
            perror("Error reading from server");
        } else {
            responseBuffer[bytesRead] = '\0';
            printf("Server response: %s\n", responseBuffer);
        }
        */
    
 
}


- (void)dealloc {
    // Close the client socket when the object is deallocated
    if (_clientSocket != -1) {
        close(_clientSocket);
        self.clientSocket = -1; // Set to an invalid value after closing
    }
}

- (void)closeConnection {
    if (_clientSocket != -1) {
        close(_clientSocket);
        self.clientSocket = -1; // Set to an invalid value after closing
    }
}

- (int)getSocket {
    return _clientSocket;
}
- (void)readAndUpdateBoard {
    char responseBuffer[BUFFER_SIZE];
    ssize_t bytesRead = read(_clientSocket, responseBuffer, sizeof(responseBuffer) - 1);

    if (bytesRead <= 0) {
        perror("Error reading from server");
    } else {
        responseBuffer[bytesRead] = '\0';
        NSLog(@"reading %s\n", responseBuffer);
        NSString *boardString = [NSString stringWithUTF8String:responseBuffer];
        [self.vcObj updateBoardUIWithState: boardString];
        /*
        // Assuming the server sends the updated board state as a string
        NSString *boardString = [NSString stringWithUTF8String:responseBuffer];

        // Implement a method to update the UI with the new board state
        [self updateBoardUIWithState:boardString]; */
    }
}

@end

