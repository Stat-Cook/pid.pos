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
bibliography: paper.bib
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
present, and this is only set to increase. Following a period of rapid
development in the spaces of machine learning and artificial
intelligence, regulatory bodies are now playing catch up, with national
and international acts coming into force to protect individual rights to
privacy[@GDPR; @CalCiv2018].

One effect of increase legislation and visibility of privacy concerns
has been a surge in data literacy, with data controllers becoming more
aware of the risks associated with the data they hold[ref]. Of all
concerns, ‘personal identifiability’ i.e. the ability to directly or
indirectly identify an individual from a dataset[ref], is paramount
and, if breeched, can lead to reputation damage and fines[ref]. Where
data is structured and complete, a manual inspection can readily
identify variables which contain directly personally identifiable data
(PID). However, in the case of modern large data sets which may comprise
millions of observations, a manual inspection may miss PID if it is
embedded within a passage of text, or is a rarity for the given
variable.

The `PID.POS` (Personal Identifiability Detection by Part Of Speech
tagging) package is designed to aid with the identification of PID risks
in data sets. In comparison to existing packages which rely on a curated
list of common names and string-matching, `PID.POS` builds on the
existing `udpipe` framework, extracting all examples of proper nouns and
providing a mechanism for the review and redaction of PID risks.

# Comparison to existing R packages

The need to review data sets to identify risks is not new, and there are
a number of packages which have been developed to aid in this process.
The most notable of these are the `PII` package[ref], which is
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
library(dplyr)

