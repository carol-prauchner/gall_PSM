===============================================================================
READ ME FIRST - CHAPTER 3
Phylogenetic signal of gall presence and its correlated evolution with plant
secondary metabolites across Neotropical plant families
===============================================================================

Chapter title:   Artrhopod gallers have a taste: gall-inducing shows phylogenetic signal for host plants and depends on the evolution of plant secondary metabolites
Authors:         Prauchner, C., Mendonça, M.S.Jr., Etienne, R.S. & Maestri, R.
Last updated:    [FILL IN: date]

See the read_me_first.txt in the parent folder for general information about
the thesis, software and licence.


-------------------------------------------------------------------------------
1. SUMMARY OF THE CHAPTER
-------------------------------------------------------------------------------

This chapter tests whether plant secondary metabolites (PSMs) act as
evolutionary filters for galling insects. Using a phylogeny of 294 Neotropical
plant families, we:

  1. compared the number of PSMs (tannins, flavonoids and phenolic acids;
     0 to 3 per family) between families with and without galls
     (Wilcoxon-Mann-Whitney test);
  2. measured the phylogenetic signal of gall presence, for all arthropod
     galls and separately for galls induced by each of the five main insect
     orders (Diptera, Hemiptera, Hymenoptera, Coleoptera and Lepidoptera),
     with the D statistic for binary traits (Fritz & Purvis, 2010);
  3. tested for correlated evolution between gall presence and the presence
     of each PSM with Pagel's (1994) test, comparing independent, one-way
     dependent (gall presence depends on the PSM) and codependent models with
     AIC and Akaike weights.


-------------------------------------------------------------------------------
2. DATA SOURCES
-------------------------------------------------------------------------------

  - Gall records: Database of Galling Arthropods of the Neotropical Bioregion
    (DGANB; Mendonca, Cabreira & Prauchner, in preparation), compiled from
    188 studies published between 1961 and 2024. 11,127 records of
    arthropod galls on 145 plant families, of which 129 are in the phylogeny.
    Only records with the host plant family identified were used.
  - PSM data per plant family and plant family phylogeny: Zhang et al.
    (2021), National Science Review 8(4): nwaa105. That phylogeny (437
    families) was built by collapsing the seed plant phylogeny of Zanne et
    al. (2014) to family level. Families that do not occur in the Neotropical
    bioregion were removed, leaving 294 families.


-------------------------------------------------------------------------------
3. FILE DESCRIPTIONS
-------------------------------------------------------------------------------

data/
  [gall_psm_final.csv]
      One row per Neotropical plant family (294 rows). Columns:
        family          plant family name
        Flavonoids      presence (1) / absence (0) of flavonoids
        Phenolic_acids  presence (1) / absence (0) of phenolic acids
        Tannins         presence (1) / absence (0) of tannins
        Arthropod_gall  presence (1) / absence (0) of any arthropod gall
        Diptera, Hemiptera, Hymenoptera, Coleoptera, Lepidoptera
                        presence (1) / absence (0) of galls induced by each
                        insect order
      (This is the table given as Supplementary Material 1 of the chapter.)

  [jse12086-sm-0003-suppapp-s3.doc]
      Phylogeny of the 294 Neotropical plant families, pruned from Zhang et
      al. (2021).
  [families_neotropical_reviwed.csv]
      List of plant families that occur in the Neotropical bioregion.
  [data_PSM_gall.csv]
      Table with part of the plant families used in this study taken from of Zhang et al. 2019 and the data of gall presence and neotropical presence.	

scripts/
  [final_data_table_psm_gall]	Create file used for analysis and figures
  [violin_boxplot.R]    	Violin plot and Wilcoxon-Mann-Whitney test of the number of PSMs in families with and without galls.
  [venn_diagram.R]		Venn diagram of the number of families with PSMs and galls.
  [phylo.signal.D.R]    	D statistic of phylogenetic signal for gall presence (all galls and each insect order).
  [PSM_gall_pagel.R]    	Pagel's correlation tests between gall presence and each PSM.
  [phylo_plot_order.R]  	Phylogeny with trait distributions.

tables/
  [D_test_results.csv]		D values, p-values against random and Brownian expectations, and number of families with and without galls.
  [Pagel_test_results.csv]	Log-likelihood, number of parameters, delta AIC and Akaike weight of each model for each gall x PSM pair.

figures/
  [phylo_PSM]		Phylogeny of Neotropical plant families with the presence of PSMs and galls (A).
  [phylo_gall_orders]	Phylogeny of Neotropical plant families with the presence of galls and of galls per insect order (B).
  [venn_diagram]	Venn diagram of the co-occurrence of the three PSMs and galls.
  [violin_plot]		Violin plot of the number of PSMs in families with and without galls.


-------------------------------------------------------------------------------
4. SOFTWARE AND PACKAGES
-------------------------------------------------------------------------------

R 4.2.2 (R Core Team, 2022)
  caper		phylo.d() - D statistic (Orme et al., 2018)
  phytools	fitPagel() - Pagel's correlation test (Revell, 2012)
  Geiger	fitDiscrete method used for optimisation in fitPagel (Pennell et al., 2014)
  ape		reading, pruning and handling phylogenies (Paradis & Schliep, 2019)
  diversitree 	trait.plot() - plotting trait states on the phylogeny (FitzJohn, 2012)
  VennDiagram 	Venn diagram of the co-occurrence of PSMs and galls (Chen & Boutros, 2011)
  textreadr	reading text and document files into R (Rinker, 2021)
  ggpubr	violin plots and Wilcoxon-Mann-Whitney comparison of the number of PSMs in families with and without galls (Kassambara, 2023)
  
-------------------------------------------------------------------------------
5. NOTES
-------------------------------------------------------------------------------

  - The absence of a gall record for a plant family means that no gall was
    found in the compiled literature, not necessarily that the family does
    not host galls.
  - Pagel's test could not be run for Hymenoptera x flavonoids, because all
    families with hymenopteran galls have flavonoids (perfect collinearity).
  - Families are coded as hosts when at least one of their species hosts
    galls.
