---
title: 'PID.POS: An R package for the detection of personally identifiable data'
tags:
  - R
authors:
  - name: Robert M. Cook
    orcid: 0000-0003-3343-8271
    equal-contrib: false
    affiliation: 1
  - name: A N Other
    orcid: XXXX-XXXX-XXXX-XXXX
    equal-contrib: false # (This is how you can denote equal contributions between multiple authors)
    affiliation: 1
  - name: Sarahjane Jones
    orcid: 0000-0003-4729-4029
    equal-contrib: false # (This is how you can denote equal contributions between multiple authors)
    affiliation: 1
affiliations:
 - name: University of Staffordshire, Centre for Health Innovation, Blackheath Lane, Stafford,  England
   index: 1
date: 12 December 2023
bibliography:  JOSS_utilities/paper.bib
---
# Summary

The `PID.POS` package is designed to aid with the identification of
personal identifiability risks in data sets. By applying existing
natural language processing techniques, the package is able to identify
proper nouns within a data set. The extraction of proper nouns reduced
the complexity of the data, allowing for a quicker review and oversight
of the data. The package also includes a basic tool for the design, and
implementation of a redaction process.

# Statement of need

The world is embedded in a data revolution. Never before have we had the
depth or breadth of data being captured and analysed than we do at
present, and this is only set to increase. In response, international
bodies are taking steps to ensure legal protection of an individual’s
rights to their own data [@GDPR]. One effect of increase legislation
has been a growing awareness of the role and responsibility of data
controllers [@ICODataController] and the risks of big data
[@clarke2016big]. Among these concerns, a risk of ‘personal
identifiability’ i.e. the ability to directly or indirectly identify an
individual from a dataset [@finck2020they], is paramount and, if
breeched, can lead to reputation damage and fines [@ICOWhatIf].

Where data is structured and comprises only a few hundred observations,
a manual inspection can identify variables which contain directly
personally identifiable data (PID) with a reasonable time investment.
However, in the case of modern large data sets which may comprise
millions of observations, a manual inspection may miss PID if it is
embedded within a passage of text, or is a rarity for the given
variable. The `PID.POS` (Personal Identifiability Detection by Part Of
Speech tagging) package is designed to aid with the identification of
PID risks in data sets. In comparison to existing packages which rely on
a curated list of common names and string-matching, `PID.POS` builds on
the existing `udpipe` framework, extracting all examples of proper nouns
and providing a mechanism for the review and redaction of PID risks.

# Comparison to existing R packages

The need to review data sets to identify risks is not new, and there are
a number of packages which have been developed to aid in this process.
The most notable of these are the `PII` package [@pii], which is
designed to identify personally identifiable features via pattern
matching. These approaches can be effective in identifying PID, but have
a risk of missing edge cases e.g. relying on sentence case to identify
names. The approach taken in `PID.POS` conversely takes the approach of
purposefully extracting all proper-nouns, and hence increase the false
positive rate, with the intention of supplying a simplified extract to
aid human interpretation rather than fully automate it.

# In practice

To install the current version of `PID.POS` package, use the following
code:

``` r
# install.packages("pak")
pak::pkg_install("Stat-Cook/PID.POS")
```

To assist with understanding the `PID.POS` package, we include a subset
of the ‘friends’ data set from the `friends` package.

