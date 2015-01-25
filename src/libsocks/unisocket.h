#ifndef UNISOCK
#define UNISOCK

#ifdef _WIN32
#define CLOSE_SOCKET closesocket
#define CLOSE_AND_CLEAN(x) closesocket(x); WSACleanup()
#else
#define CLOSE_SOCKET close
#define CLOSE_AND_CLEAN close
#endif

#ifdef _WIN32
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdint.h>
#define sockaddr_un sockaddr_in
#else
#include <unistd.h>     /* close */
#include <sys/wait.h>   /* wait */
#include <sys/socket.h> /* socket, bind, sendto, recvfrom, getsockname */
#include <sys/un.h>     /* socket domaine AF_UNIX */
#include <netinet/ip.h> /* socket domaine AF_INET */
#include <arpa/inet.h>  /* inet_ntoa */
#include <netdb.h>      /* gethostbyname */
#include <sys/time.h>   /* gettimeofday */
#endif

#endif
