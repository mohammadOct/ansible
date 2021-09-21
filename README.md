# R packages for the classical Linux machines 

In contrast to Windows one has to compile the R packages on a Linux platform. In the following we explain how one can compile R packages and apply them on a shiny server. To compile the packages one needs couple of Linux packages and dependencies.
The idea is as follows, there are 4 scripts:

## For admins who use a Linux Server for Shiny-Apps and need additional R-packages

**Prerequisite:** 
* You have access on your Shiny - Linux Server and are able to copy Files in the "site-library/" Folder
* The .libPaths() in the R-Runtime reads site-library/ as an location for R-Packages. If not, send a Mail to (G_UNIX@ruv.de). This group can expand the .libPaths()
* Clone the **artifact_download.sh** script from this repository

![](https://github.ruv.de/cfrcrm/ansibleRShiny/blob/master/documentation/libpath.jpg)

**Execution:**

Step 1: Check, if the necessary Package is available at https://artifacts.ruv.de/artifactory/webapp/#/artifacts/browse/tree/General/cran-local-lx/src/contrib . 
**If the package is not available ask Mohammad Assadsolimani, Alexej Jaick or Marcel Ulrich to upload the package in artifactory**

Step 2: You can download single packages direct from artifatory or use the artifact_download.sh - script to download all of them. 
1. **artifact_download.sh**: a shell script to download the R packages on a shiny server and copy them into the correct folder. Every user on the shiny server should be able to apply this script. First ensure that the script is executeable or make it executeable (chmod +x artifact_download.sh), then run it by ./artifact_download.sh.

Step 3: Destination to copy the R-Packages on the Linux Server is: "/apps/shiny/site-library"


## For admins who upload packages in artifactory

**Prerequisite:**
* You can use a FlexIT-Maschine https://themen.ruv.de/sites/01000520/SitePages/flexit.aspx
* One needs a flt-CentOS 7 machine with min 6 CPUs. In addition one needs the R package 'stringi_1.5.3.tar.gz' because otherwise it was not possible to build this package direcktly. After deploying both files and 'stringi_1.5.3.tar.gz' one has to run the ansible playbook to generate packages occuring in 'shiny_packages.R' in cran folder.

**Execution:**

2. **shiny_tasks.yml**: an Ansible script to install the required Linux packages on Centos7 and for couple of R packages even Centos8 and to call "shiny_packages.R". You can call this ansible script with the command **ansible-playbook shiny_tasks.yml**
3. **shiny_packages.R**: in this R script we define all packages, compile and install them if they are not installed.
4. **artifact_upload.sh**: to upload the compiled R packages into Artifactory (https://artifacts.ruv.de/artifactory/webapp/#/artifacts/browse/tree/General/cran-local-lx/src/contrib). This is just possible, if the user is allowed to write in this repository.

If you have any further questions, please contact Mohammad Assadsolimani, Alexej Jaick or Marcel Ulrich


## Erläuterung in einfacher Sprache:<br>Wenn CRAN Paket hinzugefügt oder geupdatet werden soll:
1. Flexit Maschine bestellen https://vra.ruv.de/vcac/#csp.cs.ui.catalog.list
1. Wichtig bei der Beantragung ist der public key der in einem speziellen Format vorliegen muss. Nur der reine Key (ab dem Buchstaben-Salat z.B. `AAAB...`) in einer Zeile ohne Kommentare lediglich VOR den Key kommt `ssh-rsa ` inklusive Leerzeichen und am Ende des Keys in der gleichen Zeile `== xv12345` mit der entsprechenden xv-Nummer und vor den Gleichheitszeichen OHNE und hinter den Gleichheitszeichen MIT Leerzeichen. 
1. Auf Flexit Maschine einloggen über Putty: Name der Flexit Maschine und Port 22
1. Auf Flexit Maschine `git clone https://github.ruv.de/xv60789/ansibleRShiny.git`
1. In neuen Ordner gehen `cd ansibleRShiny`.
1. `shiny_packages.R` anpassen, indem Liste von Paketen gelöscht und durch gewünschte Pakete (auf CRAN) ersetzt wird.
1. Ausführen von `ansible-playbook shiny_tasks.yml`
1. Vor den nächsten Befehlen in putty "forwarding" erlauben: Unter `data` xv-Nummer als Auto-Login-User eintragen und unter SSH > Auth > "Allow agent forwarding" anhaken.
1. Ausführen `scp -r library/* xv12345@lx00XXX:/apps/shiny/site-library/` wobei xv12345 die XV-Nummer ist und lx00XXX ist der Name der Linux-Maschine. (Achtung hier auf momentanen Ordner, ggf. library nicht notwendig
1. Alternativ wenn libraries ersetzt werden soll: `scp -rp library/* xv12345@lx00XXX:/apps/shiny/site-library/`
