# Processing of time-resolved 2D spectra

[NmrPipe](https://www.ibbr.umd.edu/nmrpipe/index.html) shell scripts to batch
process consecutively acquired 2D NMR experiments as a *time-resolved* serie.

## Description & aim

The use case for these tools is the analysis of NMR data sets from evolving
samples. The objective is to process time-ordered 2D experiments identically,
and then extract spectral features to be monitored - i.e. peak intensities
or positions. The series of 2D slices can be thus considered a pseudo-3D.

The processing pipeline is based on the
[relaxation demo example](https://www.ibbr.umd.edu/nmrpipe/demo.html) from the
NmrPipe documentation. You can download a copy
[here](http://www.ibbr.umd.edu/nmrpipe/demo.tar) and find the
example under `demo/relax`.

## Requirements

- In order to run these scripts you will need a working installation of
  **NmrPipe**. You can find the installation files and instructions
  [here](https://www.ibbr.umd.edu/nmrpipe/install.html).

- The code has only been tested in a Linux environment.

- Please note that NmrPipe uses the C shell (`tcsh`/ `csh`).

## Input format

The code here converts raw spectra acquired with **Bruker Topspin**
(`ser` format), using NmrPipe's `bruker` tool. Other input formats can be
trivially implemented.
