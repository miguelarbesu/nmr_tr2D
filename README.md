# Processing of time-resolved 2D spectra

[NmrPipe](https://www.ibbr.umd.edu/nmrpipe/index.html) shell scripts to batch
process consecutively acquired 2D NMR experiments as a *time-resolved* serie.

## Description & aim

The use case for these tools is the analysis of NMR data sets from evolving
samples. The objective is to process time-ordered 2D experiments identically,
and then extract spectral features to be monitored - peak intensities in this
case. The series of 2D slices can be thus considered a pseudo-3D.

A master peak list is used to define the peak positions at which signal
intensities will be tracked along the time pseudo-dimension.

The processing pipeline is initially based on the
[relaxation demo example](https://www.ibbr.umd.edu/nmrpipe/demo.html) from the
NmrPipe documentation. You can download a copy
[here](http://www.ibbr.umd.edu/nmrpipe/demo.tar) and find the
scripts under `demo/relax`.

## Requirements

- In order to run these scripts you will need a working installation of
  **NmrPipe**. You can find the installation files and instructions
  [here](https://www.ibbr.umd.edu/nmrpipe/install.html).

- The code has only been tested in a Linux system.

- Note that NmrPipe uses the C shell (`tcsh`/ `csh`). Shebangs in the script
files however allow usage from the Bash shell.

## Input format

The code here converts raw spectra acquired with **Bruker Topspin**
(`ser` format), using NmrPipe's `bruker` tool. Other input formats can be
trivially implemented.

## How-to

All C-shell scripts can be run individually, and accept **three positional arguments**:
`script.com /path_to_expdir first_exp last_exp`

0. Clone or download this repository.
1. Create a /data folder and put/link your experiment directory(ies) in it. You \
can use `get_explist.sh` to inspect the `title` files of all spectra in
the folder(s). Note that this is a Bash script.
2. Adjust the size of the time step (in minutes) in the `conversion.com`
3. Run `all.com` for batch conversion, processing, and peak picking. Tune
processing - e.g. phasing, window functions, etc. - as needed using `nmrDraw`.
It is recommended to perform this step selecting ~5 slices
4. Use `nmrDraw` to curate your peak list of interest (clean up noise, add
overlapping or newly appearing peaks) and save it in
`data/your_experiment/master.tab`. The series of processed spectra and the
difference slices can help you.
5. Run `series.com` to track the intensities at the positions of the peaks
defined in your `master.tab`. Results will be saved under the `tab` folder.

Four folders are created in total:
- `fid_*`: converted raw spectra series in nmrPipe format.
- `ft_*`: processed spectra series in nmrPipe format.
- `dif_*`: difference spectra series vs reference in nmrPipe format.
- `tab_*`: Picked peak, master, and time series lists.
