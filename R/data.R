#' The One in Massapequa
#'
#' A subset of the 'Friends' data set containing the scene, utterance, speaker and
#' text of the episode 'The One in Massapequa' (s8e18).
#'
#' @format  A data frame with 3,100 rows and 6 columns:
#' \describe{
#'   \item{scene}{The scene number (integer)}
#'   \item{utterance}{The utterance-by-scene number (integer)}
#'   \item{speaker}{The speaker of the utterance (character)}
#'   \item{text}{The text of the utterance (character)}
#' }
#'
"the_one_in_massapequa"


# sentence_frm
#' A short data frame of free text including PID.  Used for basic examples
#' and tests.
#'
#' @format  A data frame with 5 rows and 4 columns:
#' \describe{
#'   \item{ID}{The row number (integer)}
#'   \item{Sentence}{The free text to detect PID in.}
#'   \item{Numeric}{Example numeric data (discrete) to be ignored by the algorithm}
#'   \item{Random}{Example numeric data (continuous) to be ignored by the algorithm}
#' }
#'
"sentence_frm"


#' raw_redaction_rules
#' An example of a redaction rules produced by the `data_frame_report` function.
#' It is made using the first 20 rows of `the_one_in_massapequa` data set.
#'
#' \describe{
#'  \item{If}{The text to be redacted (character)}  
#'  \item{From}{The text to be replaced (character)}
#'  \item{To}{The text to replace it with (character)}
#' }
#' 
"raw_redaction_rules"