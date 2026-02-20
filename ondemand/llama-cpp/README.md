# Batch Connect - OnDemand Tensorboard Server

Batch Connect app that launches a Tensorboard server within a
batch job.

## Prerequisites

In Open OnDemand:

- You must have a valid [cluster configuration](https://osc.github.io/ood-documentation/latest/installation/add-cluster-config.html)
- You must have configured valid regex for your [reverse proxy](https://osc.github.io/ood-documentation/latest/how-tos/app-development/interactive/setup/enable-reverse-proxy.html) that allows your computes to be used in applications.

This Batch Connect app requires the following software be installed on the
**compute nodes** that the batch job is intended to run on (**NOT** the
OnDemand node):

- [Lmod](https://www.tacc.utexas.edu/research-development/tacc-projects/lmod)
  6.0.1+ or any other `module purge` and `module load <modules>` based CLI
  used to load appropriate environments within the batch job before launching
  the Tensorboard server. Currently loads the `tensorboard` from `rocky8` (`module load rocky8 tensorboard`)
