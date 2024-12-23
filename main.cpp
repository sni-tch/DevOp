#include <iostream>
#include <sys/wait.h>
#include "Class_H.h"

int CreateHTTPserver();

void singChldHandler(int s) 
{
 printf("Caught signal SIGCHILD\n");

 pid_t pid;
 int status;

 while ((pid = waitpid(-1, &status,WNOHANG))>0)
 {
  if (WIFEXITED(status)) printf("\nChild process terminated");
 }
}

void singInthandler(int s) 
{
 printf("Caught signal %d. Starting graceful exit procedure\n",s);

 pid_t pid;
 int status;
 while ((pid = waitpid(-1,&status,0))>0)
 {
  if(WIFEXITED(status)) printf("\nChild process terminated");

 }

 if (pid==-1) printf("\nAll child processes terminated");

 exit(EXIT_SUCCESS);
}

int main(int argc, char* argv[]) {

    signal(SIGCHLD, singChldHandler);
    signal(SIGINT, singInthandler);

    MyClass obj;
    double result = obj.FuncA();  // Call the FuncA function
    std::cout << "The result of FuncA is: " << result << std::endl;  // Output the result


    CreateHTTPserver();
    return 0;
}
