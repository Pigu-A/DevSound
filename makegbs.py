# makegbs.py - create GBS file from DevSound.gbs.tmp

# open files
ROMFile = open("DevSound.gbs.tmp", "rb")     # temp
OutFile = open("DevSound.gbs", "wb")    # output file

# find end of data
endpos = ROMFile.seek(-1,2)
while endpos >= 0x400:
    if ROMFile.read(1)[0] != 0xff: break;
    ROMFile.seek(-2,1)
    endpos -= 1

# copy song data
ROMFile.seek(0x390)
OutFile.write(ROMFile.read(endpos - 0x390))       # write song data

# close files
ROMFile.close()
OutFile.close()
