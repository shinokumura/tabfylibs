README
                  March 2021   first commit
                  March 2022   add decayfinite format

+ ---------------------------- +
## Download
+ ---------------------------- +
You can download the repository by following command from the terminal:

```
git clone https://github.com/shinokumura/tabfylibs.git
```


+ ---------------------------- +
## How to run:
+ ---------------------------- +

FY/ directory contains all data resulted by running perl script (run.pl).              
If you need to rerun the script localy, please follow following procedures.

1. Download Fission Yield Sublibrary from the web site and extract them into download/ folder.
   ENDF
   - https://www.nndc.bnl.gov/endf/b8.0/zips/ENDF-B-VIII.0_nfy.zip
   - https://www.nndc.bnl.gov/endf/b8.0/zips/ENDF-B-VIII.0_sfy.zip
   JENDL
   - https://wwwndc.jaea.go.jp/ftpnd/ftp/JENDL/jendl40-or-up-fy_20120914.tar.gz
   - https://wwwndc.jaea.go.jp/ftpnd/ftp/JENDL/jendl5-fpy_upd2.tar.gz
   JEFF
   - https://www.oecd-nea.org/dbdata/jeff/jeff33/downloads/JEFF33-nfy.asc
   - https://www.oecd-nea.org/dbdata/jeff/jeff33/downloads/JEFF33-sfy.asc
   Note that JEFF3.3 only provides two files that contain all FPYs (both independent and cumulative) from all fissiles, so they are splitted into each fissiles while running run.pl.

2. Install DeCE
    - Download source from https://github.com/toshihikokawano/DeCE
    - make
    - make install
    -- the perl script (run.pl) used in the next step requires `dece` as a command.

3. Change $topdir in run.pl (line:17) suitable for your environment.

4. Run 
```
perl run.pl
```

5. please delete 0, -1 files... sorry, I'm lazy.



+ ---------------------------- +
## File description for dataexplorer (https://nds.iaea.org/dataexplorer/fy):
+ ---------------------------- +
 FY/0/: Spontanious fission for data exploere https://nds.iaea.org/dataexplorer/fy
 FY/n/: Neutron induced fission for data exploere https://nds.iaea.org/dataexplorer/fy

 For example,
  FY/n/Am241/endfb8.0/tables/info/
    n-Am241-MF01-MT451.endfb8.0: ENDF-6 header

  FY/n/Am241/endfb8.0/files/n-Am241.endfb8.0: original ENDF-6 format file

  FY/n/Am241/endfb8.0/tables/FY/
    n-Am241-MT454-E2.53E-08.endfb8.0:  Independent fission product yields from thermal neutron induced fission
    n-Am241-MT459-E2.53E-08.endfb8.0:  Cumulative fission product yields from thermal neutron induced fission

           
        Energy flags in the file name:
            E000.000: spontaneous fission
            E2.53E-08: thermal, 0.0253 eV for ENDF and JENDL, 0.00 eV for JEFF
            E000.500 or E000.400: fast, 500 keV for ENDF and JENDL, 400 keV for JEFF
            E002.000: 2 MeV for ENDF Pu239 only
            E014.000: 14 MeV for all libraries  

+ ---------------------------- +
## File description for decayfinite
+ ---------------------------- +

 FY/decayfinite/: decayfinite format files

 FY/decayfinite/U235/jendl4.0/
    n-U235-MT454-E2.53E-08.jendl4.0:  Independent fission product yields from thermal neutron induced fission




