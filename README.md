<p align="center">
<img src="/images/ConsortM-logo.png" width="400">
</p>


ConsortM is a package designed to facilitate continual quick, cheap and reliable monitoring of minimal microbial consortia, via the use of MALDI-TOF MS.

Acting as a series of scripts, ConsortM accepts raw MALDI profiles (tested on the Brucker Biotyper) and provide both visual and statstical comparison of different groups, be these the same consortia over time, or different consortia.



## Installation

### Conda

ConsortM is installable via conda using the command:

```bash
conda install -c thitch consortm
# To add all R dependencies
conda install -c thitch -c conda-forge consortm r-vegan r-ade4 r-ggplot2 r-phangorn r-factoextra
```


## Usage

ConsortM requires two inputs; the raw MALDI profiles, and the project name.

The raw MALDI profiles must be provided as a folder, containing sub-folders named after each group being compared. Within these group folders place the MALDI profiles.

ConsortM can then be run using the command; `ConsortM.py -i $RAW_DATA -p $PROJECT_ID`

## Example dataset

As an example we provide a set of files from three groups; the OligoMM12 consortium, <i>Extibacter muris</i>, and the combination of the OligoMM12 consortium with <i>Extibacter muris</i> included.

By running this dataset through ConsortM you should get a plot which looks very similar to that below. Additionally a statistics file should be output which states that all three groups are significantly (adj. p-value <0.01) different from each other.
<p align="center">
<img src="/images/Example_output.png" width="300">
</p>


## Output

ConsortM provides three major outputs;
-	 Multidimensional scaling (MDS) plots of the distance between each groups samples samples
-	 A dendrogram based on the same distances
-	Statistical comparison of the distances between each group to each other (pairwise) via PERMANOVA  


## Citation
ConsortM is currently being prepared as a manuscript.

In addition to our work, please also cite the following publications which provide code underpinning ConsortM;

- <b>HTSeq</b> (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4287950/)
- <b>ade4</b> (https://www.jstatsoft.org/article/view/v022i04)
- <b>vegan</b> (Jari Oksanen, F. Guillaume Blanchet, Michael Friendly, Roeland Kindt, Pierre Legendre, Dan McGlinn, Peter R.
  Minchin, R. B. O'Hara, Gavin L. Simpson, Peter Solymos, M. Henry H. Stevens, Eduard Szoecs and Helene Wagner
  (2020). vegan: Community Ecology Package. R package version 2.5-7. https://CRAN.R-project.org/package=vegan)
