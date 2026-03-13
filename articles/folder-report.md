# Reporting on every file in a folder

## The `PID.POS` report

A common struggle in research is how data controllers can gain some
level of confidence that large data sets don’t contain personally
identifiable data. In some cases, this job only requires a brief
inspection and columns that often contain PID such as name, or ID are
obvious. However, data sets can contain broad free text fields, fields
that are only needed in a small number of cases, or may have been
shifted - placing PID in harder to detect locations. If the data sets
consist of ~10,000 or more observations manual inspection of rare PID
has only a limited chance of finding problems, let alone the resource
cost required to do any pass of the data.

To help overcome these issues, as part of the `PID.POS` package we have
implemented an API for the automated production of proper noun reports
on all files found within the same directory. The intention is that
should a collection of data sets be required for transfer, they can be
placed in a single location, and the reports generated.

To demonstrate how this function works - we have supplied a collection
of data sets featuring free text with the package. The free text data
draws on the `friends` package - containing the scripts for three
episodes of season 8:

- `The One After 'I DO'.csv`
- `The One Where Rachel Tells.csv`
- `The One with the Red Sweater.csv`

With each file consisting of 6 columns:

With each file consisting of 6 columns:

- `text` - The line of the script (dialogue or action)
- `speaker` - The character uttering the line
- `season` - Numeric ID of which season the episode was in
- `episode` - Numeric ID of which episode the dialogue was in
- `scene`
- `utterance`

``` r
library(pid.pos)

data_path <- system.file("vignette_data", package = "pid.pos")
list.files(data_path)
#> [1] "The_One_After_I_Do.csv"           "The_One_Where_Rachel_Tells.csv"  
#> [3] "The_One_with_the_Red_Sweater.csv"
```

and we check the files are the intended data:

``` r
rachell_tells <- system.file("vignette_data", "The_One_Where_Rachel_Tells.csv", package = "pid.pos")
rachell <- read.csv(rachell_tells, nrows = 5)
```

To generate reports we call `report_on_folder` which has two key
arguments:

- `data_path` - the path to the data directory
- `report_dir` - \[optional\] a system path to where the proper noun
  reports should be saved

``` r
report_on_folder(data_path, report_dir = "Proper Noun Report")
```

Once evaluated the `report_dir` folder gets populated by a set of csv
files, one per data set found at `data_path`:

``` r
browseURL("Proper Noun Report")
```

Each of these files consists of 6 columns:

- `ID` - a reference of where the proper noun was detected
- `Token` - the proper noun detected
- `Sentence` - the sentence containing proper nouns
- `Document` - the full document `Sentence` occurs in.
- `Repeats` - how many times `Document` appeared in the data set
- `Affected Columns` - all the columns that `Document` occurred in.

