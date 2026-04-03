
# Orca and Coeus OpenXDMoD data collection and load.

See the Orca config wiki for details.
https://github.com/orca-accelerator/orca-config/wiki/XDMoD

# Directories

* /cluster/xdmod on each cluster head node
* /orcacluster/xdmod and /coeuscluster/xdmod on xdmod.rc.pdx.edu

# Files
File | Comment
---- | -------
collect | Run the collect script for the specific cluster
collect_coeus | Collect script for Coeus cluster
collect_orca | Collect script for Orca cluster
fix_elapsed.py | Find and fix rows where end - start is zero
ingest | Ingest the data into the data warehouse
shred | Stage the data in the mod_shredder table

# Required software

The fix_elapsed.py script depends on a UV environment in each of 
/coeuscluster/xdmod and /orcacluster/xdmod on xdmod.rc.pdx.edu.

The process uses /usr/local/bin/uv on xdmod.rc.pdx.edu.


