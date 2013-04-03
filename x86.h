
static inline uchar inb(ushort port)
{
 uchar ret;
 asm volatile("in %1,%0" : "=a" (ret) : "d" (port));
 return ret;
}
