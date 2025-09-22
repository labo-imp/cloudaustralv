/*
 * Compile with:
 *   gcc -Wall memcpu.cpp -o memcpu `pkg-config --libs gio-2.0 --cflags`
 */  

#include <sys/sysinfo.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <cassert>
#include <fcntl.h>
#include <dirent.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <gio/gio.h>
#include <ftw.h>

struct  sysinfo memlibre;

const char * arch_parametros = "parametros.bin";

/*---------------------------------------------------------------------------*/
/*
find $1 -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head

 /home/$USER/.local/share/rstudio   DESESTIMAR  lock_file
 /home/$USER/.local/share/jupyter

/home/$USER/.jupyter   DESESTIMAR  nbsignatures.db


 
 /home/$USER/labo2024ba

/dev/pts     10
/home/$USER/.virtual_documents/  20
/home/$USER/.local/share/rstudio  56
 /home/$USER/.local/share/jupyter  20
 
 /home/$USER/labo2024ba    200

dbus-send --print-reply --dest=org.gnome.Mutter.IdleMonitor /org/gnome/Mutter/IdleMonitor/Core org.gnome.Mutter.IdleMonitor.GetIdletime

 */

/*---------------------------------------------------------------------------*/

#ifndef USE_FDS
#define USE_FDS 15
#endif

time_t  glob_tiempo_limite, glob_tmax;;
int  glob_fullscan;

char  nom_arch_encontrado[1024];
  
  
int eval_entry(const char *filepath, const struct stat *info,
                const int typeflag, struct FTW *pathinfo)
{
    if( glob_fullscan ) {
        if( info->st_atime > glob_tmax &&
            strcmp( filepath, "lock_file" ) != 0 
          )
        {
            glob_tmax = info->st_atime;
            strcpy( nom_arch_encontrado, filepath );
        }
        return 0;
    }


    if( info->st_atime > glob_tiempo_limite &&
        strcmp( filepath, "lock_file" ) != 0 
    )
    {
        // encontre el primero mayor a glob_tiempo_limite
        glob_tmax = info->st_atime;
        strcpy( nom_arch_encontrado, filepath );
        return( -1 );
    } else {
      return(0); // sigo buscando
    }
}
/*---------------------------------------------------------------------------*/

int tree_search(const char *const dirpath, int fullscan, time_t t0)
{
    int result;

    glob_tiempo_limite = t0;
    glob_fullscan = fullscan;
    /* Invalid directory path? */
    if (dirpath == NULL || *dirpath == '\0')
        return errno = EINVAL;

    result = nftw(dirpath, eval_entry, USE_FDS, FTW_PHYS);

    return result;
}
/*---------------------------------------------------------------------------*/

int files_lastactivity(int fullscan, time_t  t0)
{
    char* env_user = getenv("USER");
    static const char * dires[] = { "/dev/pts", "/mnt", ".virtual_documents", ".local/share/rstudio",
      ".local/share/jupyter", ".vscode", ".vscode-R", ".config/Code", "datasets", "buckets/b1/exp",
      "dmeyf2025" };

    int tope = sizeof(dires)/sizeof(char*);

    glob_tmax = 0; // El inicio de los tiempos
    int i = 0;
    int noencontre = 1;
    int res = 0;
    while( i < tope  &&  noencontre )
    {
      char undiro[1024];
      if( dires[i][0] != '/' ) {
        sprintf( undiro, "/home/%s/%s", env_user, dires[i] );
      } else {
        sprintf( undiro, "%s", dires[i] );
      }

      printf( "dir %s\n", undiro );
      res = tree_search( undiro, fullscan, t0 );
      if( res < 0 )  noencontre = 0;

      i++;
    }

    return glob_tmax;
}
/*---------------------------------------------------------------------------*/

