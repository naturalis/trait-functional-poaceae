## Scripts
This directory contains several Shell and R scripts intended to query data from the Encyclopedia of Life (EoL)
and analyse this data into usable results.

**NOTE**: for the shell scripts named `traitAnalyser.sh` and `traitGetData.sh` an additional file is required.
Please make sure to add a file named `eol.token` within this directory.
This file needs to contain your Encyclopedia of Life token, which can be acquired with the method
described [here](https://github.com/EOL/eol_website/blob/master/doc/api.md).

This file needs to ONLY contain your token, with nothing else, in this way:
```
eyJ0eXAzczOzJZUzZ1NzJ9.eyJ1c2VyZjoTA1QWJsZzfQ.Xf5FSA2P_lJBGyBYGTsRPczAkg
```
(please note this is an example token)


### traitAnalyser.sh
This script is made for collecting all traits recorded for each of the children of a page with `page_id` in the Encyclopedia of Life.
It will return a list in Comma Separated Value format with the following columns:
1. `trait`: This contains the name of the trait (or predicate) as listed on the EoL.
2. `total_occurrence`: Some organism entries may have multiple records of a single trait. This column contains the cumulative count of these.
3. `unique_occurrence`: Unlike `total_occurrence`, this column stores one for every trait an organism has, and is **not** cumulative.
4. `uri`: This has the URI address where the EoL has retrieved this data from.
5. `definition`: The definition of the trait, as defined by the ontology, is stored here.
6. `comment`: An optional note added by the EoL curators.

### traitGetData.sh
This script contains a query to fetch all record data of the Seed Dry Mass predicate of all children of a page with `page_id` from the Encyclopedia of Life.
It will return a list in Comma Separated Value format with the following columns:
1. `organism`: This column contains the scientific name of the organism.
2. `trait`: This contains the name of the trait (or predicate) as listed on the EoL.
3. `measurement`: The value of the measurement of Seed Dry Mass is stored here.
4. `unit`: The unit the measurement in column 3 is recorded in.