``` r
read.csv("Proper Noun Report/The_One_Where_Rachel_Tells.csv")
```

    #>                      ID     Token
    #> 1        Col:text Row:1    Monica
    #> 2        Col:text Row:1  Chandler
    #> 3        Col:text Row:1    Monica
    #> 4        Col:text Row:1  Chandler
    #> 5        Col:text Row:1    Monica
    #> 6        Col:text Row:2      Babe
    #> 7     Col:speaker Row:2  Chandler
    #> 8     Col:speaker Row:2      Bing
    #> 9     Col:speaker Row:3    Monica
    #> 10    Col:speaker Row:3    Geller
    #> 11       Col:text Row:4   Bermuda
    #> 12       Col:text Row:4    Bahama
    #> 13    Col:speaker Row:6      Joey
    #> 14    Col:speaker Row:6 Tribbiani
    #> 15    Col:speaker Row:7    Phoebe
    #> 16    Col:speaker Row:7    Buffay
    #> 17      Col:text Row:10      Joey
    #> 18      Col:text Row:10    Phoebe
    #> 19      Col:text Row:10  Chandler
    #> 20   Col:speaker Row:12    Rachel
    #> 21   Col:speaker Row:12     Green
    #> 22      Col:text Row:20       God
    #> 23      Col:text Row:21      Ross
    #> 24      Col:text Row:28      Ross
    #> 25      Col:text Row:36    Rachel
    #> 26      Col:text Row:38    Rachel
    #> 27      Col:text Row:38      Ross
    #> 28      Col:text Row:47      Joey
    #> 29      Col:text Row:47    Rachel
    #> 30      Col:text Row:47      Joey
    #> 31      Col:text Row:47    Phoebe
    #> 32      Col:text Row:49    Monica
    #> 33      Col:text Row:49  Chandler
    #> 34      Col:text Row:49      Ross
    #> 35      Col:text Row:49    Rachel
    #> 36      Col:text Row:56    Monica
    #> 37      Col:text Row:63    Monica
    #> 38      Col:text Row:63       Mr.
    #> 39      Col:text Row:63   Treeger
    #> 40      Col:text Row:63      Joey
    #> 41      Col:text Row:63 Tribbiani
    #> 42      Col:text Row:63    Listen
    #> 43      Col:text Row:63    Monica
    #> 44      Col:text Row:63  Chandler
    #> 45   Col:speaker Row:64      Ross
    #> 46   Col:speaker Row:64    Geller
    #> 47      Col:text Row:65    Rachel
    #> 48      Col:text Row:74    Phoebe
    #> 49      Col:text Row:74      Joey
    #> 50      Col:text Row:76    Rachel
    #> 51      Col:text Row:86    Rachel
    #> 52      Col:text Row:88   Airport
    #> 53      Col:text Row:88    Ticket
    #> 54      Col:text Row:88   Counter
    #> 55      Col:text Row:88    Monica
    #> 56      Col:text Row:88  Chandler
    #> 57   Col:speaker Row:89    Ticket
    #> 58   Col:speaker Row:89     Agent
    #> 59   Col:speaker Row:97     Woman
    #> 60     Col:text Row:105       Mr.
    #> 61     Col:text Row:105      Bing
    #> 62     Col:text Row:105         J
    #> 63     Col:text Row:105       Mrs
    #> 64     Col:text Row:108    Damnit
    #> 65     Col:text Row:110      Joey
    #> 66     Col:text Row:110    Rachel
    #> 67     Col:text Row:110    Phoebe
    #> 68     Col:text Row:110      Joey
    #> 69     Col:text Row:110      Sock
    #> 70     Col:text Row:110       'em
    #> 71     Col:text Row:110    Robots
    #> 72     Col:text Row:115       Mr.
    #> 73     Col:text Row:115   Treeger
    #> 74     Col:text Row:115       New
    #> 75     Col:text Row:115      York
    #> 76     Col:text Row:115    Monica
    #> 77     Col:text Row:115  Chandler
    #> 78     Col:text Row:116      Whoa
    #> 79     Col:text Row:116      Whoa
    #> 80     Col:text Row:116      Whoa
    #> 81     Col:text Row:116   Treeger
    #> 82  Col:speaker Row:117       Mr.
    #> 83  Col:speaker Row:117   Treeger
    #> 84     Col:text Row:122   Airport
    #> 85     Col:text Row:122  Chandler
    #> 86     Col:text Row:122    Monica
    #> 87     Col:text Row:127       God
    #> 88     Col:text Row:129        Uh
    #> 89  Col:speaker Row:129   Airline
    #> 90  Col:speaker Row:129  Employee
    #> 91     Col:text Row:133       Sir
    #> 92     Col:text Row:134   Apology
    #> 93     Col:text Row:135       Sir
    #> 94     Col:text Row:137   Hallway
    #> 95     Col:text Row:137   Outside
    #> 96     Col:text Row:137      Ross
    #> 97     Col:text Row:137 Apartment
    #> 98     Col:text Row:137      Ross
    #> 99     Col:text Row:137    Rachel
    #> 100    Col:text Row:145      Ross
    #> 101    Col:text Row:145    Rachel
    #> 102    Col:text Row:145    Rachel
    #> 103    Col:text Row:145      Ross
    #> 104    Col:text Row:152      Ross
    #> 105    Col:text Row:152      Ross
    #> 106    Col:text Row:153      Ross
    #> 107    Col:text Row:153 Apartment
    #> 108    Col:text Row:156      Ross
    #> 109    Col:text Row:162      Ross
    #> 110    Col:text Row:164    Listen
    #> 111    Col:text Row:172    Monica
    #> 112    Col:text Row:172  Chandler
    #> 113    Col:text Row:172       Mr.
    #> 114    Col:text Row:172   Treeger
    #> 115    Col:text Row:172    Monica
    #> 116    Col:text Row:172  Chandler
    #> 117    Col:text Row:176  Chandler
    #> 118    Col:text Row:176    Monica
    #> 119    Col:text Row:179      Whoa
    #> 120    Col:text Row:179      Ross
    #> 121    Col:text Row:181   Jasmine
    #> 122    Col:text Row:183   Namaste
    #> 123    Col:text Row:185      Ross
    #> 124    Col:text Row:186       God
    #> 125    Col:text Row:188    Rachel
    #> 126    Col:text Row:190    Rachel
    #> 127    Col:text Row:190    Rachel
    #> 128    Col:text Row:191       God
    #> 129    Col:text Row:192       God
    #> 130    Col:text Row:201      Ross
    #> 131    Col:text Row:205      Whoa
    #> 132    Col:text Row:208  Atlantis
    #> 133    Col:text Row:208    Resort
    #> 134    Col:text Row:208  Chandler
    #> 135    Col:text Row:208    Monica
    #> 136 Col:speaker Row:212     Front
    #> 137 Col:speaker Row:212      Desk
    #> 138 Col:speaker Row:212     Clerk
    #> 139    Col:text Row:219    Monica
    #> 140    Col:text Row:219  Chandler
    #> 141    Col:text Row:219      Joey
    #> 142    Col:text Row:219    Phoebe
    #> 143    Col:text Row:220    Monica
    #> 144    Col:text Row:220      Joey
    #> 145    Col:text Row:220    Listen
    #> 146    Col:text Row:220        uh
    #> 147    Col:text Row:220    Phoebe
    #> 148    Col:text Row:221      Joey
    #> 149    Col:text Row:231    Rachel
    #> 150    Col:text Row:232      Okay
    #> 151    Col:text Row:232    Rachel
    #> 152    Col:text Row:243      Rach
    #> 153    Col:text Row:244      Head
    #> 154    Col:text Row:244      Ross
    #> 155    Col:text Row:244      Head
    #> 156    Col:text Row:244      Ross
    #> 157    Col:text Row:244      Head
    #> 158    Col:text Row:244      Ross
    #> 159    Col:text Row:250      Ross
    #> 160    Col:text Row:253      Rach
    #> 161    Col:text Row:261    Monica
    #> 162 Col:speaker Row:262        Dr
    #> 163 Col:speaker Row:262      Long
    #> 164    Col:text Row:263       Dr.
    #> 165    Col:text Row:263      Long
    #> 166    Col:text Row:263      Ross
    #> 167    Col:text Row:269       God
    #> 168    Col:text Row:274       Dr.
    #> 169    Col:text Row:274      Long
    #> 170    Col:text Row:274     exits
    #> 171    Col:text Row:274    Rachel
    #> 172    Col:text Row:292      Joey
    #> 173    Col:text Row:292    Rachel
    #> 174    Col:text Row:292      Joey
    #> 175    Col:text Row:292    Phoebe
    #> 176    Col:text Row:292    Rachel
    #> 177    Col:text Row:292      Ross
    #> 178    Col:text Row:302      Ross
    #>                                                                                                                                                                                                                Sentence
    #> 1                                                                                                                        [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon.
    #> 2                                                                                                                        [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon.
    #> 3                                                                                                                        [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon.
    #> 4                                                                                                                        [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon.
    #> 5                                                                                                                                                                                 Monica is entering from the bedroom.]
    #> 6                                                                                                                                                                                                                 Babe!
    #> 7                                                                                                                                                                                                              Chandler
    #> 8                                                                                                                                                                                                                  Bing
    #> 9                                                                                                                                                                                                         Monica Geller
    #> 10                                                                                                                                                                                                        Monica Geller
    #> 11                                                                                                                                                                              Bermuda, Bahama, come on pretty mama...
    #> 12                                                                                                                                                                              Bermuda, Bahama, come on pretty mama...
    #> 13                                                                                                                                                                                                       Joey Tribbiani
    #> 14                                                                                                                                                                                                       Joey Tribbiani
    #> 15                                                                                                                                                                                                        Phoebe Buffay
    #> 16                                                                                                                                                                                                        Phoebe Buffay
    #> 17                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 18                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 19                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 20                                                                                                                                                                                                         Rachel Green
    #> 21                                                                                                                                                                                                         Rachel Green
    #> 22                                                                                                                                                                                   It was his sweater, but-Oh my God!
    #> 23                                                                                                                                               Oh, I so wanted Ross to know first, but I'm so relieved you guys know.
    #> 24                                                                                                                                                                      Give me some advice on how I'm gonna tell Ross!
    #> 25                                                                                                                                                                                                      (Rachel exits.)
    #> 26                                                                                                                             Well I guess there is no harm in telling you now, Rachel and Ross are gonna have a baby.
    #> 27                                                                                                                             Well I guess there is no harm in telling you now, Rachel and Ross are gonna have a baby.
    #> 28                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 29                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 30                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 31                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 32                                                                                                                                                                             Y'know, Monica and Chandler are married.
    #> 33                                                                                                                                                                             Y'know, Monica and Chandler are married.
    #> 34                                                                                                                                                                                   Ross and Rachel are having a baby.
    #> 35                                                                                                                                                                                   Ross and Rachel are having a baby.
    #> 36                                                                                                                         You mean the time you broke the ketchup bottle and cleaned it up with Monica's guest towels?
    #> 37                                                                                                                                                                                               Monica's chicken parm!
    #> 38                                                                                                                                                                                Hey Mr. Treeger, it's Joey Tribbiani.
    #> 39                                                                                                                                                                                Hey Mr. Treeger, it's Joey Tribbiani.
    #> 40                                                                                                                                                                                Hey Mr. Treeger, it's Joey Tribbiani.
    #> 41                                                                                                                                                                                Hey Mr. Treeger, it's Joey Tribbiani.
    #> 42                                                                                                                                                          Listen, I need to get into Monica and Chandler's apartment.
    #> 43                                                                                                                                                          Listen, I need to get into Monica and Chandler's apartment.
    #> 44                                                                                                                                                          Listen, I need to get into Monica and Chandler's apartment.
    #> 45                                                                                                                                                                                                          Ross Geller
    #> 46                                                                                                                                                                                                          Ross Geller
    #> 47                                                                                                                                                                                                 Did Rachel find you?
    #> 48                                                                                                                                                                                        (Phoebe and Joey trade looks)
    #> 49                                                                                                                                                                                        (Phoebe and Joey trade looks)
    #> 50                                                                                                         Uh, uh we promised we weren't gonna tell anybody this but uh, about a month ago Rachel and I slept together.
    #> 51                                                                                                                                                                       Please, just-just, just go and talk to Rachel.
    #> 52                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 53                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 54                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 55                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 56                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 57                                                                                                                                                                                                         Ticket Agent
    #> 58                                                                                                                                                                                                         Ticket Agent
    #> 59                                                                                                                                                                                                                Woman
    #> 60                                                                                                                                                                             Okay, Mr. Bing you'll be in 25J and Mrs.
    #> 61                                                                                                                                                                             Okay, Mr. Bing you'll be in 25J and Mrs.
    #> 62                                                                                                                                                                             Okay, Mr. Bing you'll be in 25J and Mrs.
    #> 63                                                                                                                                                                             Okay, Mr. Bing you'll be in 25J and Mrs.
    #> 64                                                                                                                                                                                                              Damnit!
    #> 65                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 66                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 67                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 68                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 69                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 70                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 71                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 72                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 73                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 74                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 75                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 76                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 77                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 78                                                                                                                                                                                                                Whoa!
    #> 79                                                                                                                                                                                                                Whoa!
    #> 80                                                                                                                                                                                                                Whoa!
    #> 81                                                                                                                                                                                         Treeger, what are you doing?
    #> 82                                                                                                                                                                                                          Mr. Treeger
    #> 83                                                                                                                                                                                                          Mr. Treeger
    #> 84  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 85  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 86  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 87                                                                                                                                                                                                           Oh my God!
    #> 88                                                                                                                                                                               Uh sir, may I see your tickets please?
    #> 89                                                                                                                                                                                                     Airline Employee
    #> 90                                                                                                                                                                                                     Airline Employee
    #> 91                                                                                                                                                                               Sir, this is not a first class ticket.
    #> 92                                                                                                                                                                                                    Apology accepted.
    #> 93                                                                                                                                                                                                                 Sir!
    #> 94                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 95                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 96                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 97                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 98                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 99                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 100                                                                                                                                                                                                Uh, Ross and Rachel.
    #> 101                                                                                                                                                                                                Uh, Ross and Rachel.
    #> 102                                                                                                                                                                                                    Rachel and Ross.
    #> 103                                                                                                                                                                                                    Rachel and Ross.
    #> 104                                                                                                                                                                                                               Ross?
    #> 105                                                                                                                                                                                                               Ross?
    #> 106                                                                                                                                                                  [Scene: Ross's Apartment, continued from earlier.]
    #> 107                                                                                                                                                                  [Scene: Ross's Apartment, continued from earlier.]
    #> 108                                                                                                                                                                                  Ross, there is no pressure on you.
    #> 109                                                                                                                                                              Okay Ross come on let's just forget about the condoms.
    #> 110                                                                                                                                                                                                Listen, y'know what?
    #> 111                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 112                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 113                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 114                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 115                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 116                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 117                                                                                                                                    And listen, could you do us a favor and not tell Chandler and Monica about this?
    #> 118                                                                                                                                    And listen, could you do us a favor and not tell Chandler and Monica about this?
    #> 119                                                                                                                                                                                                               Whoa!
    #> 120                                                                                                                                                                                                           Hey Ross!
    #> 121                                                                                                                                                    Could you tell Jasmine that I won't make it to yoga class today?
    #> 122                                                                                                                                                                                                            Namaste.
    #> 123                                                                                                                                                                         (Treeger leaves and Ross notices the door.)
    #> 124                                                                                                                                                                                                          Oh my God!
    #> 125                                                                                                                                                                                               Look, is Rachel here?
    #> 126                                                                                                                         Okay, okay look you guys know that Rachel and I slept together, but there's something else.
    #> 127                                                                                                                                                                                                  Rachel's pregnant.
    #> 128                                                                                                                                                                                                        Oh my God!!!
    #> 129                                                                                                                                                                                               Holy mother of God!!!
    #> 130                                                                                                                                                                                                            Oh Ross.
    #> 131                                                                                                                                                                                                               Whoa!
    #> 132                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 133                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 134                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 135                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 136                                                                                                                                                                                                    Front Desk Clerk
    #> 137                                                                                                                                                                                                    Front Desk Clerk
    #> 138                                                                                                                                                                                                    Front Desk Clerk
    #> 139                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 140                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 141                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 142                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 143                                                                                                                                                                                               Hey Monica it's Joey.
    #> 144                                                                                                                                                                                               Hey Monica it's Joey.
    #> 145                                                                                                                                                       Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 146                                                                                                                                                       Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 147                                                                                                                                                       Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 148                                                                                                                                                                                                    Joey smells gas!
    #> 149                                                                                                                          [Scene: A doctor's office, Rachel is on an examining table with her legs in the stirrups.]
    #> 150                                                                                                                                                                                   Okay Rachel, are you comfortable?
    #> 151                                                                                                                                                                                   Okay Rachel, are you comfortable?
    #> 152                                                                                                                      I mean I was thinking about myself when I really-I should have been thinking about you Rach...
    #> 153                                                                                                                                                                                                          Head Ross!
    #> 154                                                                                                                                                                                                          Head Ross!
    #> 155                                                                                                                                                                                                          Head Ross!
    #> 156                                                                                                                                                                                                          Head Ross!
    #> 157                                                                                                                                                                                                          Head Ross!
    #> 158                                                                                                                                                                                                          Head Ross!
    #> 159                                                                                                                                                                               But Ross, we are not in love, are we?
    #> 160                                                                                                                                                             Come on Rach, you can't even eat alone in a restaurant.
    #> 161                                                                                                                                                                                              I grew up with Monica!
    #> 162                                                                                                                                                                                                            Dr. Long
    #> 163                                                                                                                                                                                                            Dr. Long
    #> 164                                                                                                                                                                                     Oh no Dr. Long, please come in.
    #> 165                                                                                                                                                                                     Oh no Dr. Long, please come in.
    #> 166                                                                                                                                                                                     This is Ross, he is the father.
    #> 167                                                                                                                                                                                                          Oh my God.
    #> 168                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 169                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 170                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 171                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 172                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 173                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 174                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 175                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 176                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 177                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 178                                                                                                                                                                                              Ross, I lost it again.
    #>                                                                                                                                                                                                                Document
    #> 1                                                                                  [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon. Monica is entering from the bedroom.]
    #> 2                                                                                  [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon. Monica is entering from the bedroom.]
    #> 3                                                                                  [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon. Monica is entering from the bedroom.]
    #> 4                                                                                  [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon. Monica is entering from the bedroom.]
    #> 5                                                                                  [Scene: Monica and Chandler's, Monica and Chandler are getting ready to go on their honeymoon. Monica is entering from the bedroom.]
    #> 6                                                                                                                                                           Hey! Babe! Aren't you excited we're going on our honeymoon?
    #> 7                                                                                                                                                                                                         Chandler Bing
    #> 8                                                                                                                                                                                                         Chandler Bing
    #> 9                                                                                                                                                                                                         Monica Geller
    #> 10                                                                                                                                                                                                        Monica Geller
    #> 11                                                                                                                                                                              Bermuda, Bahama, come on pretty mama...
    #> 12                                                                                                                                                                              Bermuda, Bahama, come on pretty mama...
    #> 13                                                                                                                                                                                                       Joey Tribbiani
    #> 14                                                                                                                                                                                                       Joey Tribbiani
    #> 15                                                                                                                                                                                                        Phoebe Buffay
    #> 16                                                                                                                                                                                                        Phoebe Buffay
    #> 17                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 18                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 19                                                                                                                                             (Joey looks at him, Phoebe tries not to smile, and Chandler is shocked.)
    #> 20                                                                                                                                                                                                         Rachel Green
    #> 21                                                                                                                                                                                                         Rachel Green
    #> 22                                                                                                                                                                                   It was his sweater, but-Oh my God!
    #> 23                                                                                                                                               Oh, I so wanted Ross to know first, but I'm so relieved you guys know.
    #> 24                                                                                                          Okay. Great! So now that you guys all know you can help me. Give me some advice on how I'm gonna tell Ross!
    #> 25                                                                                                                                                                                                      (Rachel exits.)
    #> 26                                                                                                                             Well I guess there is no harm in telling you now, Rachel and Ross are gonna have a baby.
    #> 27                                                                                                                             Well I guess there is no harm in telling you now, Rachel and Ross are gonna have a baby.
    #> 28                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 29                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 30                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 31                                                                                                                                                            [Scene: Joey and Rachel's, Joey and Phoebe are entering.]
    #> 32                                                                                                     Y'know, Monica and Chandler are married. Ross and Rachel are having a baby. Maybe you and I should do something.
    #> 33                                                                                                     Y'know, Monica and Chandler are married. Ross and Rachel are having a baby. Maybe you and I should do something.
    #> 34                                                                                                     Y'know, Monica and Chandler are married. Ross and Rachel are having a baby. Maybe you and I should do something.
    #> 35                                                                                                     Y'know, Monica and Chandler are married. Ross and Rachel are having a baby. Maybe you and I should do something.
    #> 36                                                                                                                         You mean the time you broke the ketchup bottle and cleaned it up with Monica's guest towels?
    #> 37    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 38    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 39    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 40    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 41    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 42    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 43    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 44    Monica's chicken parm! I'll take care of it. Hey Mr. Treeger, it's Joey Tribbiani. Listen, I need to get into Monica and Chandler's apartment. It's an emergency. Uhh, gas leak! Yeah oh, and bring garlic bread.
    #> 45                                                                                                                                                                                                          Ross Geller
    #> 46                                                                                                                                                                                                          Ross Geller
    #> 47                                                                                                                                                                                                 Did Rachel find you?
    #> 48                                                                                                                                                                                        (Phoebe and Joey trade looks)
    #> 49                                                                                                                                                                                        (Phoebe and Joey trade looks)
    #> 50                                                                                                   Yeah. Uh, uh we promised we weren't gonna tell anybody this but uh, about a month ago Rachel and I slept together.
    #> 51                                                                                                                                                                       Please, just-just, just go and talk to Rachel.
    #> 52                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 53                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 54                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 55                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 56                                                                       [Scene: The Airport Ticket Counter, Monica and Chandler are standing in line behind another couple kissing who are next in line to be served.]
    #> 57                                                                                                                                                                                                         Ticket Agent
    #> 58                                                                                                                                                                                                         Ticket Agent
    #> 59                                                                                                                                                                                                                Woman
    #> 60                                                                                                                                     Congratulations. Okay, Mr. Bing you'll be in 25J and Mrs. Bing you'll be in 25K.
    #> 61                                                                                                                                     Congratulations. Okay, Mr. Bing you'll be in 25J and Mrs. Bing you'll be in 25K.
    #> 62                                                                                                                                     Congratulations. Okay, Mr. Bing you'll be in 25J and Mrs. Bing you'll be in 25K.
    #> 63                                                                                                                                     Congratulations. Okay, Mr. Bing you'll be in 25J and Mrs. Bing you'll be in 25K.
    #> 64                                                                                                                       You see, if we'd gone around them like I said, we-She would've given us those tickets. Damnit!
    #> 65                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 66                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 67                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 68                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 69                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 70                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 71                                                                                                                                   [Scene: Joey and Rachel's, Phoebe and Joey are playing Rock 'em, Sock 'em Robots.]
    #> 72                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 73                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 74                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 75                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 76                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 77                                                                                   (They go into the hallway and see Mr. Treeger watching one of New York's bravest breakdown Monica and Chandler's door with an ax.]
    #> 78                                                                                                                                                                       Whoa! Whoa! Whoa! Treeger, what are you doing?
    #> 79                                                                                                                                                                       Whoa! Whoa! Whoa! Treeger, what are you doing?
    #> 80                                                                                                                                                                       Whoa! Whoa! Whoa! Treeger, what are you doing?
    #> 81                                                                                                                                                                       Whoa! Whoa! Whoa! Treeger, what are you doing?
    #> 82                                                                                                                                                                                                          Mr. Treeger
    #> 83                                                                                                                                                                                                          Mr. Treeger
    #> 84  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 85  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 86  [Scene: The Airport, Chandler and Monica are following the previous couple through a tiny hallway that proves this is a set on a sound stage and not an actual airport, and see them enter the first class lounge.]
    #> 87                                                                                                                                                                                                  Oh my God! Oranges!
    #> 88                                                                                                                                                                               Uh sir, may I see your tickets please?
    #> 89                                                                                                                                                                                                     Airline Employee
    #> 90                                                                                                                                                                                                     Airline Employee
    #> 91                                                                                                                                                                    Sir, this is not a first class ticket. I'm sorry.
    #> 92                                                                                                                                                                                         Apology accepted. Excuse us.
    #> 93                                                                                                                                                                  Sir! I'm afraid I'm gonna have to ask you to leave.
    #> 94                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 95                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 96                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 97                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 98                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 99                                                                                   [Scene: The Hallway Outside Ross's Apartment, Ross is walking towards his apartment and sees Rachel sitting in front of the door.]
    #> 100                                                                                                                            Okay. Uh, Ross and Rachel. Rachel and Ross. That's been one heck of a see-saw hasn't it?
    #> 101                                                                                                                            Okay. Uh, Ross and Rachel. Rachel and Ross. That's been one heck of a see-saw hasn't it?
    #> 102                                                                                                                            Okay. Uh, Ross and Rachel. Rachel and Ross. That's been one heck of a see-saw hasn't it?
    #> 103                                                                                                                            Okay. Uh, Ross and Rachel. Rachel and Ross. That's been one heck of a see-saw hasn't it?
    #> 104                                                                                                         I'm pregnant. Ross? Ross? Okay, whenever you're ready. And you're the father by the way-but you got that...
    #> 105                                                                                                         I'm pregnant. Ross? Ross? Okay, whenever you're ready. And you're the father by the way-but you got that...
    #> 106                                                                                                                                                                  [Scene: Ross's Apartment, continued from earlier.]
    #> 107                                                                                                                                                                  [Scene: Ross's Apartment, continued from earlier.]
    #> 108                                                                                                                                    Ross, there is no pressure on you. Okay? I mean you can as involved as you want.
    #> 109                                                                                                                                                              Okay Ross come on let's just forget about the condoms.
    #> 110                                                                                                                                               Listen, y'know what? I was really freaked out too when I found out...
    #> 111                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 112                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 113                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 114                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 115                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 116                                                                                                                [Scene: Monica and Chandler's, Mr. Treeger has finished inspecting Monica and Chandler's apartment.]
    #> 117          Oh great! And listen, could you do us a favor and not tell Chandler and Monica about this? 'Cause y'know umm, they don't-they don't have any kids of their own and-and this door was like a child to them.
    #> 118          Oh great! And listen, could you do us a favor and not tell Chandler and Monica about this? 'Cause y'know umm, they don't-they don't have any kids of their own and-and this door was like a child to them.
    #> 119                                                                                                                                  Whoa! This looks like an all day job, I'll have to cancel my yoga class. Hey Ross!
    #> 120                                                                                                                                  Whoa! This looks like an all day job, I'll have to cancel my yoga class. Hey Ross!
    #> 121                                                                                                                                                    Could you tell Jasmine that I won't make it to yoga class today?
    #> 122                                                                                                                                                                                                            Namaste.
    #> 123                                                                                                                                                                         (Treeger leaves and Ross notices the door.)
    #> 124                                                                                                                                                                              Oh my God! What happened to the door?!
    #> 125                                                                                                                                                                 Look, is Rachel here? I really need to talk to her.
    #> 126                                                                                       Yeah but uh... Okay, okay look you guys know that Rachel and I slept together, but there's something else. Rachel's pregnant.
    #> 127                                                                                       Yeah but uh... Okay, okay look you guys know that Rachel and I slept together, but there's something else. Rachel's pregnant.
    #> 128                                                                                                                                                                                 Oh my God!!! I can't believe that!!
    #> 129                                                                                                                                                                                               Holy mother of God!!!
    #> 130                                                                                                                                                                                                            Oh Ross.
    #> 131                                                                                    Whoa! Hey! Whoa!! Hold up! Are you serious?! So like 3% of the time they don't even work?! Huh? They should put that on the box!
    #> 132                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 133                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 134                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 135                                                                                            [Scene: The Atlantis Resort, Chandler and Monica are arriving to check in, but are behind the couple from before again.]
    #> 136                                                                                                                                                                                                    Front Desk Clerk
    #> 137                                                                                                                                                                                                    Front Desk Clerk
    #> 138                                                                                                                                                                                                    Front Desk Clerk
    #> 139                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 140                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 141                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 142                                                                                                                                    [Scene: Monica and Chandler's, Joey is on the phone and Phoebe is watching him.]
    #> 143                                                                                                                                 Hey Monica it's Joey. Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 144                                                                                                                                 Hey Monica it's Joey. Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 145                                                                                                                                 Hey Monica it's Joey. Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 146                                                                                                                                 Hey Monica it's Joey. Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 147                                                                                                                                 Hey Monica it's Joey. Listen uh, Phoebe and I smell gas comin' from your apartment.
    #> 148                                                                                                                                                                            What? Are you serious?! Joey smells gas!
    #> 149                                                                                                                          [Scene: A doctor's office, Rachel is on an examining table with her legs in the stirrups.]
    #> 150                                                                                                                                                                                   Okay Rachel, are you comfortable?
    #> 151                                                                                                                                                                                   Okay Rachel, are you comfortable?
    #> 152                                                    What? Oh yeah. I'm sorry. I mean I-I think I went a little crazy. I mean I was thinking about myself when I really-I should have been thinking about you Rach...
    #> 153                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 154                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 155                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 156                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 157                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 158                                                                                                                                                                              Okay. Head Ross! Head Ross! Head Ross!
    #> 159                                                                                                                                                Yeah, maybe if you're in love. But Ross, we are not in love, are we?
    #> 160                                                                                                                                                             Come on Rach, you can't even eat alone in a restaurant.
    #> 161                                                                                                                                                      I grew up with Monica! If you didn't eat fast you didn't eat!!
    #> 162                                                                                                                                                                                                            Dr. Long
    #> 163                                                                                                                                                                                                            Dr. Long
    #> 164                                                                                                                                                     Oh no Dr. Long, please come in. This is Ross, he is the father.
    #> 165                                                                                                                                                     Oh no Dr. Long, please come in. This is Ross, he is the father.
    #> 166                                                                                                                                                     Oh no Dr. Long, please come in. This is Ross, he is the father.
    #> 167                                                                                                                                                                                                          Oh my God.
    #> 168                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 169                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 170                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 171                                                                                                                                                                          (Dr. Long exits and Rachel starts to cry.)
    #> 172                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 173                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 174                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 175                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 176                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 177                                                                                                      [Scene: Joey and Rachel's, Joey and Phoebe are there as Rachel and Ross return from the doctor's appointment.]
    #> 178                                                                                                                       Oh no, I know I couldn't see it either at first, but it's right umm... Ross, I lost it again.
    #>     Repeats Affected.Columns
    #> 1         1           `text`
    #> 2         1           `text`
    #> 3         1           `text`
    #> 4         1           `text`
    #> 5         1           `text`
    #> 6         1           `text`
    #> 7        22        `speaker`
    #> 8        22        `speaker`
    #> 9        31        `speaker`
    #> 10       31        `speaker`
    #> 11        1           `text`
    #> 12        1           `text`
    #> 13       38        `speaker`
    #> 14       38        `speaker`
    #> 15       33        `speaker`
    #> 16       33        `speaker`
    #> 17        1           `text`
    #> 18        1           `text`
    #> 19        1           `text`
    #> 20       56        `speaker`
    #> 21       56        `speaker`
    #> 22        1           `text`
    #> 23        1           `text`
    #> 24        1           `text`
    #> 25        1           `text`
    #> 26        1           `text`
    #> 27        1           `text`
    #> 28        1           `text`
    #> 29        1           `text`
    #> 30        1           `text`
    #> 31        1           `text`
    #> 32        1           `text`
    #> 33        1           `text`
    #> 34        1           `text`
    #> 35        1           `text`
    #> 36        1           `text`
    #> 37        1           `text`
    #> 38        1           `text`
    #> 39        1           `text`
    #> 40        1           `text`
    #> 41        1           `text`
    #> 42        1           `text`
    #> 43        1           `text`
    #> 44        1           `text`
    #> 45       68        `speaker`
    #> 46       68        `speaker`
    #> 47        1           `text`
    #> 48        1           `text`
    #> 49        1           `text`
    #> 50        1           `text`
    #> 51        1           `text`
    #> 52        1           `text`
    #> 53        1           `text`
    #> 54        1           `text`
    #> 55        1           `text`
    #> 56        1           `text`
    #> 57        6        `speaker`
    #> 58        6        `speaker`
    #> 59        2        `speaker`
    #> 60        1           `text`
    #> 61        1           `text`
    #> 62        1           `text`
    #> 63        1           `text`
    #> 64        1           `text`
    #> 65        1           `text`
    #> 66        1           `text`
    #> 67        1           `text`
    #> 68        1           `text`
    #> 69        1           `text`
    #> 70        1           `text`
    #> 71        1           `text`
    #> 72        1           `text`
    #> 73        1           `text`
    #> 74        1           `text`
    #> 75        1           `text`
    #> 76        1           `text`
    #> 77        1           `text`
    #> 78        1           `text`
    #> 79        1           `text`
    #> 80        1           `text`
    #> 81        1           `text`
    #> 82        8        `speaker`
    #> 83        8        `speaker`
    #> 84        1           `text`
    #> 85        1           `text`
    #> 86        1           `text`
    #> 87        1           `text`
    #> 88        1           `text`
    #> 89        4        `speaker`
    #> 90        4        `speaker`
    #> 91        1           `text`
    #> 92        1           `text`
    #> 93        1           `text`
    #> 94        1           `text`
    #> 95        1           `text`
    #> 96        1           `text`
    #> 97        1           `text`
    #> 98        1           `text`
    #> 99        1           `text`
    #> 100       1           `text`
    #> 101       1           `text`
    #> 102       1           `text`
    #> 103       1           `text`
    #> 104       1           `text`
    #> 105       1           `text`
    #> 106       1           `text`
    #> 107       1           `text`
    #> 108       1           `text`
    #> 109       1           `text`
    #> 110       1           `text`
    #> 111       1           `text`
    #> 112       1           `text`
    #> 113       1           `text`
    #> 114       1           `text`
    #> 115       1           `text`
    #> 116       1           `text`
    #> 117       1           `text`
    #> 118       1           `text`
    #> 119       1           `text`
    #> 120       1           `text`
    #> 121       1           `text`
    #> 122       2           `text`
    #> 123       1           `text`
    #> 124       1           `text`
    #> 125       1           `text`
    #> 126       1           `text`
    #> 127       1           `text`
    #> 128       1           `text`
    #> 129       1           `text`
    #> 130       1           `text`
    #> 131       1           `text`
    #> 132       1           `text`
    #> 133       1           `text`
    #> 134       1           `text`
    #> 135       1           `text`
    #> 136       1        `speaker`
    #> 137       1        `speaker`
    #> 138       1        `speaker`
    #> 139       1           `text`
    #> 140       1           `text`
    #> 141       1           `text`
    #> 142       1           `text`
    #> 143       1           `text`
    #> 144       1           `text`
    #> 145       1           `text`
    #> 146       1           `text`
    #> 147       1           `text`
    #> 148       1           `text`
    #> 149       1           `text`
    #> 150       1           `text`
    #> 151       1           `text`
    #> 152       1           `text`
    #> 153       1           `text`
    #> 154       1           `text`
    #> 155       1           `text`
    #> 156       1           `text`
    #> 157       1           `text`
    #> 158       1           `text`
    #> 159       1           `text`
    #> 160       1           `text`
    #> 161       1           `text`
    #> 162       4        `speaker`
    #> 163       4        `speaker`
    #> 164       1           `text`
    #> 165       1           `text`
    #> 166       1           `text`
    #> 167       1           `text`
    #> 168       1           `text`
    #> 169       1           `text`
    #> 170       1           `text`
    #> 171       1           `text`
    #> 172       1           `text`
    #> 173       1           `text`
    #> 174       1           `text`
    #> 175       1           `text`
    #> 176       1           `text`
    #> 177       1           `text`
    #> 178       1           `text`

