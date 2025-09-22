#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>           /* For O_* constants */
#include <sys/stat.h> 
#include <pthread.h> 
#include <semaphore.h>
#include <unistd.h>

int main( int argc, char* argv[] )
{
  sem_t *  vsem ;

  printf( "%s", argv[1] );

  if( 0==strcmp( argv[1], "unlink")  )
  {  
    int  res = sem_unlink( argv[2] ) ;
    return( res) ;
  }


  if( 0==strcmp( argv[1], "open")  )
  {
     printf( "%s\n", argv[2] );
     int valor_inicial = atoi( argv[3] ) ;
     vsem = sem_open(  argv[2],  O_CREAT, S_IWOTH | S_IROTH | S_IWUSR | S_IRUSR ,  valor_inicial ) ;
     if( vsem==NULL )  
     {
        printf( "ERROR, no se creo el semaforo\n" ) ;
        perror("sem_open") ;
    }

  }  else  
  {
     printf( "%s\n", argv[2] );
     vsem = sem_open(  argv[2],  0  ) ;
     if( vsem==NULL )
     { 
        printf( "ERROR, no se abrio el semaforo\n" ) ;
        perror("sem_open") ;
     }
  }

  if( 0==strcmp( argv[1], "unlink")  )
  {  
    int  res = sem_unlink( argv[2] ) ;
    return( res) ;
  }

  if( 0==strcmp( argv[1], "wait")  )
  {  
    printf( "waiting" ) ;
    int  res = sem_wait( vsem ) ;
    return( res) ;
  }

  if( 0==strcmp( argv[1], "post")  )
  {  
    int  res = sem_post( vsem ) ;
    return( res) ;
  }

  if (0 == strcmp(argv[1], "getvalue"))
  {
      int status;
      int  res = sem_getvalue(vsem, &status);
      printf("Status  %s\t%d\n", argv[2], status);
      return(res);
  }

  return(0) ;
}