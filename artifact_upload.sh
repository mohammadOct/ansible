#!/bin/bash

# Read Password
echo -n 'dein username':
read   username

echo -n 'dein Password':
read -s password

# Run Command
#printf "\n  mein user: $username \n"


# loop over date
for datei in cran/*.gz; do
curl -u "$username":"$password" -T  "$datei"  -XPOST "https://artifacts.ruv.de/artifactory/api/cran/cran-local-lx/sources"
done