The `report_on_folder` function is a high level API for the `pid_pos`
package and allows for various options to control the reporting process.
These optional arguments are:

- `tagger` - The proper noun tagger to use. The default is the
  “english-ewt” udpipe model, users can change this by either supplying
  a character string of an available udpipe model (see) or a custom
  tagger function. See … for details on implementing a custom tagger.
- `filter_func` - a function which takes a data frame of tagged tokens
  and filters it to the tokens of interest. By default, this is set to
  filter for proper nouns, but users can implement their own function to
  filter for other types of tokens e.g. locations, or dates. If using
  the udpipe taggers, the `upos` column contains the universal part of
  speech tags which can be used to filter for a wide range of token
  types.
- `chunk_size` - the number of rows to process at a time. This is
  designed to help with memory management when processing large files,
  but can be set to `NULL` to read in the whole file at once.
- `to_ignore` - a vector of column names to ignore when searching for
  proper nouns. This is designed to help with cases where there are
  known columns that contain proper nouns e.g. primary keys, or name
  columns. By default, this is set to `NULL` and all columns are
  processed.
- `export_function` - a function which takes the resulting data frames
  and exports them to the desired location. Two export functions are
  included in the package (`export_as_tree` to have the reports nested
  in the same folder structure as the raw data and `export_flat` to
  flatten the structure and capture the nested nature via file naming).
