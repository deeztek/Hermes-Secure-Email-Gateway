cd /mnt/data/amavis/

/bin/grep -R -i -l "X-Envelope-To: <RECIPIENT>" * | xargs /bin/grep -R -i -l "SEARCH-STRING" > /opt/hermes/tmp/CUSTOM-TRANS_results.txt 
