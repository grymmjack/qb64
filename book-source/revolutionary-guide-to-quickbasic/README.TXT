The Revolutionary Guide to QBasic Disk Information File

Contents

1. Installation
2. Using these files
3. Disk Contents
4. Format of QBasic programs
5. Problems

1. INSTALLATION

This disk contains a self-extracting archive, which installs all the programs you need to use this book and more, without any technical knowledge. The program will automatically install the files into the following directory structure:

Your_directory/REVQB/CHAP1
                          /REVQB/CHAP2
                          /REVQB/CHAP3
                          /REVQB/CHAP4
                          /REVQB/CHAP5
                          /REVQB/CHAP6
                          /REVQB/CHAP7
                          /REVQB/CHAP8
                          /REVQB/CHAP9
                          /REVQB/CHAP10
                          /REVQB/CHAP11
                          /REVQB/CHAP12
                          /REVQB/CHAP13
                          /REVQB/CHAP14
                          /REFERENCE/AMUSE
                          /REFERENCE/APPS
                          /REFERENCE/GAMES
                          /REFERENCE/GRAPHICS
                          /REFERENCE/ROUTINES
                          /REFERENCE/TOOLS

By entering the directory 'Your_directory', where you wish to install the above structure, you must execute the self-extracting file on the floppy by typing:

     A:SETUP.EXE

After a few minutes of activity, the extraction should complete without any problems, and you will have everything installed in the correct place.

2. USING THESE FILES

By running QBasic and selecting the OPEN option on the FILE menu, you can run any of the files you've just installed by finding the directory in which you've just installed the programs. If you encounter any problems, refer to 5. PROBLEMS.

3. DISK CONTENTS

The full run-down of included files can be found be reading the Appendix B which can be found in the back of the book. Alternatively, you can run the DOS command, TREE on the directory to which you installed this disk.

4. FORMAT OF QBASIC PROGRAMS

A lot of the programs found on this disk, were designed to be backwardly compatible with previous versions of BASIC, such as GW-BASIC and BasicA. This is the main reason why some of the programs do not use the concept of modules, and still include line numbers. They are in no way inferior, and are in fact superior to pure-QBasic programs, because they are backwardly compatible.

5. PROBLEMS

Some of the programs, when run, give the error 'File Not Found'.

     This is a problem of paths in DOS, and is not a program error. You can remedy this problem by doing 
     one of the following:

          Run QBasic from that programs directory.
          Change all the references to other files, such as OPEN or CHAIN statements, to include the full path 
          and filename of the file the program is looking for.
          Insert a variable (or check if there isn't already one in use) to automatically set the drive and 
          pathname at the start of the program.

     One of these solutions (if not all) will work.

If the problems persist, and you require further assistance, contact Wrox Press, and ask for Adrian M. Sill or Graham J. Butler.
