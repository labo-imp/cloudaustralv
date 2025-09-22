#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <cassert>
#include <fcntl.h>
#include <dirent.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


const char * arch_parametros = "parametros.bin";


/*---------------------------------------------------------------------------*/

void *mmap_archivo( const char *nom_arch )
{
    int arch = open(nom_arch,
                    O_RDWR,
                    S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);

    if( arch==-1 ) printf( "Cannot find file %s\n", nom_arch);
    assert ( arch != -1);
    /* Get information about the file, including size */
    struct stat arch_info;
    assert (fstat (arch, &arch_info) != -1);

    void *mmap_addr = mmap (NULL,
        arch_info.st_size,
        PROT_READ | PROT_WRITE,
        MAP_SHARED |MAP_NORESERVE,
        arch,
        0);

    assert (mmap_addr != MAP_FAILED);
    madvise( mmap_addr, arch_info.st_size, MADV_SEQUENTIAL );
    close( arch );

    return mmap_addr;
}
/*---------------------------------------------------------------------------*/

int main(int argc, char *argv[])
{
    double * parametros = reinterpret_cast<double*> (mmap_archivo( arch_parametros ));
    double  terminal_time = 15.0 * 60.0;
    double  cpu_time = 5.0 * 60.0;
    double  cpu_pct = 10.0;

    printf( "argc = %d\n", argc);

    if (argc >=2 ) parametros[0] = atof(argv[1])*60.0;
    if (argc >=3 ) parametros[1] = atof(argv[2])*60.0;
    if (argc >=4 ) parametros[2] = atof(argv[3]);

    parametros[9] = 1.0;

    printf( "%f\t", parametros[0] );
    printf( "%f\t", parametros[1] );
    printf( "%f\t", parametros[2] );

    time_t  t0;
    time( &t0 );

    printf( "%f\t", (double) t0 - parametros[10] );
    printf( "%f\t", (double) t0 - parametros[11] );
    printf( "%f\t", (double) t0 - parametros[12] );

    printf( "%s\n", (char*)  &(parametros[20]) );

  return(0);
}
/*---------------------------------------------------------------------------*/
