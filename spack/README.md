# Spack configuration for devel and prod

Last updated: May 30th at 7AM

## Overview

The typical Spack installation keeps everything in one place under the $spack location, typically where the Spack git repo was cloned. 
Proceeding this way is easy and convenient but also prone to introducing errors into production modules. 
A better approach is to set up prod and devel environments where devel can install packages into a view and, after testing, publish those packages to a "build cache" for consumption by other environments such as prod or even by users in their own local Spack install.
The prod environment would be tasked with creating modules for users based on the cached binaries.
Both building in devel and refreshing modules in prod could be automated with CI/CD (Jenkins for example).
Note: This document will not cover installing packages as "Docker" images to an OCI repo.

## Installation

Installation of Spack is done using the typical git clone and then creating environments.

```shell
git clone --branch=releases/v0.23 https://github.com/spack/spack.git 
# this is the latest release until v1.0 is release in June 2025
source spack/share/spack/setup-env.sh
spack env create devel
spack env create prod
```

The spack.yaml configuration files need to be modified once the environments are created.  See below for specifics.  In the configuration files $spack refers to the root directory of Spack, this is 
/software/spack/spack on Coeus and Orca clusters.  The root directory can also be set using the SPACK_ROOT environment variable.

## Development (devel) configuration and use

Activate the environment that was created above.
```shell
spack env activate devel
```

Then replace spack.yaml with this configuration.
```yaml
# This is a Spack Environment file.
#
# It describes a set of packages to be installed, along with
# configuration settings.
spack:
  view:
    icu4c:
      root: /workspace/spack/spack/var/spack/environments/devel/.spack-env/view
      select: [^icu4c]
      projections:
        all: '{name}/{version}-{compiler.name}'
      link: all
      link_type: symlink
  concretizer:
    unify: when_possible
  compilers:
  - compiler:
      spec: gcc@=11.5.0
      paths:
        cc: /usr/bin/gcc
        cxx: /usr/bin/g++
        f77: /usr/bin/gfortran
        fc: /usr/bin/gfortran
      flags: {}
      operating_system: rocky9
      target: x86_64
      modules: []
      environment: {}
      extra_rpaths: []
  packages:
    all:
      compiler: [gcc@11.5.0]
  specs:
  - gcc@13.2.0
  - gcc@12.2.0
  - r@4.4.1
  modules:
    default:
      enable:
      - lmod
      roots:
        # module path for testing, not accessible to users
        lmod: /workspace/spack/spack/var/spack/environments/devel/modules
      lmod:
        hierarchy: []
        core_compilers:
        - gcc@11.5.0
        hide_implicits: true
        hash_length: 0
        projections:
          all: '{name}/{version}-{compiler.name}-{compiler.version}'
          gcc: '{name}/{version}'
          ncl: '{name}/{version}'
        cuda:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        gcc:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        netcdf-c:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        netcdf-fortran:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib'
        netcdf-cxx4:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        openmpi:
          environment:
            set:
              OMPI_MCA_btl: self,vader
              PSM2_MULTI_EP: '0'
```
Things to note, there is a different path for modules than the default given in modules.yaml, and the default compiler is the Rocky Linux provided gcc@11.5.0.  There is an override in the view for icu4c due to name conflicts that were encountered. 
## Build Cache
### GPG

GPG keys need to be created before building a binary cache.
```
spack gpg init
spack gpg create spack help-rc@pdx.edu
```
### Paths

Chose a globally accessible location in NFS for the build cache directory, 
such as /software/spack/cache.

Then create/update the cache.
```shell
spack env deactivate
spack env activate devel
spack buildcache push --with-build-dependencies /software/spack/cache
```

## System Config

Make sure libstdc++-static-11.5.0-5.el9_5.x86_64 is installed (it is not installed normally).

## Production (prod) configuration and use

The configuration file (spack.yaml) needs to look like this.  Note, the mirror configuration for where the devel environment has built the cache and the view.
```yaml
# This is a Spack Environment file.
#
# It describes a set of packages to be installed, along with
# configuration settings.
spack:
  # add package specs to the `specs` list
  specs:
  - r@4.4.1
  - r-xml
  - r-xml2
  view: /software/spack/views/prod
  concretizer:
    unify: true
  mirrors:
    cache: /software/spack/cache
  modules:
    default:
      enable:
      - lmod
      roots:
        lmod: /software/spack/modules
      lmod:
        hierarchy: []
        core_compilers:
        - gcc@11.5.0
        hide_implicits: true
        hash_length: 0
        projections:
          all: '{name}/{version}-{compiler.name}-{compiler.version}'
          gcc: '{name}/{version}'
          ncl: '{name}/{version}'
        cuda:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        gcc:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        netcdf-c:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        netcdf-fortran:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib'
        netcdf-cxx4:
          environment:
            prepend_path:
              LD_LIBRARY_PATH: '{prefix}/lib64'
        openmpi:
          environment:
            set:
              OMPI_MCA_btl: self,vader
              PSM2_MULTI_EP: '0'
```

Packages can be added with 'spack add package' and then 'spack install package' to create the environment view.

Modules (discussed elsewhere in the KB) are created with the 'spack module lmod refresh' command.

## Miscellaneous
### Upstream versus Mirror

A mirror provides pre-built binary packages that speed up installation significantly.  On the other hand an upstream configuration is a reference to another Spack install and the cached sources there.  The latter would be used to avoid downloading from Internet sources.
Uninstall a package

At times it may necessary to uninstall a package such as when there is a newer version, or when a package is no longer needed.  If a package is to be removed it should be removed from all environments and from the build cache.
```shell
spack env activate devel
spack uninstall --remove package
spack env deactivate
spack env activate prod
spack uninstall --remove package
spack module lmod refresh --delete-tree
spack mirror list
# remove the package from the listed mirror path
```

## References

Spack documentation 

Basic Installation Tutorial

Environments Tutorial 

Configuration Tutorial 

Binary Caches Tutorial 

