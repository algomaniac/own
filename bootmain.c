#include "types.h"
#include "elf.h"
#include "x86.h"


#define SECT_SIZE 512

void bootmain(void)
{
 struct elfhdr* hdr;
 void (*entry) (void);
 struct proghdr* prgsection;
 // scratch space. we dont have any thing setup yet..
 hdr = (struct elfhdr*)0x10000; 
 
 if( hdr->magic != ELF_MAGIC) {
   return;	// we expect the kernel.img to be an ELF
 }
 

}

void waitbusy(void)
{
  //wait for disk ready , bit 6 has to be 1
  while((inb(0x1F7) & 0xC0)!=0x40);
}

void readsector(void* dest,uint offset)
{
// using 28 bit PIO addressing
 waitbusy();
 outb(0x1F2,1); 	//  sector count
 outb(0x1F3,offset); 	//  Low 8 bits of LBA
 outb(0x1F4,offset>>8); //  next 8 bits of LBA
 outb(0x1F5,offset>>16); // next 8 bits of LBA
 //High 4 bits | 0xE for master
 //High 4 bits | 0xF0 for master 	 
 outb(0x1F6,0xE0|(offset>>24));
 //outb(0x1F6,0xE0| (slave<<4) | ((offset>>24)&0x0F));
 waitbusy();  
}
