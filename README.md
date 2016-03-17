# matlab_VASP
Matlab scripts for read/write VASP output/input as well as read/write material studio XSD/XTD file.
The main function include:
* INCAR vasp input write
* KPOINTS vasp input write
* POSCAR vasp input write
* POTCAR vasp input write
* POSCAR/XDATCAR vasp output read (VASP_Config_Read)
* OSZICAR vasp output read
* OUTCAR vibrational frequency read
* XSD material studio file read
* XSD material studio file write
* XTD material studio animation file write

The repository also include outside code:
* grep
http://www.mathworks.com/matlabcentral/fileexchange/9647-grep--a-pedestrian--very-fast-grep-utility
* rdir
http://www.mathworks.com/matlabcentral/fileexchange/32226-recursive-directory-listing-enhanced-rdir

TO DO:
  1. create NEB input
  2. read vibrational frequency vector.
  3. create vibration animation

Acknowledgements:
These codes are improved, and built based on the original code written by previous people in the vlachos group:
Dr. Stamatakis, Dr. Salciccioli, Dr. Edie, Dr. Christiansen, Dr. Vorotnikov