- `verbose` -

## Redacting

Aside from only tagging and reporting on where PID risks are - we may
also wish to redact the raw files. Doing this on a case-by-case basis is
cumbersome if working with large volumes of data, and so we introduce
equivalent functionality for the replacement of proper nouns.

The first step is to create a set of replacement rules modelled on the
PID reports. We will work on the assumption that replacements won’t
depend on the document or column the proper noun appears in
(e.g. whenever the phrase “Monica Geller” appears we want it to be
replaced with the same tokens). Hence, we combine all distinct proper
nouns reports:

``` r
distinct_rules <- get_distinct_redaction_rules("Proper Noun Report")
```

    #> Rows: 200 Columns: 6
    #> ── Column specification ────────────────────────────────────────────────────────
    #> Delimiter: ","
    #> chr (5): ID, Token, Sentence, Document, Affected Columns
    #> dbl (1): Repeats
    #> 
    #> ℹ Use `spec()` to retrieve the full column specification for this data.
    #> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    #> Rows: 178 Columns: 6
    #> ── Column specification ────────────────────────────────────────────────────────
    #> Delimiter: ","
    #> chr (5): ID, Token, Sentence, Document, Affected Columns
    #> dbl (1): Repeats
    #> 
    #> ℹ Use `spec()` to retrieve the full column specification for this data.
    #> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    #> Rows: 199 Columns: 6
    #> ── Column specification ────────────────────────────────────────────────────────
    #> Delimiter: ","
    #> chr (5): ID, Token, Sentence, Document, Affected Columns
    #> dbl (1): Repeats
    #> 
    #> ℹ Use `spec()` to retrieve the full column specification for this data.
    #> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