``` r
library(pid.pos)
the_one_in_massapequa
```

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["scene"],"name":[1],"type":["int"],"align":["right"]},{"label":["utterance"],"name":[2],"type":["int"],"align":["right"]},{"label":["speaker"],"name":[3],"type":["chr"],"align":["left"]},{"label":["text"],"name":[4],"type":["chr"],"align":["left"]}],"data":[{"1":"1","2":"1","3":"Scene Directions","4":"[Scene: Central Perk, everyone is there.]"},{"1":"1","2":"2","3":"Phoebe Buffay","4":"Oh, Ross, Mon, is it okay if I bring someone to your parent's anniversary party?"},{"1":"1","2":"3","3":"Monica Geller","4":"Yeah."},{"1":"1","2":"4","3":"Ross Geller","4":"Sure. Yeah."},{"1":"1","2":"5","3":"Joey Tribbiani","4":"So, who's the guy?"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>

The package has two main functions for identifying PID risks, depending
on the users needs.  
First, the `data_frame_report` function converts a typical R data frame
into a new data frame of:

-   `ID` - the column and row where the sentence first appears
-   `Token` - the specific proper noun token
-   `Sentence` - the sentence containing proper nouns
-   `Repeats` - the number of times the sentence occurs in the data set
-   `Affected Columns` - the columns in the original data frame which
    contain the sentence

``` r
report <- data_frame_report(the_one_in_massapequa)
report
```

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["ID"],"name":[1],"type":["glue"],"align":["right"]},{"label":["Token"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Sentence"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Repeats"],"name":[4],"type":["int"],"align":["right"]},{"label":["Affected Columns"],"name":[5],"type":["chr"],"align":["left"]}],"data":[{"1":"Col:speaker Row:2","2":"Phoebe","3":"Phoebe Buffay","4":"40","5":"`speaker`"},{"1":"Col:speaker Row:2","2":"Buffay","3":"Phoebe Buffay","4":"40","5":"`speaker`"},{"1":"Col:speaker Row:3","2":"Monica","3":"Monica Geller","4":"25","5":"`speaker`"},{"1":"Col:speaker Row:3","2":"Geller","3":"Monica Geller","4":"25","5":"`speaker`"},{"1":"Col:speaker Row:4","2":"Ross","3":"Ross Geller","4":"43","5":"`speaker`"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>

The second function is `report_on_folder` which iterates over a folder
of data files, producing a proper noun report for each. It is foreseen
that this function will be the more useful, used just before data
release to evidence no PID risks.

``` r
report_on_folder('path/to/data/')
browse_model_location()
```

NB: the `data_frame_report` and `report_on_folder` functions automate
the download of the pre-trained `udpipe` model. These models are
required to be cached to the users hard-drive and hence firewall issues
may present. The vignette … is included to help with common issues.

While being able to identify PID risks is the core premise of this
package, it would be remiss to not supply some tools to aid in the
removal of PID. Hence, we supply  
basic functionality designed for minimal technical knowledge to assist
in the redaction of PID.

Where a PID report has been ran, the resulting data frame can be passed
to the function `report_to_replacement_rules` which will convert the
report to a csv file with three headings:

-   `If` - the sentence pattern which, if it matches, the replacement is
    applied
-   `From` - the pattern to be replaced
-   `To` - the intended replacement

``` r
replacement_rules <- report_to_replacement_rules(
  report, 
  path='path/to/report.csv'
)
```

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["If"],"name":[1],"type":["chr"],"align":["left"]},{"label":["From"],"name":[2],"type":["chr"],"align":["left"]},{"label":["To"],"name":[3],"type":["chr"],"align":["left"]}],"data":[{"1":"Phoebe Buffay","2":"Phoebe","3":"Phoebe"},{"1":"Phoebe Buffay","2":"Buffay","3":"Buffay"},{"1":"Monica Geller","2":"Monica","3":"Monica"},{"1":"Monica Geller","2":"Geller","3":"Geller"},{"1":"Ross Geller","2":"Ross","3":"Ross"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>

The csv file is intended to be edited by the data controller, who hence
does not need to understand R, and can be reimported using the
`load_replacement_rules` function:

``` r
load_replacement_rules('path/to/report.csv')
```

The `load_replacement_rules` function creates a string replacement rule
to capture the desired redactions, with the option for R to ‘parse’ the
function for use as part of a data pipeline:

``` r
replacement.func <- load_replacement_rules('path/to/report.csv', parse=T)

the_one_in_massapequa |>
  mutate(
    across(
      where(is.character),
      replacement.func
    )
  )
```

For a more advanced user, the `load_replacement_rules` function utilizes
the `str_detect` and `str_replace_all` functions from the `stringr`
package, and hence supports regex. Further utilities are available,
notably tools to automatically encode the `To` column (see [Auto
Replacements](https://stat-cook.github.io/pid.pos/articles/AutoReplacement.html)).

# Current applications

The `PID.POS` package was developed for applications in the NuRS and
AmReS research projects which aim to extract and analyse retrospective
operational data from NHS Trusts to understand staff retention and
patient safety.

# Contributions

The package was designed by RC and …. Implementation was done by RC.
Quality assurance was done by … Documentation was written by RC….
Funding for the work was won by RC and SJ.

# Acknowledgements

The development of `PID.POS` was part of the NuRS and AmReS projects
funded by the Health Foundation.

# References
