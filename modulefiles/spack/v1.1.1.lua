
whatis("Name:        ", "Spack")
whatis("Version:     ", "v1.1.1")
whatis("Description: ", "Spack package management")

source_sh("/bin/bash", "/software/spack/spack-module/v1.1.1/share/spack/setup-env.sh")

os.execute("mkdir -p $HOME/.spack/opt/spack")
os.execute("mkdir -p $HOME/.spack/var/spack/cache")
os.execute("mkdir -p $HOME/.spack/var/spack/environments")
setenv("SPACK_SYSTEM_CONFIG_PATH", "/software/spack/defaults/config")
setenv("SPACK_ROOT", "/software/spack/spack-module/v1.1.1")
depends_on("gcc/13.4.0")
