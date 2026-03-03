whatis([===[Provide the environment variables to run R version 4.5.1 compiled with openmpi-4.0 and GCC 13.4.0.]===])
depends_on("gcc/13.4.0")
depends_on("openmpi/4.1.8-gcc-13.4.0")
depends_on("openjdk/17.0.11_9-none-none")
setenv("RHOME","/software/R/4.5.1/lib64/R/")
prepend_path{"LD_LIBRARY_PATH","/software/R/4.5.1/lib64/R/lib",delim=":",priority="0"}
prepend_path{"MANPATH","/software/R/4.5.1/share/man",delim=":",priority="0"}
prepend_path{"PATH","/software/R/4.5.1/bin",delim=":",priority="0"}
setenv("TMPDIR", os.getenv("HOME") .. "/Rtmp")
os.execute("mkdir -p $HOME/Rtmp")