The replacements will be based on this data frame. The most conservative
approach to redaction is to use the `auto_replacement` and
`all_random_replacement.f` functions included in the package. The
`auto_replacement` function takes a data frame with `If`, `From` and
`To` and replaces the `To` column with a unique randomly generated
string, for example:

``` r
replacer <- all_random_replacement.f()
replaced_rules <- auto_replace(distinct_rules, replacer)
head(replaced_rules)
#> # A tibble: 6 × 3
#>   If                                                                 From  To   
#>   <chr>                                                              <chr> <chr>
#> 1 "[Scene: The Wedding Hall, Monica and Chandler have just said \"I… Wedd… MWLE…
#> 2 "[Scene: The Wedding Hall, Monica and Chandler have just said \"I… Hall  EEXO…
#> 3 "[Scene: The Wedding Hall, Monica and Chandler have just said \"I… Moni… ULBF…
#> 4 "[Scene: The Wedding Hall, Monica and Chandler have just said \"I… Chan… KGUF…
#> 5 "First of Monica, Chandler, Ross and Joey.]"                       Moni… TXVA…
#> 6 "First of Monica, Chandler, Ross and Joey.]"                       Chan… OREH…
```

The user may prefer to set the replacements manually by saving the
`distinct_rules` to file and manually setting the `To` column. The user
may prefer a hybrid approach, changing the `To` column to any value
(e.g. ’’ or ‘XXX’) and setting the `filter` argument of `auto_replace`
to `TRUE` so it only creates replacements where `From` and `To` don’t
match.

