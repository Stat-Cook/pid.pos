# Filter a tagged data frame to proper nouns

Filter a tagged data frame to proper nouns

## Usage

``` r
filter_to_proper_nouns(tag_frm)
```

## Arguments

- tag_frm:

  A data frame containing at least the columns \`upos\`, \`ID\`,
  \`Token\`, and \`Sentence\`.

## Value

A tibble containing only rows where \`upos == "PROPN"\`, with columns
\`ID\`, \`Token\`, and \`Sentence\`.

## Examples

``` r
example.data <- head(the_one_in_massapequa, 20)
tagged <- tag_data_frame(example.data, tagger = "english-ewt")
#> Downloading udpipe model from https://raw.githubusercontent.com/jwijffels/udpipe.models.ud.2.5/master/inst/udpipe-ud-2.5-191206/english-ewt-ud-2.5-191206.udpipe to /home/runner/.cache/R/pid.pos/english-ewt-ud-2.5-191206.udpipe
#>  - This model has been trained on version 2.5 of data from https://universaldependencies.org
#>  - The model is distributed under the CC-BY-SA-NC license: https://creativecommons.org/licenses/by-nc-sa/4.0
#>  - Visit https://github.com/jwijffels/udpipe.models.ud.2.5 for model license details.
#>  - For a list of all models and their licenses (most models you can download with this package have either a CC-BY-SA or a CC-BY-SA-NC license) read the documentation at ?udpipe_download_model. For building your own models: visit the documentation by typing vignette('udpipe-train', package = 'udpipe')
#> Downloading finished, model stored at '/home/runner/.cache/R/pid.pos/english-ewt-ud-2.5-191206.udpipe'
filter_to_proper_nouns(tagged$`AllTags`)
#> # A tibble: 20 × 3
#>    ID                Token     Sentence                                         
#>    <chr>             <chr>     <chr>                                            
#>  1 Col:text Row:14   Ross      "And you wonder why Ross is their favorite?"     
#>  2 Col:speaker Row:7 Chandler  "Chandler"                                       
#>  3 Col:speaker Row:7 Bing      "Bing"                                           
#>  4 Col:speaker Row:5 Joey      "Joey Tribbiani"                                 
#>  5 Col:speaker Row:5 Tribbiani "Joey Tribbiani"                                 
#>  6 Col:speaker Row:3 Monica    "Monica Geller"                                  
#>  7 Col:speaker Row:3 Geller    "Monica Geller"                                  
#>  8 Col:text Row:15   Ross      "Any time Ross makes a toast everyone cries, and…
#>  9 Col:text Row:2    Ross      "Oh, Ross, Mon, is it okay if I bring someone to…
#> 10 Col:text Row:2    Mon       "Oh, Ross, Mon, is it okay if I bring someone to…
#> 11 Col:speaker Row:2 Phoebe    "Phoebe Buffay"                                  
#> 12 Col:speaker Row:2 Buffay    "Phoebe Buffay"                                  
#> 13 Col:speaker Row:4 Ross      "Ross Geller"                                    
#> 14 Col:speaker Row:4 Geller    "Ross Geller"                                    
#> 15 Col:text Row:6    Parker    "Well, his name is Parker and I met him at the d…
#> 16 Col:text Row:13   Ross      "Every year Ross makes the toast, and it's alway…
#> 17 Col:text Row:1    Central   "[Scene: Central Perk, everyone is there.]"      
#> 18 Col:text Row:1    Perk      "[Scene: Central Perk, everyone is there.]"      
#> 19 Col:text Row:19   Chandler  "[Scene: Chandler and Monica's, they're getting …
#> 20 Col:text Row:19   Monica    "[Scene: Chandler and Monica's, they're getting …
```
