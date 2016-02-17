%% Write Squidward Submit file
function QSUB_Write(outfldr, input)   
newline = char(10);
slash_index = regexp(outfldr,'\');
name = outfldr(slash_index(end-1)+1:end-1);
fidout = fopen([outfldr 'VASPjob.qs'],'w');
fprintf(fidout,['#!/bin/bash' newline]);
fprintf(fidout,['#$ -cwd' newline]);
fprintf(fidout,['#$ -N ' name newline]);
fprintf(fidout,['#$ -pe openmpi-smp ' num2str(input.ncores) newline]);
fprintf(fidout,['#$ -q *@@3rd_gen' newline]);
fprintf(fidout,['#$ -j y' newline]);
fprintf(fidout,['#$ -S /bin/bash' newline]);
fprintf(fidout,['#' newline]);
fprintf(fidout,['# Get our environment setup:' newline]);
fprintf(fidout,['#' newline]);
fprintf(fidout,['source /etc/profile.d/valet.sh' newline]);
if isequal(input.kpoints,[1 1 1])
    fprintf(fidout,['vpkg_require "vasp/5.3.2+vtst+d3+gamma-pgi10"' newline]);
else
    fprintf(fidout,['vpkg_require "vasp/5.3.2+vtst+d3-pgi10"' newline]);
end
fprintf(fidout,['#' newline]);
fprintf(fidout,['## You should NOT need to modify anything after this comment!!' newline]);
fprintf(fidout,['#\n' newline]);
fprintf(fidout,['# Begin the run by printing some basic info and then' newline]);
fprintf(fidout,['# invoke mpiexec:' newline]);
fprintf(fidout,['echo "GridEngine parameters:"	' newline]);
fprintf(fidout,['echo "  nhosts         = $NHOSTS" ' newline]);
fprintf(fidout,['echo "  nproc          = $NSLOTS" ' newline]);
fprintf(fidout,['echo "  mpiexec        =" `which mpiexec` ' newline]);
fprintf(fidout,['echo "  pe_hostfile    = $PE_HOSTFILE" ' newline]);
fprintf(fidout,['echo "  vasp           =" `which vasp`	' newline]);
fprintf(fidout,['echo ' newline]);
fprintf(fidout,['cat $PE_HOSTFILE ' newline]);
fprintf(fidout,['echo ' newline]);
fprintf(fidout,['echo "-- begin OPENMPI run --"' newline]);
fprintf(fidout,['time mpiexec --n $NSLOTS --host localhost --mca btl sm,self --display-map vasp' newline]);
fprintf(fidout,['echo "-- end OPENMPI run --"' newline]);
fclose(fidout);

% elseif cluster == 2 %Kraken
%     fidout = fopen([basedir fldrname '\VASPjob'],'w');
%     
%     fprintf(fidout,['#!/bin/bash' newlinechar]);
%     fprintf(fidout,['#PBS -N ' fldrname newlinechar]);
%     fprintf(fidout,['#PBS -A TG-CTS080045N ' newlinechar]);
%     fprintf(fidout,['#PBS -l size=' NumCores ',walltime=24:00:00 ' newlinechar]);
%     fprintf(fidout,['#PBS -m e' newlinechar]);
%     fprintf(fidout,['#PBS -M ggu@udel.edu' newlinechar]);
%     fprintf(fidout,['#PBS -S /bin/bash' newlinechar newlinechar]);
%     fprintf(fidout,['cd /lustre/scratch/ggu1/Input/Hdg/' fldrname '/' newlinechar newlinechar]);
%     
% %     fprintf(fidout,['export MPICH_PTL_OTHER_EVENTS=50000' newlinechar]);
% %     fprintf(fidout,['export MPICH_PTL_UNEX_EVENTS=200000' newlinechar]);
% %     fprintf(fidout,['export MPICH_PTL_MATCH_OFF=1' newlinechar]);
% %     fprintf(fidout,['export MPICH_UNEX_BUFFER_SIZE=1000000000' newlinechar newlinechar]);
%     
%     if gc == 1
%     fprintf(fidout,['aprun -n ' NumCores ' /lustre/scratch/ggu1/vasp.5.3.2+vtst+D3+gamma' newlinechar]);
%     else
%     fprintf(fidout,['aprun -n ' NumCores ' /lustre/scratch/ggu1/vasp.5.3.2+vtst+D3' newlinechar]);
%     end
% 
%     fclose(fidout);
% 
% return
% elseif cluster == 3 %Stampede
%     nnodes = str2double(NumCores)/16;
%     nnodes = num2str(nnodes);
%     fidout = fopen([basedir fldrname '\VASPjob'],'w');
% 
%     fprintf(fidout,['#!/bin/bash' newlinechar newlinechar]);
%     fprintf(fidout,['#SBATCH -J ' fldrname '                      # Job Name' newlinechar]);
%     fprintf(fidout,['#SBATCH -o vasp.out.%%j              # Name of stdout output file (%%j expands to jobId)' newlinechar]);
%     fprintf(fidout,['#SBATCH -p normal                   # Queue name' newlinechar]);
%     fprintf(fidout,['#SBATCH -N ' nnodes '                       # Total number of nodes requested (16 cores/node) ' newlinechar]);
%     fprintf(fidout,['#SBATCH -n ' NumCores '                      # Total number of mpi tasks requested' newlinechar]);
%     fprintf(fidout,['#SBATCH -t 24:00:00                 # Run time (hh:mm:ss)' newlinechar]);
%     fprintf(fidout,['#SBATCH --mail-user=ggu@udel.edu  # email user' newlinechar]);
%     fprintf(fidout,['#SBATCH --mail-type=end             # type of email to send' newlinechar newlinechar]);
%     fprintf(fidout,['#SBATCH -A TG-CTS080045N            # <-- Allocation name to charge job against' newlinechar newlinechar]);
%     fprintf(fidout,['# Launch the MPI executable' newlinechar newlinechar]);
%     fprintf(fidout,['ibrun /home1/02675/ggu/vasp' newlinechar newlinechar]);
% 
%     fclose(fidout);
% 
% return
% elseif cluster == 4 %Nersc
%     nnodes = str2double(NumCores)/8;
%     nnodes = num2str(nnodes);
%     fidout = fopen([basedir fldrname '\VASPjob'],'w');
% 
%     fprintf(fidout,['#PBS -l pvmem=5GB' newlinechar]);
%     fprintf(fidout,['#PBS -q regular' newlinechar]);
%     fprintf(fidout,['#PBS -l nodes=' nnodes ':ppn=8' newlinechar]);
%     fprintf(fidout,['#PBS -l walltime=24:00:00' newlinechar]);
%     fprintf(fidout,['#PBS -N ' fldrname newlinechar]);
%     fprintf(fidout,['#PBS -j oe' newlinechar]);
%     fprintf(fidout,['#PBS -m ea' newlinechar]);
%     fprintf(fidout,['#PBS -M ggu@udel.edu' newlinechar newlinechar]);
%     fprintf(fidout,['cd $PBS_O_WORKDIR' newlinechar newlinechar]);
%     fprintf(fidout,['module swap pgi intel' newlinechar]);
%     fprintf(fidout,['module swap openmpi openmpi-intel' newlinechar]);
%     fprintf(fidout,['mpirun -np ' NumCores ' /global/u2/g/ggu/VASP/vasp.5.3/vasp' newlinechar]);
% 
%     fclose(fidout);
% 
% return
end