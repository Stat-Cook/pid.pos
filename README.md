# pid.pos

A package of tools for the detection of personally identifiable data (PID) in data sets via natural language processing.  Considers there to be a risk of PID when a data set contains any text element that is considered to be a 'proper noun'.

To install from github straight into R, use:

``` 
devtools::install_github("https://github.com/Stat-Cook/pid.pos")

```

The point of entry for most users will be the `report_on_folder` function.  This function is designed to allow for the checking of multiple data files in a shared folder structure.  If the top level folder path is given as the 1st argument to `report_on_folder`, the function iterates through each file (csv, xls, xlsx) checking for proper nouns (NB: at present only checks the first sheet of excel files).  The variables which contain proper nouns are summarized in an excel report file of the same name as the raw data file - listing the proper noun detected, the context and which variables of the data set contained it.

## Troubleshooting 

The package is a problem centered API build on  UDPipe tree banks via the `udpipe` R package.  Fetching the appropriate udpipe model is intended to be automatic, however if there are issues it is worth looking at the functions `browse_udpipe_repo` and `browse_model_location`.

