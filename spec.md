Instructions

Overdrive Machine

Certain operations generate heat.
Avoid overheating machine.

Supports integer and floating point operations.

All integer operations can be performed on floating point numbers, but the cost is (opcost x 4 + 1)

Floating point numbers are https://en.wikipedia.org/wiki/Half-precision_floating-point_format
Integers are 16 bit signed integers (-32,768 - 32,767)

Heat dissipates at the rate of 1 point per cycle, before the start of the next cycle.
Certain instructions dissipate heat. Use with caution.

Memory locations:

Name      | Read Cost | Write Cost | Size
CACA      |    0      |      0     |  16 bits
CACB      |    0      |      1     |  16 bits
MEA[0-1]  |    10     |      20    |  16 bits
MEB[0-1]  |    10     |      40    |  16 bits
BOOL      |    1      |       0    |  1 bit

Special Storage (limitations may apply)

DS[00-99] |    40     |      30    | 4 bytes
CLD[0-9]  |    40     |      40    | 8 bytes

Language: 4LW - Four Letter Word

Heat 0:
LOC is one of CACA, CACB, MEA[0-1], MEAB[0-1]
plus [amount] [loc] # adds amount to loc
minu [amount] [loc] # subtracts amount from loc
comb [loc1] [loc2] # add loc1 to loc2, store in loc2
copy [loc1] [loc2] # copy loc1 into loc2, erasing the contents of loc2
modu [num] [loc]  # returns loc % num
trsh # scrambles CACA, CACB, MEA, and MEB, removes 30 heat.

Heat 40:
m2ds [mea or meb] [ds] # flush memory to disk storage
ds2m [ds] [mea or meb] # flush disk storage to memory
fech [cloud storage] [disk storage] # pull data from cloud to disk, will fill selected DS + the 1 next storage blocks. Overflows will be lost.

