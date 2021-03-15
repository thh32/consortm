# consortm
ConsortM: MALDI-based consortia monitoring


## Installation

# Conda

ConsortM is installable via conda using the command; `conda install -c thitch consortm`

## Usage

ConsortM requires two inputs; the raw MALDI profiles, and the project name.

The raw MALDI profiles must be provided as a folder, containing sub-folders named after each group being compared. Within these group folders place the MALDI profiles.

ConsortM can then be run using the command; `ConsortM.py -i $RAW_DATA -p $PROJECT_ID`

## Citation
ConsortM is currently being prepared as a manuscript.

In addition to our work, please also cite the following publications which provide code underpinning ConsortM;

- HTSeq (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4287950/)
- ade4 (https://www.jstatsoft.org/article/view/v022i04)
- vegan (Jari Oksanen, F. Guillaume Blanchet, Michael Friendly, Roeland Kindt, Pierre Legendre, Dan McGlinn, Peter R.
  Minchin, R. B. O'Hara, Gavin L. Simpson, Peter Solymos, M. Henry H. Stevens, Eduard Szoecs and Helene Wagner
  (2020). vegan: Community Ecology Package. R package version 2.5-7. https://CRAN.R-project.org/package=vegan)
