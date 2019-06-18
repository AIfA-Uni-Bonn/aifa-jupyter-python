# written: 2019-06-18

# taking the latest image
FROM jupyter/minimal-notebook:d4cbf2f80a2a 

# inspired by: 
# https://github.com/umsi-mads/education-notebook/blob/master/Dockerfile 

# Do here all steps as root
USER root

# switch back to jovyan to install conda packages

USER $NB_UID


# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.

# Add nbgrader 0.5.5 to the image
# More info at https://nbgrader.readthedocs.io/en/stable/

RUN conda install nbgrader --yes


# Add RISE 5.4.1 to the mix as well so user can show live slideshows from their notebooks
# More info at https://rise.readthedocs.io
# Note: Installing RISE with --no-deps because all the neeeded deps are already present.
RUN conda install rise --no-deps --yes


# Add the science packages for AIfA
RUN conda install numpy scipy astropy sympy --yes 
