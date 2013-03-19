#include "elf.h"
#define SECT_SIZE 512


void bootmain(void)
{
struct elfhdr* hdr;
void (*entry) (void);
struct proghdr* prgsection;

// scratch space. we dont have any thing setup yet..
hdr = (struct elfhdr*)0x10000

}

void waitbusy(void)
{
// wait for disk ready , bit 6 has to be 1
  while((inb(0x1F7) & 0xC0)!=0x40);
}
void readsector(void* dest,uint offset)
{
 waitbusy();
 s 
}
