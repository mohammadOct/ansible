#!/bin/bash

mkdir -p tmp

#wget --no-check-certificate https://artifacts.ruv.de/artifactory/list/cran-local-lx/src/contrib/* tmp/.
wget --no-check-certificate https://artifacts.ruv.de/artifactory/list/cran-local-lx/src/contrib/. --mirror --no-parent --no-host-directories --cut-dirs=4 --directory-prefix=tmp/ -e robots=off -A.gz

for name in tmp/contrib/*.gz;do
tar -xvf  $name -C tmp/.
done

rm -rf tmp/contrib

cp -rp  tmp/* site-library/