``` r
distinct_rules |>
  dplyr::mutate(
    To = ifelse(To == "Geller", "XXX", To)
  ) |>
  auto_replace(replacer, filter = TRUE)
#> # A tibble: 6 × 3
#>   If                                  From   To        
#>   <chr>                               <chr>  <chr>     
#> 1 Monica Geller                       Geller YHHADKJITR
#> 2 Ross Geller                         Geller XADGILYLUR
#> 3 Dr. Geller?                         Geller AYMHUSONGV
#> 4 Dr. Geller, will you dance with me? Geller BHAKFVSFAZ
#> 5 (Mr. Geller dances over.)           Geller XGITAQDVEE
#> 6 Jack Geller                         Geller MSVAKVCXOQ
```

With the `To` column set as desired, this frame can now be used in
`redact`:

``` r
redacted_rachell <- redact(rachell, replaced_rules)
redacted_rachell
#>                                                                                                                                                   text
#> 1 [Scene: YDCIDNLRPA and RZBZJRESTN's, YDCIDNLRPA and RZBZJRESTN are getting ready to go on their honeymoon. YDCIDNLRPA is entering from the bedroom.]
#> 2                                                                                    Hey! TPXHYZHUSK! Aren't you excited we're going on our honeymoon?
#> 3                                                                                                                                           Yeah I am!
#> 4                                                                                                       UIDDEWYHNC, GKHOXQJVJI, come on pretty mama...
#> 5                                                                                           That's right. Get it out of your system while we're alone.
#>                 speaker season episode scene utterance
#> 1      Scene Directions      8       3     1         1
#> 2 RZBZJRESTN BUEFSQXHVH      8       3     1         2
#> 3 EGSLQEQMFA AMREWKADGW      8       3     1         3
#> 4 RZBZJRESTN BUEFSQXHVH      8       3     1         4
#> 5 EGSLQEQMFA AMREWKADGW      8       3     1         5
```

And these redactions rules can be applied over the intial file structure
in much the way it was constructed:

``` r
redact_at_folder(data_path, replaced_rules)
#> $The_One_After_I_Do
#> [1] "Redacted Data/The_One_After_I_Do.csv"
#> 
#> $The_One_Where_Rachel_Tells
#> [1] "Redacted Data/The_One_Where_Rachel_Tells.csv"
#> 
#> $The_One_with_the_Red_Sweater
#> [1] "Redacted Data/The_One_with_the_Red_Sweater.csv"
```
