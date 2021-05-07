README
                  March 2021
+ ---------------------------- +
  How to run:
+ ---------------------------- +

!!! FY/ directory contains all data resulted by running perl script. !!!
!!! Just merging (or copying) files is enough.                       !!!
!!! If you need to re-create the files, please follow the procedure. !!!

1. Download Fission Yield Sublibrary from the web site and extract them into download/ folder.
   - https://www.nndc.bnl.gov/endf/b8.0/zips/ENDF-B-VIII.0_nfy.zip
   - https://www.nndc.bnl.gov/endf/b8.0/zips/ENDF-B-VIII.0_sfy.zip
   - https://wwwndc.jaea.go.jp/ftpnd/ftp/JENDL/jendl40-or-up-fy_20120914.tar.gz
   - https://www.oecd-nea.org/dbdata/jeff/jeff33/downloads/JEFF33-nfy.asc
   - https://www.oecd-nea.org/dbdata/jeff/jeff33/downloads/JEFF33-sfy.asc
   Note that JEFF3.3 only provides two files that contain all fissiles, so they are splitted into each fissiles in the run.pl.

2. Install DeCE
    - Download source from https://github.com/toshihikokawano/DeCE
    - make
    - make install
    - the perl script (run.pl) used in the next step requires `dece' as a command.

3. Change $topdir in run.pl (line:17) suitable for your environment.

4. Run 'perl run.pl'.

5. please delete 0, -1 files... sorry, I'm lazy.



+ ---------------------------- +
   File description:
+ ---------------------------- +
 0/: Spontanious fission
 n/: Neutron induced fission
 
 For example,
 
 n/Am241/endfb8.0/files/n-Am241.endfb8.0: original ENDF-6 format file
 
 n/Am241/endfb8.0/tables/FY/
    n-Am241-MT454.endfb8.0:  Independent fission product yield (all energy included)
    n-Am241-MT459.endfb8.0:  Cumulative fission product yield (all energy included)
    
    n-Am241-MT454.F.endfb8.0: Independent fission product yield at fast (see detail for energy flag) energy
    n-Am241-MT454.H.endfb8.0: Independent fission product yield at high energy (14 MeV)
    
        energy flag:
            T: thermal, 0.0253 eV for ENDF and JENDL, 0.00 eV for JEFF
            F: fast, 500 keV for ENDF and JENDL, 400 keV for JEFF
            FH: 2 MeV for ENDF Pu239 only
            H: high energy, 14 MeV for all libraries
            
        !!!! Changed into energy expression!!!
            E000.000: spontaneous fission
            E2.53E-08: thermal, 0.0253 eV for ENDF and JENDL, 0.00 eV for JEFF
            E000.500 or E000.400: fast, 500 keV for ENDF and JENDL, 400 keV for JEFF
            E002.000: 2 MeV for ENDF Pu239 only
            E014.000: 14 MeV for all libraries  

 n/Am241/endfb8.0/tables/info/
    n-Am241-MF01-MT451.endfb8.0: ENDF-6 header



