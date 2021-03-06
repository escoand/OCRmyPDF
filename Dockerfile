# OCRmyPDF
#
FROM      ubuntu:17.04
MAINTAINER James R. Barlow <jim@purplerock.ca>

RUN apt-get update && apt-get install -y --no-install-recommends \
  software-properties-common python-software-properties \
    build-essential \
    xvfb \
    git wget python-virtualenv python-numpy python-scipy netpbm \
    python-pyqt5 ghostscript libffi-dev libjpeg-turbo-progs \
    python-dev python-setuptools \
    python3-dev cmake  \
    libtiff5-dev libjpeg8-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev \
    python-tk python3-tk \
    libharfbuzz-dev libfribidi-dev \
  python3-wheel \
  python3-reportlab \
  python3-venv \
  ghostscript \
  qpdf \
  poppler-utils \
  unpaper \
  libffi-dev \ 
  tesseract-ocr \
  tesseract-ocr-eng \
  tesseract-ocr-fra \
  tesseract-ocr-spa \
  tesseract-ocr-deu

ENV LANG=C.UTF-8

RUN python3 -m venv --system-site-packages /appenv

# This installs the latest binary wheel instead of the code in the current
# folder. Installing from source will fail, apparently because cffi needs
# build-essentials (gcc) to do a source installation 
# (i.e. "pip install ."). It's unclear to me why this is the case.
RUN . /appenv/bin/activate; \
  pip install --upgrade pip \
  && pip install ocrmypdf

# Now copy the application in, mainly to get the test suite.
# Do this now to make the best use of Docker cache.
COPY . /application
RUN . /appenv/bin/activate; \
  pip install -r /application/test_requirements.txt

# Remove the junk, including the source version of application since it was
# already installed
RUN rm -rf /tmp/* /var/tmp/* /root/* /application/ocrmypdf \
  && apt-get autoremove -y \
  && apt-get autoclean -y

RUN useradd -m -d /home/docker docker

# Must use array form of ENTRYPOINT
# Non-array form does not append other arguments, because that is "intuitive"
ENTRYPOINT ["/application/docker-wrapper.sh"]
