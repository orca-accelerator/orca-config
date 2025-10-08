# Spack configuration for devel and prod

Localized configuration files are stored here.

## Prod Process

See the [Spack wiki](https://github.com/orca-accelerator/orca-config/wiki/Spack)
for more info.

Specifically,

Create a Spack instance for gcc (such as /software/spack/gcc), and build gcc@13.4.0

Create a Spack instance for v1.0.

Then...

``` shell
source /software/spack/v1.0/share/spack/setup-env.sh
spack repo set --destination /software/spack/v1.0/repos --scope defaults builtin
spack env create prod
spack env activate prod
mkdir /software/spack/v1.0/view
mkdir /software/spack/v1.0/modules
spack compiler add /software/spack/gcc/opt/spack/linux-zen4/gcc-13.4.0-oxbf4xf36avhl3rjfqmklxylfiqv6gwq/bin/gcc
spack compiler rm gcc@11.5.0
```

Then build everything, and refresh the modules.
