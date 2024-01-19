#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/stat.h>
#define BOARD_SIZE 3
#define PORT 12348
#define BUFFER_SIZE 1024

char board[BOARD_SIZE][BOARD_SIZE] = {{' ', ' ', ' '}, {' ', ' ', ' '}, {' ', ' ', ' '}};
int clientSocket1 = -1;
int clientSocket2 = -1;
static int check = 0;
int clientCounter = 0;
static char* arr;  // Now using char* for shared memory
static int* playerSockets;

void initializeSharedMemory() {
    // Create a shared memory region
    int shm_fd = shm_open("/tic_tac_toe_shared_memory", O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
        perror("Error creating shared memory");
        exit(EXIT_FAILURE);
    }
    // Set the size of the shared memory region
       ftruncate(shm_fd, 9 + sizeof(int) * 2);  // For arr and two player sockets

       // Map the shared memory into the process address space
       void* ptr = mmap(NULL, 9 + sizeof(int) * 2, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
       if (ptr == MAP_FAILED) {
           perror("Error mapping shared memory");
           exit(EXIT_FAILURE);
       }

       // Set the pointers to the corresponding locations in shared memory
       arr = (char*)ptr;
       playerSockets = (int*)(ptr + 9);

       // Close the file descriptor, as it's no longer needed
       close(shm_fd);
}
   
void resetSharedMemory() {
    // Reset the shared memory region to initial values
    for (int i = 0; i < 9; ++i) {
        arr[i] = ' ';
    }
    for (int i = 0; i < 2; ++i) {
        playerSockets[i] = -1;
    }
}

void printBoard() {
    for (int i = 0; i < BOARD_SIZE; i++) {
        for (int j = 0; j < BOARD_SIZE; j++) {
            printf("%c ", board[i][j]);
        }
        printf("\n");
    }
}

int isMoveValid(int row, int col) {
    return row >= 0 && row < BOARD_SIZE && col >= 0 && col < BOARD_SIZE && board[row][col] == ' ';
}

int isWinner(char player) {
    for (int i = 0; i < BOARD_SIZE; i++) {
        if (board[i][0] == player && board[i][1] == player && board[i][2] == player) {
            return 1; // Row win
        }
        if (board[0][i] == player && board[1][i] == player && board[2][i] == player) {
            return 1; // Column win
        }
    }
    if (board[0][0] == player && board[1][1] == player && board[2][2] == player) {
        return 1; // Diagonal win
    }
    if (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
        return 1; // Diagonal win
    }
    return 0; // No win
}

void sendBoardState(int socket, char arr[9]) {
    char buffer[BUFFER_SIZE];
    snprintf(buffer, sizeof(buffer), "Updated Board:\n");
    for (int i = 0; i < 9; i++) {
        snprintf(buffer, sizeof(buffer), "%c ", arr[i]);
    }
    write(socket, buffer, strlen(buffer));
    printf("sending on socket %d \n", socket);
}
void handleMove(char buffer[], int playerN) {
    char symbol;
    int number;
    // Parse the values from the buffer
    if (sscanf(buffer, "%c %d", &symbol, &number) == 2) {
        printf("Symbol: %c\n", symbol);
        printf("Number: %d\n", number);
        arr[number] = symbol;
        for(int x = 0; x < 9; x++){
            printf("%c ", arr[x]);
        }
        printf("\n");
        printf("playerSockets[0] %d+ [1]%d \n",playerSockets[0], playerSockets[1]);
        sendBoardState(playerSockets[0], arr);
        sendBoardState(playerSockets[1], arr);
    } else {
        // Handle the case where sscanf couldn't parse the expected values
        printf("Failed to parse the buffer.\n");
    }
    
}


void handleClient(int socket, int playerNumber) {
    if (playerNumber == 1) {
           clientSocket1 = socket;
       } else if (playerNumber == 2) {
           clientSocket2 = socket;
       } else {
           // Handle the case where more than two players connect or playerNumber is invalid
           printf("Error: Invalid player number or more than two players connected\n");
           close(socket);
           return;
       }

    // Send a welcome message to the client
    char buffer[BUFFER_SIZE];

    while (1) {

        // Receive the move from the client
        write(socket, buffer, strlen(buffer));
        // Read the move from the client
        ssize_t bytesRead = read(socket, buffer, sizeof(buffer) - 1);
        if (bytesRead <= 0) {
            perror("Error reading from client");
            break;
        }

        buffer[bytesRead] = '\0';

        printf("Received move from client: %s %d %d\n", buffer, socket, playerNumber);
        handleMove(buffer, playerNumber);
              
            }
            // Close the client socket
            close(socket);

            // Notify the other player that the opponent has disconnected
            if (socket == clientSocket1 && clientSocket2 != -1) {
                snprintf(buffer, sizeof(buffer), "Player 1 has disconnected. You win!\n");
                write(clientSocket2, buffer, strlen(buffer));
                close(clientSocket2);
            } else if (socket == clientSocket2 && clientSocket1 != -1) {
                snprintf(buffer, sizeof(buffer), "Player 2 has disconnected. You win!\n");
                write(clientSocket1, buffer, strlen(buffer));
                close(clientSocket1);
            }

            // Reset the corresponding client socket
            if (socket == clientSocket1) {
                clientSocket1 = -1;
            } else if (socket == clientSocket2) {
                clientSocket2 = -1;
            }

            printf("Player %d disconnected\n", playerNumber);
    resetSharedMemory();
        }
int main() {
    
    static int playerCheck;
    int serverSocket;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t addrSize = sizeof(struct sockaddr_in);
    initializeSharedMemory();
    
    // Create a socket
    serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == -1) {
        perror("Error creating socket");
        exit(EXIT_FAILURE);
    }
    
    // Enable address reuse
    int reuse = 1;
    setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));
    
    // Set up the server address
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(PORT);
    
    // Bind the socket
    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) == -1) {
        perror("Error binding socket");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }
    
    // Listen for incoming connections
    if (listen(serverSocket, 2) == -1) {
        perror("Error listening for connections");
        close(serverSocket);
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d...\n", PORT);
    
    while (1) {
        // Accept a client connection
        int clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &addrSize);
        printf("client socket accept %d \n", clientSocket);
        if (clientSocket == -1) {
            perror("Error accepting connection");
            close(serverSocket);
            exit(EXIT_FAILURE);
        }
        int playerNumber = (clientSocket1 == -1) ? 1 : 2;
        // Handle the client in a separate thread or process
        pid_t pid = fork();
        if (pid == 0) {
            // In child process (child handles the client)
            close(serverSocket); // Close the server socket in the child process
            printf("client socket accept %d \n", clientSocket);
            printf("player number %d \n", playerNumber);
            handleClient(clientSocket, playerNumber);
           
            fflush(stdout); // Flush the output stream
            close(clientSocket); // Close the client socket in the child process
            exit(EXIT_SUCCESS); // Exit the child process after handling the client
        } else if (pid > 0) {
            // In parent process (parent continues listening for more clients)
           
           /* printf("playerCheck is now %d", playerCheck);
            if(playerCheck < 2){
                ++playerCheck;
                playerNumber = 1;
                printf("CHECK<2%d", playerCheck);
            }
            else {
                playerCheck++;
                playerNumber = 2;
                printf("CHECK>2 %d", playerCheck);
            } */
            printf("Parent (PID: %d): Player %d connected (Socket: %d)\n", getpid(), playerNumber, clientSocket);
            printf("Player %d connected\n", playerNumber);
            if (playerNumber == 1) {
                clientSocket1 = clientSocket;  // Only assign in the parent process
                playerSockets[0] = clientSocket;
                printf("palyeroscket0 %d\n", playerSockets[0]);
            } else if (playerNumber == 2) {
                clientSocket2 = clientSocket;  // Only assign in the parent process
                playerSockets[1] = clientSocket;
                printf("palyeroscket1 %d\n", playerSockets[1]);
            }
            printf("client socket 1 and client socket 2 %d %d\n", clientSocket1, clientSocket2);
            // Check if both players are connected
            if (clientSocket1 != -1 && clientSocket2 != -1) {
                // Implement logic for starting the game or any other initialization
                printf("Both players connected. Game started!\n");
                
                
            }
            
        } else {
            perror("Error forking");
            close(clientSocket);
            continue;  // Continue the loop on fork error
        }
    }
        // Close the server socket (this line should be outside the while loop)
        close(serverSocket);

        return 0;
    }