void crear_archivo( const char *nom_arch, off_t tamano)
{
    printf( "crear_archivo()\n" );

    int arch = open(nom_arch,
                    O_RDWR | O_CREAT | O_EXCL,
                    S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
    assert ( arch != -1);
    int res = ftruncate( arch, tamano );
    assert ( res != -1 );

    close( arch );
}

/*---------------------------------------------------------------------------*/

void *mmap_archivo( const char *nom_arch )
{
     printf( "mmap_archivo(()\n" );

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

time_t gnome_lastactivity (GDBusProxy *proxy_session)
{
    time_t t0;
    time( &t0 );

    guint64 user_idle_time;
    const gchar *method = "GetIdletime";
    GError *error_session = NULL;
    GVariant *ret_session = NULL;

    if( proxy_session != NULL )
    {
      ret_session = g_dbus_proxy_call_sync(proxy_session,
                                    method,
                                    NULL,
                                    G_DBUS_CALL_FLAGS_NONE, -1,
                                    NULL, &error_session);
    }

    if( error_session != NULL )
    {
        g_dbus_error_strip_remote_error (error_session);
        g_print ("GetIdletime session failed: %s\n", error_session->message);
        g_error_free (error_session);
        printf("hubo_error_session\n" );
        return( (time_t) 0 );
    }

    g_variant_get (ret_session, "(t)", &user_idle_time);
    g_print("%lu\n", user_idle_time);
    g_variant_unref (ret_session);

    return( t0 - user_idle_time/((time_t) 1000 ) );
} 
/*---------------------------------------------------------------------------*/

int  mostrar( FILE * arch, int lote, int  tiempo_inicial, int rampct, int cpu, int ramtotal )
{
  time_t t0;
  struct tm *localt0;

  time( &t0 );

  int  segundos = (int)(t0 - tiempo_inicial) ;

  localt0 = localtime(&t0);

  fprintf( arch, "%d\t%04d%02d%02d %02d%02d%02d\t%d\t%d\t%d\t%d\n",
                 lote,
                 localt0->tm_year+1900, localt0->tm_mon+1, localt0->tm_mday,
                 localt0->tm_hour, localt0->tm_min,localt0->tm_sec, 
                 segundos,
                 rampct, cpu, ramtotal ) ;

  return(0) ;
}
/*---------------------------------------------------------------------------*/

double  cpu_utilization()
{
    FILE* file2 = fopen("/proc/stat", "r");
     
    static unsigned int lastTotalUser0, lastTotalUserLow0, lastTotalSys0, lastTotalIdle0;
    double percent;

    unsigned long long totalUser, totalUserLow, totalSys, totalIdle, total;

    fscanf(file2, "cpu %llu %llu %llu %llu", &totalUser, &totalUserLow, &totalSys, &totalIdle);
    fclose(file2);

    if (totalUser < lastTotalUser0 || totalUserLow < lastTotalUserLow0 ||
        totalSys < lastTotalSys0 || totalIdle < lastTotalIdle0)
    {
        //Overflow detection. Just skip this value.
        percent = -1.0;
    }else{
        total = (totalUser - lastTotalUser0) + (totalUserLow - lastTotalUserLow0) + (totalSys - lastTotalSys0);
        percent = total * 100;
        total += (totalIdle - lastTotalIdle0);
        percent /= total;
    }

    lastTotalUser0    = totalUser;
    lastTotalUserLow0 = totalUserLow;
    lastTotalSys0     = totalSys;
    lastTotalIdle0    = totalIdle;

    return( percent );
}
/*---------------------------------------------------------------------------*/

int init_log( char * nomarch, FILE * * parch_log, int * plote )
{
  int  primera_vez = 1 ;
  int  vlote= 0 ;
  
  FILE * arch = fopen( nomarch, "r" ) ;
  if( arch!=NULL )
  {
    primera_vez = 0 ;
    const long max_len = 40 ;
    char buf[max_len + 1] ;
    int res = fseek(arch, -max_len, SEEK_END) ;
    printf( "res = %d\n", res ) ;
    if( res!=-1 )
    {
      int leidos = fread(buf, 1, max_len,  arch) ;
      buf[leidos-1] = '\0';  //el ultimo caracter del archivo es un newline
      char *last_newline = strrchr(buf, '\n');
      char *last_line = last_newline+1;
      sscanf( last_line, "%d\t", &vlote ) ;
      fclose( arch ) ;
    }
  }

  arch = fopen( nomarch, "at" ) ;
  if( arch==NULL )  printf( "archivo nulo\n" ) ;

  if( primera_vez )
  {
    fprintf( arch, "lote\ttime\tsecs\tmem\tCPU\tGB\n" ) ;
  }

  *parch_log = arch ;
  *plote = vlote+1 ;
  return(0);
}
/*---------------------------------------------------------------------------*/

struct tultimos
{
    time_t  cpu_high;
    time_t  gnome;
    time_t  files;
};
typedef struct tultimos tultimos;

/*---------------------------------------------------------------------------*/

int actualizar_compartido( double * param, tultimos u, char * nom_arch_encontrado)
{
    param[ 10 ] = (double)  u.cpu_high;
    param[ 11 ] = (double)  u.gnome;
    param[ 12 ] = (double)  u.files;

    strcpy(  (char*) &(param[20]), nom_arch_encontrado );

    printf( "%f\t", param[0] );
    printf( "%f\t", param[1] );
    printf( "%f\t", param[2] );

    time_t  t0;
    time( &t0 );

    printf( "%f\t", (double) t0 - param[10] );
    printf( "%f\t", (double) t0 - param[11] );
    printf( "%f\t", (double) t0 - param[12] );

    printf( "%s\n", (char*)  &(param[20]) );

   return(0);
}
/*---------------------------------------------------------------------------*/

int main(int argc, char *argv[])
{
  //signal(SIGINT,sig_handler); // Register signal handler

  FILE *  arch_log ;
  double * parametros;
  tultimos  ultimos;
  int lote ;

  setuid( atoi( argv[1] )  ); // El primer usuario instalado 
  time_t  tiempo_inicial;
  time( &tiempo_inicial );

  char nomarch[128] ;
  sprintf( nomarch, "z-SHmemcpu.txt" ) ;

  init_log( nomarch, &arch_log, &lote ) ;

  sysinfo( &memlibre ) ;
  int mem0 = 100-100*memlibre.freeram/memlibre.totalram ;
  int tlastshown = 0, mlastshown=0, t=0 ;

  GDBusProxy *proxy_session = NULL;
  const gchar *name = "org.gnome.Mutter.IdleMonitor";
  const gchar *object_path = "/org/gnome/Mutter/IdleMonitor/Core";
  const gchar *interface_name = "org.gnome.Mutter.IdleMonitor";

  // creo archivo con parametros
  if (-1 == open(arch_parametros,
                  O_RDONLY) ) {

    printf( "Adentro\n");
    crear_archivo( arch_parametros, sizeof(double)*512);
    parametros = reinterpret_cast<double*> (mmap_archivo( arch_parametros ));
    for( int i=0; i<512; i++)  parametros[i] = 0.0;

    parametros[0] = 30.0*60.0; // 30 minutos de timeout
    parametros[1] = 15.0*60.0; // 15 minutos de timeout en CPU
    parametros[2] = 10.0; // 10% uso de CPU
  }  else {
    parametros = reinterpret_cast<double*> (mmap_archivo( arch_parametros ));
  }


  proxy_session = g_dbus_proxy_new_for_bus_sync (G_BUS_TYPE_SESSION,
      G_DBUS_PROXY_FLAGS_NONE,
      NULL,
      name,
      object_path,
      interface_name,
      NULL, NULL);

  // g_assert (proxy_session != NULL);


  // Inicilizo la estructura  ultimos
  time( &ultimos.cpu_high );
  ultimos.gnome = gnome_lastactivity( proxy_session );
  ultimos.files = files_lastactivity( 1, 0 );  // 1 = hago full scan
  printf( "full scan hecho\n");
  nom_arch_encontrado[0]='\0';
  actualizar_compartido( parametros, ultimos, nom_arch_encontrado);

  while( 1 )
  {
    sysinfo( &memlibre ) ;
    int mem1 = 100 - 100*memlibre.freeram/memlibre.totalram ;
    double uso_cpu = cpu_utilization();
    time_t  ahora;
    time( &ahora );
    if( uso_cpu > parametros[2] )  ultimos.cpu_high = ahora;

    if( abs(mem1 - mem0) > 3  || ( mem0 != mem1 && ( mem0>90 || mem1>90 ) )  
        ||  t-tlastshown > 30 || abs( mem1 - mlastshown) > 10 || t==0 )
    {
      if( t-tlastshown > 60*5 ) {
        mostrar( arch_log,
                 lote,
                 tiempo_inicial,
                 mem1,
                 (int) uso_cpu,
                 memlibre.totalram/(1024*1024)  ) ;
     }

     if( t-tlastshown > 60*5 || abs( mem1 - mlastshown) > 5  )  fflush( arch_log );

      tlastshown = t ;
      mlastshown = mem1 ;

    } 

    /* Se cumple la condicion de baja CPU */
    if( (ahora - ultimos.cpu_high) > parametros[1] ) 
    {
       if( (ahora - ultimos.gnome) > parametros[0]  &&
           (ahora - ultimos.files) > parametros[0] 
         )
       {

          ultimos.gnome = gnome_lastactivity( proxy_session );

          if( (ahora - ultimos.gnome) > parametros[0] )
          {
               printf( "Antes  files_lastactivity( 0, ahora - parametros[1] ) \n" );
               ultimos.files = files_lastactivity( 0, ahora - parametros[1] );
               printf( "Despues  files_lastactivity( 0, ahora - parametros[1] ) \n" );
               if( (ahora - ultimos.files) > parametros[0]  )
               {
                   // Apago la virtual machine
                   printf( "apagar_vm.sh\n" );
                   char* env_user = getenv("USER");
                   char st_apagar[1024];
                   
                   sprintf( st_apagar, "/home/%s/cloud-install/direct/apagar_vm.sh", env_user );

                   system(st_apagar);
                   return(0);
               }
          }
       }
    }

    if( t % 60 == 0  ||  parametros[9] == 1.0 ) {
      ultimos.gnome = gnome_lastactivity( proxy_session );
      ultimos.files = files_lastactivity( 1, 0 );  // 1 = hago full scan
      parametros[9] = 0.0;
    }
    actualizar_compartido( parametros, ultimos, nom_arch_encontrado);

    mem0 = mem1 ;
    sleep(5) ;
    t+= 5 ;
  
  }

  g_object_unref (proxy_session);

  return(0) ;
}
