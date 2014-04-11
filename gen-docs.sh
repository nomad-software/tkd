#! /bin/bash

cd source;

rdmd --force -d -Dd../docs -de -op -w -main -I. -I/media/Data/Projects/D/x11/source -I/media/Data/Projects/D/tcltk/source -L-ltcl -L-ltk tkd/tkdapplication.d;
