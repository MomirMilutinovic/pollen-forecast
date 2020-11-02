# start from the rocker/r-ver:3.5.0 image
FROM rocker/r-ver:3.5.0

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libsodium-dev zlib1g-dev libxml2-dev

# copy everything from the current directory into the container
COPY / /

# open port 5762 to traffic
EXPOSE 5762

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "main.R"]
