# written: 2019-06-18
# changed: 2020-01-31

# taking the latest image
FROM jupyter/minimal-notebook:d4cbf2f80a2a 

# inspired by: 
# https://github.com/umsi-mads/education-notebook/blob/master/Dockerfile 

# Do here all steps as root
USER root

RUN chgrp users /etc/passwd
RUN echo "nbgrader:x:2000:" >> /etc/group


# add ownloud
RUN sh -c "echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_18.04/ /' > /etc/apt/sources.list.d/isv:ownCloud:desktop.list"
RUN wget -nv https://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_18.04/Release.key -O Release.key

RUN apt-key add - < Release.key

# add additional Ubuntu packages
RUN apt install openssh-client latexmk owncloud-client
RUN apt clean

# use this for debugging in the case of UID/GID problems
#COPY start.sh /usr/local/bin/start.sh
#RUN chmod 755 /usr/local/bin/start.sh

# switch back to jovyan to install conda packages

USER $NB_UID


# The conda-forge channel is already present in the system .condarc file, so there is no need to
# add a channel invocation in any of the next commands.



# Add nbgrader 0.5.5 to the image
# More info at https://nbgrader.readthedocs.io/en/stable/

RUN conda install nbgrader --yes


# Add the notebook extensions
RUN conda install jupyter_contrib_nbextensions --yes

# Add RISE 5.4.1 to the mix as well so user can show live slideshows from their notebooks
# More info at https://rise.readthedocs.io
# Note: Installing RISE with --no-deps because all the neeeded deps are already present.
RUN conda install rise --no-deps --yes


# Add the science packages for AIfA
RUN conda install numpy matplotlib scipy astropy sympy --yes 
RUN conda install scikit-image scikit-learn seaborn --yes

# Add the interactive matplotlib extension
RUN conda install -y nodejs --yes
RUN pip install ipympl
#pip install --upgrade jupyterlab
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
RUN jupyter labextension install jupyter-matplotlib
RUN jupyter nbextension enable --py widgetsnbextension

COPY nbgrader_config.py /etc/jupyter/nbgrader_config.py
