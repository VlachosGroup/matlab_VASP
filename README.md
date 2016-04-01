# matlab_VASP
Repository contains VASP and materials studio related functions in VASP_read_write_library:
* INCAR_Write.m: INCAR vasp input write
* KPOINTS_Write.m: KPOINTS vasp input write
* OSZICAR_READ.m: OSZICAR vasp output read
* OUTCAR_Vib_Freq_Vec_Read.m: OUTCAR vibrational frequency/vector read
* POSCAR_Write.m: POSCAR vasp input write (compatible with CONTCAR)
* POTCAR_Write.m: POTCAR vasp input write
* QSUB_Write.m: batch submission file write for squidward
* VASP_Config_Read.m: POSCAR/XDATCAR vasp output read
* VASP_NEBoutput_to_XTD.m: Read NEB output and write animation file (xtd)
* VASP_vib_read.m: overarching function for convert vibrational freq calculations to materials studio animation file and print frequencies
* VASPoutput_to_XSD_XTD.m: overarching function that converts CONTCAR/POSCAR/XDATCAR to materials studio file
* XSD_Read_grep.m: read materials studio file. use grep function
* XSD_Read_html.m: read materials studio file. use html reading function that MATLAB has. Significantly slower than one using grep, but more reliable for reading other infos that grep does not read as object is outputted.
* XSD_to_VASPinput.m: overarching function that converts xsd to vasp input.
* XSD_Write.m: write XSD material studio file using html function in matlab
* XTD_Write.m: write XTD material studio animiation file using html function in matlab
* XYZ_Read.m: read xyz file.
* XYZ_Write.m: write xyz file.

Scripts in Main folder contains several frequently used function that uses the library scripts:
* XSD_to_VASPinput_opt_vib.m: convert xsd to vasp input including geometric optimizationa and vibrational frequency calculation
* xyz_to_VASP.m: convert xyz file to POSCAR/CONTCAR file
* VASP_to_XSD_XTD.m: convert VASP output (CONTCAR/POSCAR/XDATCAR) to materials studio file (XSD)
* VASP_analyze_vib.m: read vibrational frequency calculation and print frequencies, and visualize vibrations using animation
* switch_hcp_fcc.m: switches fcc/hcp sites for the adsorbate
* remove_energy_from_name.m: VASP_to_XSD_XTD.m function is capable of putting total energy at the end of xsd file name. This script remove those energy at the end of the file name.
* read_Eng.m: reads OSZICARs in the specfied folder and pritn energies. 
* Metal_transumute.m: change element and basis vector of metal bulk cell
* get_name.m: find all xsd files in the specified folder.
* Create_VASP_LC_optimization.m: create lattice constant optimization calculations for VASP
* categorize_JA_list_4_vib.m: creates two separate jobarray job list files for one with under 16 adsorbate atoms that is capable of running under 8 hours limit on farber (so you can use high-throughput standby queue) and over 16 adsorbate atoms to others.

This package take advantage of object, mol_data, that is compatible with python ASE atom objects. Here are the fields and explanations:
* positions: (natoms, 3 coordinate) array that contains positions
* chemical_symbols: (natoms) cell that contains chemical symbols
* unique_elements: lists unique elements
* freeze: (natoms) logical array that specifies whether atom is frozen or not.
* cell: ( 3vector, 3coordinates) array of basis vector
* lattice: string showing how positions are written. 'direct' for fractional coordinate, 'Cartesian' for absolute coordinate
* positions: (image#, natoms, 3 coordinate) array that contains positions for various images. Used for XDATCAR/NEB output reading and vibrational vector visualiation
* connectivity: (natoms, natoms) array of connectivity matrix based on the bonds shown in materials studio xsd file.

The repository includes outside code:
* grep
http://www.mathworks.com/matlabcentral/fileexchange/9647-grep--a-pedestrian--very-fast-grep-utility
* rdir
http://www.mathworks.com/matlabcentral/fileexchange/32226-recursive-directory-listing-enhanced-rdir

TO DO:
  1. create NEB input
  2. Implement error handling
  3. Squidward compatibility 
  4. Update VASP_Config_Read to handle different POSCAR formats

Acknowledgements:
These codes are improved, and built based on the original code written by previous people in the vlachos group:
Dr. Stamatakis, Dr. Salciccioli, Dr. Edie, Dr. Christiansen, Dr. Vorotnikov