glimpse(the_one_in_massapequa)
```

    ## Rows: 257
    ## Columns: 4
    ## $ scene     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,…
    ## $ utterance <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,…
    ## $ speaker   <chr> "Scene Directions", "Phoebe Buffay", "Monica Geller", "Ross Geller", "Joey Tribbiani", "Phoebe Buffay", "Chandler…
    ## $ text      <chr> "[Scene: Central Perk, everyone is there.]", "Oh, Ross, Mon, is it okay if I bring someone to your parent's anniv…

The package has two main functions for identifying PID risks, depending
on the users needs.  
First, the `data_frame_report` function converts a typical R data frame
into a new data frame of:

-   `Sentence` - the sentence containing proper nouns
-   `Token` - the specific proper noun token
-   `Repeats` - the number of times the sentence occurs in the data set
-   `Affected Columns` - the columns in the original data frame which
    contain the sentence
-   `ID` - the column and row where the sentence first appears

``` r
report <- data_frame_report(the_one_in_massapequa)
report
```

    ##                     ID         Token
    ## 1    Col:speaker Row:2        Phoebe
    ## 2    Col:speaker Row:2        Buffay
    ## 3    Col:speaker Row:3        Monica
    ## 4    Col:speaker Row:3        Geller
    ## 5    Col:speaker Row:4          Ross
    ## 6    Col:speaker Row:4        Geller
    ## 7    Col:speaker Row:5          Joey
    ## 8    Col:speaker Row:5     Tribbiani
    ## 9    Col:speaker Row:7      Chandler
    ## 10   Col:speaker Row:7          Bing
    ## 11  Col:speaker Row:27        Rachel
    ## 12  Col:speaker Row:27         Green
    ## 13  Col:speaker Row:43        Parker
    ## 14  Col:speaker Row:67            NA
    ## 15  Col:speaker Row:70          Judy
    ## 16  Col:speaker Row:70        Geller
    ## 17  Col:speaker Row:71          Jack
    ## 18  Col:speaker Row:71        Geller
    ## 19  Col:speaker Row:74         Woman
    ## 20  Col:speaker Row:90          Aunt
    ## 21  Col:speaker Row:90          Lisa
    ## 22  Col:speaker Row:92           Dan
    ## 23      Col:text Row:1       Central
    ## 24      Col:text Row:1          Perk
    ## 25      Col:text Row:2          Ross
    ## 26      Col:text Row:2           Mon
    ## 27      Col:text Row:6        Parker
    ## 28     Col:text Row:13          Ross
    ## 29     Col:text Row:14          Ross
    ## 30     Col:text Row:15          Ross
    ## 31     Col:text Row:19      Chandler
    ## 32     Col:text Row:19        Monica
    ## 33     Col:text Row:21           Sob
    ## 34     Col:text Row:23           Chi
    ## 35     Col:text Row:23           Chi
    ## 36     Col:text Row:26          Ross
    ## 37     Col:text Row:26          Joey
    ## 38     Col:text Row:26        Rachel
    ## 39     Col:text Row:33         Karma
    ## 40     Col:text Row:33         Sutra
    ## 41     Col:text Row:36           Chi
    ## 42     Col:text Row:36        Y'know
    ## 43     Col:text Row:36        Monica
    ## 44     Col:text Row:36           Chi
    ## 45     Col:text Row:36           Chi
    ## 46     Col:text Row:39        Phoebe
    ## 47     Col:text Row:39        Parker
    ## 48     Col:text Row:42        Parker
    ## 49     Col:text Row:42        Parker
    ## 50     Col:text Row:43          Joey
    ## 51     Col:text Row:43        Monica
    ## 52     Col:text Row:43          Ross
    ## 53     Col:text Row:43        Rachel
    ## 54     Col:text Row:43        Phoebe
    ## 55     Col:text Row:43      Chandler
    ## 56     Col:text Row:44            Ha
    ## 57     Col:text Row:47       Classic
    ## 58     Col:text Row:47          Ross
    ## 59     Col:text Row:47        Rachel
    ## 60     Col:text Row:47        Rachel
    ## 61     Col:text Row:49        Rachel
    ## 62     Col:text Row:52    Massapequa
    ## 63     Col:text Row:53 Maaaassapequa
    ## 64     Col:text Row:53         About
    ## 65     Col:text Row:53    Massapequa
    ## 66     Col:text Row:54          Arby
    ## 67     Col:text Row:61          Ross
    ## 68     Col:text Row:61        Rachel
    ## 69     Col:text Row:64            Ya
    ## 70     Col:text Row:66   Anniversary
    ## 71     Col:text Row:66         Party
    ## 72     Col:text Row:66          Ross
    ## 73     Col:text Row:66        Rachel
    ## 74     Col:text Row:70          Jack
    ## 75     Col:text Row:77           Wha
    ## 76     Col:text Row:82           Son
    ## 77     Col:text Row:87          Ross
    ## 78     Col:text Row:88        Rachel
    ## 79     Col:text Row:89          Aunt
    ## 80     Col:text Row:89          Lisa
    ## 81     Col:text Row:89         Uncle
    ## 82     Col:text Row:89           Dan
    ## 83     Col:text Row:98        Parker
    ## 84    Col:text Row:103        Dahaaa
    ## 85    Col:text Row:109          Long
    ## 86    Col:text Row:109        Island
    ## 87    Col:text Row:109    Expressway
    ## 88    Col:text Row:111        Parker
    ## 89    Col:text Row:115           Tag
    ## 90    Col:text Row:115        Janice
    ## 91    Col:text Row:115          Mona
    ## 92    Col:text Row:118          Mona
    ## 93    Col:text Row:119   Anniversary
    ## 94    Col:text Row:119         Party
    ## 95    Col:text Row:119          Ross
    ## 96    Col:text Row:119        Rachel
    ## 97    Col:text Row:127      Barbados
    ## 98    Col:text Row:127        Stevie
    ## 99    Col:text Row:129        Stevie
    ## 100   Col:text Row:130           God
    ## 101   Col:text Row:131         Annie
    ## 102   Col:text Row:131     Liebawitz
    ## 103   Col:text Row:134        Harley
    ## 104   Col:text Row:135          Ross
    ## 105   Col:text Row:136        Phoebe
    ## 106   Col:text Row:136        Parker
    ## 107   Col:text Row:150        Monica
    ## 108   Col:text Row:150      Chandler
    ## 109   Col:text Row:153            Ya
    ## 110   Col:text Row:154        Rachel
    ## 111   Col:text Row:154          Ross
    ## 112   Col:text Row:155       Belgium
    ## 113   Col:text Row:156         Blind
    ## 114   Col:text Row:165          Fred
    ## 115   Col:text Row:165       Astaire
    ## 116   Col:text Row:165           Way
    ## 117   Col:text Row:165       Tonight
    ## 118   Col:text Row:168        Phoebe
    ## 119   Col:text Row:168          Joey
    ## 120   Col:text Row:169        Phoebe
    ## 121   Col:text Row:169        Parker
    ## 122   Col:text Row:174        Geller
    ## 123   Col:text Row:177      Chandler
    ## 124   Col:text Row:186        Parker
    ## 125   Col:text Row:191        Monica
    ## 126   Col:text Row:192          Ross
    ## 127   Col:text Row:194          Nana
    ## 128   Col:text Row:194           Chi
    ## 129   Col:text Row:194           Was
    ## 130   Col:text Row:194          Nana
    ## 131   Col:text Row:194          gone
    ## 132   Col:text Row:194         Debra
    ## 133   Col:text Row:194        Winger
    ## 134   Col:text Row:194       Minutes
    ## 135   Col:text Row:194       Romania
    ## 136   Col:text Row:195        Monica
    ## 137   Col:text Row:195          Jack
    ## 138   Col:text Row:197          Ross
    ## 139   Col:text Row:198        Monica
    ## 140   Col:text Row:200            Um
    ## 141   Col:text Row:200        Rachel
    ## 142   Col:text Row:201          Ross
    ## 143   Col:text Row:202          Nana
    ## 144   Col:text Row:202          Ross
    ## 145   Col:text Row:203        Phoebe
    ## 146   Col:text Row:203        Parker
    ## 147   Col:text Row:205        Valium
    ## 148   Col:text Row:207           God
    ## 149   Col:text Row:208          Eden
    ## 150   Col:text Row:210           God
    ## 151   Col:text Row:214         Jenga
    ## 152   Col:text Row:217         Jenga
    ## 153   Col:text Row:218           God
    ## 154   Col:text Row:218           God
    ## 155   Col:text Row:220         Wrong
    ## 156   Col:text Row:220        Parker
    ## 157   Col:text Row:224         Santa
    ## 158   Col:text Row:224        Clause
    ## 159   Col:text Row:224        Prozac
    ## 160   Col:text Row:224    Disneyland
    ## 161   Col:text Row:227          Ross
    ## 162   Col:text Row:229        Phoebe
    ## 163   Col:text Row:232          Ross
    ## 164   Col:text Row:232        Rachel
    ## 165   Col:text Row:234          Ross
    ## 166   Col:text Row:238          Ross
    ## 167   Col:text Row:251       Central
    ## 168   Col:text Row:251          Perk
    ## 169   Col:text Row:251          Ross
    ## 170   Col:text Row:251        Monica
    ## 171   Col:text Row:255           Chi
    ## 172   Col:text Row:255           Chi
    ## 173   Col:text Row:255          Nana
    ## 174   Col:text Row:256           God
    ## 175   Col:text Row:256          Ross
    ## 176   Col:text Row:257           End
    ##                                                                                                                                        Sentence
    ## 1                                                                                                                                 Phoebe Buffay
    ## 2                                                                                                                                 Phoebe Buffay
    ## 3                                                                                                                                 Monica Geller
    ## 4                                                                                                                                 Monica Geller
    ## 5                                                                                                                                   Ross Geller
    ## 6                                                                                                                                   Ross Geller
    ## 7                                                                                                                                Joey Tribbiani
    ## 8                                                                                                                                Joey Tribbiani
    ## 9                                                                                                                                      Chandler
    ## 10                                                                                                                                         Bing
    ## 11                                                                                                                                 Rachel Green
    ## 12                                                                                                                                 Rachel Green
    ## 13                                                                                                                                       Parker
    ## 14                                                                                                                                           NA
    ## 15                                                                                                                                  Judy Geller
    ## 16                                                                                                                                  Judy Geller
    ## 17                                                                                                                                  Jack Geller
    ## 18                                                                                                                                  Jack Geller
    ## 19                                                                                                                                        Woman
    ## 20                                                                                                                                    Aunt Lisa
    ## 21                                                                                                                                    Aunt Lisa
    ## 22                                                                                                                                    Uncle Dan
    ## 23                                                                                                    [Scene: Central Perk, everyone is there.]
    ## 24                                                                                                    [Scene: Central Perk, everyone is there.]
    ## 25                                                             Oh, Ross, Mon, is it okay if I bring someone to your parent's anniversary party?
    ## 26                                                             Oh, Ross, Mon, is it okay if I bring someone to your parent's anniversary party?
    ## 27                                                                                   Well, his name is Parker and I met him at the drycleaners.
    ## 28                                                   Every year Ross makes the toast, and it's always really moving, and always makes them cry.
    ## 29                                                                                                   And you wonder why Ross is their favorite?
    ## 30  Any time Ross makes a toast everyone cries, and hugs him, and pats him on the back and they all come up to me and say, "God, your brother."
    ## 31                                                                [Scene: Chandler and Monica's, they're getting ready to leave for the party.]
    ## 32                                                                [Scene: Chandler and Monica's, they're getting ready to leave for the party.]
    ## 33                                                                                                                               Sob fest 2002.
    ## 34                                                                                          That's Chi-Chi; she died when I was in high school.
    ## 35                                                                                          That's Chi-Chi; she died when I was in high school.
    ## 36                                                                                                               (Ross, Joey, and Rachel enter)
    ## 37                                                                                                               (Ross, Joey, and Rachel enter)
    ## 38                                                                                                               (Ross, Joey, and Rachel enter)
    ## 39                                                                                        And I got them a book on Karma Sutra for the elderly.
    ## 40                                                                                        And I got them a book on Karma Sutra for the elderly.
    ## 41                                                                                                                                     Chi-Chi!
    ## 42                                                                       Y'know Monica couldn't get braces because Chi-Chi needed knee surgery.
    ## 43                                                                       Y'know Monica couldn't get braces because Chi-Chi needed knee surgery.
    ## 44                                                                       Y'know Monica couldn't get braces because Chi-Chi needed knee surgery.
    ## 45                                                                       Y'know Monica couldn't get braces because Chi-Chi needed knee surgery.
    ## 46                                                                                                                    (Phoebe and Parker enter)
    ## 47                                                                                                                    (Phoebe and Parker enter)
    ## 48                                                                                                 Everybody, this is Parker, Parker this is...
    ## 49                                                                                                 Everybody, this is Parker, Parker this is...
    ## 50                                                                                                                          Joey, Monica, Ross,
    ## 51                                                                                                                          Joey, Monica, Ross,
    ## 52                                                                                                                          Joey, Monica, Ross,
    ## 53                                                                                             Rachel and, I'm sorry Phoebe didn't mention you.
    ## 54                                                                                             Rachel and, I'm sorry Phoebe didn't mention you.
    ## 55                                                                                                                                    Chandler,
    ## 56                                                                                                                                          Ha!
    ## 57                                                                                                                                Classic Ross.
    ## 58                                                                                                                                Classic Ross.
    ## 59                                                                                                                                      Rachel,
    ## 60                                                                                                                     Rachel, oh how you glow.
    ## 61                                                                                                    Rachel, you have life growing inside you.
    ## 62                                                                                                                          It's in Massapequa.
    ## 63                                                                                                  Maaaassapequa, Sounds Like A Magical Place.
    ## 64                                                                            Tell Me About Massapequa, Is It Steep In Native American History?
    ## 65                                                                            Tell Me About Massapequa, Is It Steep In Native American History?
    ## 66                                                                                          Well, there is an Arby's in the shape of a tee-pee.
    ## 67                                                                                                     (Everyone except Ross and Rachel leave.)
    ## 68                                                                                                     (Everyone except Ross and Rachel leave.)
    ## 69                                                                                                     Ya wanna hang back and take our own cab?
    ## 70                                                            [Scene: The Anniversary Party, Ross and Rachel are arriving and see his parents.]
    ## 71                                                            [Scene: The Anniversary Party, Ross and Rachel are arriving and see his parents.]
    ## 72                                                            [Scene: The Anniversary Party, Ross and Rachel are arriving and see his parents.]
    ## 73                                                            [Scene: The Anniversary Party, Ross and Rachel are arriving and see his parents.]
    ## 74                                                                                                                                        Jack?
    ## 75                                                                                                                                    Wha-What?
    ## 76                                                                                                     Son, I had to shave my ears for tonight.
    ## 77                                                                                                                                        Ross!
    ## 78                                                                                                                                      Rachel!
    ## 79                                                                                                                     Hi Aunt Lisa, Uncle Dan.
    ## 80                                                                                                                     Hi Aunt Lisa, Uncle Dan.
    ## 81                                                                                                                     Hi Aunt Lisa, Uncle Dan.
    ## 82                                                                                                                     Hi Aunt Lisa, Uncle Dan.
    ## 83                                                                                             (The rest of the gang arrives including Parker.)
    ## 84                                                                                                                                      Dahaaa!
    ## 85                                                                                     He called the Long Island Expressway a concrete miracle.
    ## 86                                                                                     He called the Long Island Expressway a concrete miracle.
    ## 87                                                                                     He called the Long Island Expressway a concrete miracle.
    ## 88                                                                                                          Were you guys making fun of Parker?
    ## 89                                                                                                                           Tag, Janice, Mona?
    ## 90                                                                                                                           Tag, Janice, Mona?
    ## 91                                                                                                                           Tag, Janice, Mona?
    ## 92                                                                                                                    What was wrong with Mona?
    ## 93                                                    [Scene: The Anniversary Party, Ross and Rachel have just gotten another wedding present.]
    ## 94                                                    [Scene: The Anniversary Party, Ross and Rachel have just gotten another wedding present.]
    ## 95                                                    [Scene: The Anniversary Party, Ross and Rachel have just gotten another wedding present.]
    ## 96                                                    [Scene: The Anniversary Party, Ross and Rachel have just gotten another wedding present.]
    ## 97                                      On a cliff, in Barbados, at sunset, and Stevie Wonder sang Isn't She Lovely as I walked down the aisle.
    ## 98                                      On a cliff, in Barbados, at sunset, and Stevie Wonder sang Isn't She Lovely as I walked down the aisle.
    ## 99                                                                                                         Yeah, Stevie's an old family friend.
    ## 100                                                                                                                                  Oh my God.
    ## 101                                                             You wouldn't think that Annie Liebawitz would forget to put film in the camera.
    ## 102                                                             You wouldn't think that Annie Liebawitz would forget to put film in the camera.
    ## 103                                                                                                     Ooooh, ooh maybe I rode in on a Harley.
    ## 104                                                                                                         Okay, Ross, it has to be realistic.
    ## 105                                                                                                                  (Cut to Phoebe and Parker)
    ## 106                                                                                                                  (Cut to Phoebe and Parker)
    ## 107                                                                                                                (Cut to Monica and Chandler)
    ## 108                                                                                                                (Cut to Monica and Chandler)
    ## 109                                                                           Ya know if you want to, I can just hold them down and you could .
    ## 110                                                                                                                    (Cut to Rachel and Ross)
    ## 111                                                                                                                    (Cut to Rachel and Ross)
    ## 112                                                                                          And my veil was lace, made by blind, Belgium nuns.
    ## 113                                                                                                                                      Blind?
    ## 114                                     Then, Fred Astaire singing The Way You Look Tonight came on the sound system, and the lights came down.
    ## 115                                     Then, Fred Astaire singing The Way You Look Tonight came on the sound system, and the lights came down.
    ## 116                                     Then, Fred Astaire singing The Way You Look Tonight came on the sound system, and the lights came down.
    ## 117                                     Then, Fred Astaire singing The Way You Look Tonight came on the sound system, and the lights came down.
    ## 118                                                                                                                    (Cut to Phoebe and Joey)
    ## 119                                                                                                                    (Cut to Phoebe and Joey)
    ## 120                                                                                                                            Yeah uh, Phoebe!
    ## 121                                                                                        Parker's a nice guy and I'd like to get to know him.
    ## 122                                                                  I mean I'm all for living life, but this is the Geller's 35th anniversary.
    ## 123                                                                   Y'know, I just wiped it on Chandler's coat and got the hell out of there.
    ## 124                                                                                                                        Oh look it's Parker!
    ## 125                                                                                                          (Cut to Monica, at the microphone)
    ## 126                                                    Umm now-now, I know that Ross usually gives the toast, but this year I'm going to do it.
    ## 127                                                Nana, my beloved grandmother who would so want to be here, but she can't because she's dead.
    ## 128                                                                                                                      As is our dog Chi-Chi.
    ## 129                                                                                                         I mean look how cute she is. . Was.
    ## 130                                                                                                                   Okay, her and Nana, gone.
    ## 131                                                                                                                   Okay, her and Nana, gone.
    ## 132                                      Hey does anybody remember when Debra Winger had to say goodbye to her children in Terms of Endearment?
    ## 133                                      Hey does anybody remember when Debra Winger had to say goodbye to her children in Terms of Endearment?
    ## 134                  The other day I was watching 60 Minutes these orphans in Romania, who have been so neglected, they were incapable of love.
    ## 135                  The other day I was watching 60 Minutes these orphans in Romania, who have been so neglected, they were incapable of love.
    ## 136                                                                                                  Thank you Monica that was uh, interesting.
    ## 137                                                                                                                Wasn't it interesting, Jack?
    ## 138                                                                                                 Ross, why don't you give us your toast now?
    ## 139                                                                                                    Oh, no, Mom, it's just Monica this year.
    ## 140                                                                                                                        No, of course, Um...
    ## 141                                                                Um, I-I just wanted to say...on behalf of my new bride, Rachel , and myself.
    ## 142                                                                                                                                  Oh Ross...
    ## 143                                                                                           I just wish Nana were alive to hear Ross's toast.
    ## 144                                                                                           I just wish Nana were alive to hear Ross's toast.
    ## 145                                                                                   [Scene: Phoebe's apartment, Parker and her are entering.]
    ## 146                                                                                   [Scene: Phoebe's apartment, Parker and her are entering.]
    ## 147                                                                                                                    Like a water and Valium?
    ## 148                                                                                                                               Oh thank God.
    ## 149                                                                                                           A modern-day Eden in the midst...
    ## 150                                                               My God this is the most comfortable couch I've ever sat on in my entire life.
    ## 151                                                                                                                                 Or...Jenga.
    ## 152                                                                                                                          I lose, now Jenga.
    ## 153                                                                                                                                  Oh my God!
    ## 154                                                                                                                                  Oh my God!
    ## 155                                                                                                                                      Wrong?
    ## 156                                                                                                        They were just brake lights, Parker!
    ## 157                                                                           You are like Santa Clause on Prozac, at Disneyland, getting laid!
    ## 158                                                                           You are like Santa Clause on Prozac, at Disneyland, getting laid!
    ## 159                                                                           You are like Santa Clause on Prozac, at Disneyland, getting laid!
    ## 160                                                                           You are like Santa Clause on Prozac, at Disneyland, getting laid!
    ## 161                                                                                             Well then to quote Ross, "I'd better be going."
    ## 162                                                                                             (There's a knock on door, and Phoebe opens it.)
    ## 163                                                                               [Scene: Ross and Rachel's, they're returning from the party.]
    ## 164                                                                               [Scene: Ross and Rachel's, they're returning from the party.]
    ## 165                                                                                                  Ross, it just wouldn't have been feasible.
    ## 166                                                                                               Okay Ross, can I uh, can I ask you something?
    ## 167                                                                                           [Scene: Central Perk, Ross and Monica are there.]
    ## 168                                                                                           [Scene: Central Perk, Ross and Monica are there.]
    ## 169                                                                                           [Scene: Central Perk, Ross and Monica are there.]
    ## 170                                                                                           [Scene: Central Perk, Ross and Monica are there.]
    ## 171                                                                                      And that picture of Chi-Chi with her mischievous grin.
    ## 172                                                                                      And that picture of Chi-Chi with her mischievous grin.
    ## 173                                                                                                               And what you said about Nana.
    ## 174                                                                                                                          Oh good God, Ross!
    ## 175                                                                                                                          Oh good God, Ross!
    ## 176                                                                                                                                         End
    ##     Repeats Affected Columns
    ## 1        40        `speaker`
    ## 2        40        `speaker`
    ## 3        25        `speaker`
    ## 4        25        `speaker`
    ## 5        43        `speaker`
    ## 6        43        `speaker`
    ## 7        17        `speaker`
    ## 8        17        `speaker`
    ## 9        12        `speaker`
    ## 10       12        `speaker`
    ## 11       33        `speaker`
    ## 12       33        `speaker`
    ## 13       33        `speaker`
    ## 14        3        `speaker`
    ## 15        7        `speaker`
    ## 16        7        `speaker`
    ## 17        4        `speaker`
    ## 18        4        `speaker`
    ## 19        8        `speaker`
    ## 20        5        `speaker`
    ## 21        5        `speaker`
    ## 22        1        `speaker`
    ## 23        1           `text`
    ## 24        1           `text`
    ## 25        1           `text`
    ## 26        1           `text`
    ## 27        1           `text`
    ## 28        1           `text`
    ## 29        1           `text`
    ## 30        1           `text`
    ## 31        1           `text`
    ## 32        1           `text`
    ## 33        1           `text`
    ## 34        1           `text`
    ## 35        1           `text`
    ## 36        1           `text`
    ## 37        1           `text`
    ## 38        1           `text`
    ## 39        1           `text`
    ## 40        1           `text`
    ## 41        1           `text`
    ## 42        1           `text`
    ## 43        1           `text`
    ## 44        1           `text`
    ## 45        1           `text`
    ## 46        1           `text`
    ## 47        1           `text`
    ## 48        1           `text`
    ## 49        1           `text`
    ## 50        1           `text`
    ## 51        1           `text`
    ## 52        1           `text`
    ## 53        1           `text`
    ## 54        1           `text`
    ## 55        1           `text`
    ## 56        1           `text`
    ## 57        1           `text`
    ## 58        1           `text`
    ## 59        1           `text`
    ## 60        1           `text`
    ## 61        1           `text`
    ## 62        1           `text`
    ## 63        1           `text`
    ## 64        1           `text`
    ## 65        1           `text`
    ## 66        1           `text`
    ## 67        1           `text`
    ## 68        1           `text`
    ## 69        1           `text`
    ## 70        1           `text`
    ## 71        1           `text`
    ## 72        1           `text`
    ## 73        1           `text`
    ## 74        1           `text`
    ## 75        1           `text`
    ## 76        1           `text`
    ## 77        1           `text`
    ## 78        1           `text`
    ## 79        1           `text`
    ## 80        1           `text`
    ## 81        1           `text`
    ## 82        1           `text`
    ## 83        1           `text`
    ## 84        1           `text`
    ## 85        1           `text`
    ## 86        1           `text`
    ## 87        1           `text`
    ## 88        1           `text`
    ## 89        1           `text`
    ## 90        1           `text`
    ## 91        1           `text`
    ## 92        1           `text`
    ## 93        1           `text`
    ## 94        1           `text`
    ## 95        1           `text`
    ## 96        1           `text`
    ## 97        1           `text`
    ## 98        1           `text`
    ## 99        1           `text`
    ## 100       1           `text`
    ## 101       1           `text`
    ## 102       1           `text`
    ## 103       1           `text`
    ## 104       1           `text`
    ## 105       1           `text`
    ## 106       1           `text`
    ## 107       1           `text`
    ## 108       1           `text`
    ## 109       1           `text`
    ## 110       1           `text`
    ## 111       1           `text`
    ## 112       1           `text`
    ## 113       1           `text`
    ## 114       1           `text`
    ## 115       1           `text`
    ## 116       1           `text`
    ## 117       1           `text`
    ## 118       1           `text`
    ## 119       1           `text`
    ## 120       1           `text`
    ## 121       1           `text`
    ## 122       1           `text`
    ## 123       1           `text`
    ## 124       1           `text`
    ## 125       1           `text`
    ## 126       1           `text`
    ## 127       1           `text`
    ## 128       1           `text`
    ## 129       1           `text`
    ## 130       1           `text`
    ## 131       1           `text`
    ## 132       1           `text`
    ## 133       1           `text`
    ## 134       1           `text`
    ## 135       1           `text`
    ## 136       1           `text`
    ## 137       1           `text`
    ## 138       1           `text`
    ## 139       1           `text`
    ## 140       1           `text`
    ## 141       1           `text`
    ## 142       1           `text`
    ## 143       1           `text`
    ## 144       1           `text`
    ## 145       1           `text`
    ## 146       1           `text`
    ## 147       1           `text`
    ## 148       1           `text`
    ## 149       1           `text`
    ## 150       1           `text`
    ## 151       1           `text`
    ## 152       1           `text`
    ## 153       1           `text`
    ## 154       1           `text`
    ## 155       1           `text`
    ## 156       1           `text`
    ## 157       1           `text`
    ## 158       1           `text`
    ## 159       1           `text`
    ## 160       1           `text`
    ## 161       1           `text`
    ## 162       1           `text`
    ## 163       1           `text`
    ## 164       1           `text`
    ## 165       1           `text`
    ## 166       1           `text`
    ## 167       1           `text`
    ## 168       1           `text`
    ## 169       1           `text`
    ## 170       1           `text`
    ## 171       1           `text`
    ## 172       1           `text`
    ## 173       1           `text`
    ## 174       1           `text`
    ## 175       1           `text`
    ## 176       1           `text`

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
to the function `report_as_rules_template` which will convert the report
to a csv file with three headings:

-   `If` - the sentence pattern which, if it matches, the replacement is
    applied
-   `From` - the pattern to be replaced
-   `To` - the intended replacement

``` r
report_as_rules_template(report, path='path/to/report.csv')
```

The csv file is intended to be edited by the data controller, who hence
does not need to understand R, and can be reimported using the
`template_to_rules` function:

``` r
template_to_rules('path/to/report.csv')
```

The `template_to_rules` function creates a string replacement rule to
capture the desired redactions, with the option for R to ‘parse’ the
function for use as part of a data pipeline:

``` r
replacement.func <- template_to_rules('path/to/report.csv', parse=T)

the_one_in_massapequa |>
  mutate(
    across(
      where(is.character),
      replacement.func
    )
  )
```

For a more advanced user, the `template_to_rules` function utilizes the
`str_detect` and `str_replace_all` functions from the `stringr` package,
and hence supports regex.

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
