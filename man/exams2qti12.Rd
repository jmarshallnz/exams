\name{exams2qti12}
\alias{exams2qti12}
\alias{make_itembody_qti12}
\alias{exams2qti21}
\alias{make_itembody_qti21}
\alias{exams2qti}
\alias{make_itembody_qti}

\title{Generation of Exams in IMS QTI 1.2 and 2.1 Format}

\description{
  Automatic generation of exams in IMS QTI 1.2 and 2.1 format.
}

\usage{
  exams2qti12(file, n = 1L, nsamp = NULL, dir = ".",
    name = NULL, quiet = TRUE, edir = NULL,
    tdir = NULL, sdir = NULL, verbose = FALSE, rds = FALSE,
    resolution = 100, width = 4, height = 4, svg = FALSE, encoding = "UTF-8",
    num = NULL, mchoice = NULL,
    schoice = mchoice, string = NULL, cloze = NULL,
    template = "qti12", duration = NULL,
    stitle = "Exercise", ititle = "Question",
    adescription = "Please solve the following exercises.",
    sdescription = "Please answer the following question.",
    maxattempts = 1, cutvalue = 0, solutionswitch = TRUE,
    zip = TRUE, points = NULL,
    eval = list(partial = TRUE, negative = FALSE),
    converter = NULL, envir = NULL, xmlcollapse = FALSE,
    flavor = c("plain", "openolat", "canvas", "ilias"), \dots)

  exams2qti21(file, n = 1L, nsamp = NULL, dir = ".",
    name = NULL, quiet = TRUE, edir = NULL,
    tdir = NULL, sdir = NULL, verbose = FALSE, rds = FALSE,
    resolution = 100, width = 4, height = 4, svg = FALSE, encoding  = "UTF-8",
    num = NULL, mchoice = NULL,
    schoice = mchoice, string = NULL, cloze = NULL,
    template = "qti21", duration = NULL,
    stitle = "Exercise", ititle = "Question",
    adescription = "Please solve the following exercises.", sdescription = "",
    maxattempts = 1, cutvalue = NULL, solutionswitch = TRUE, casesensitive = TRUE,
    navigation = "nonlinear", allowskipping = TRUE, allowreview = FALSE,
    allowcomment = FALSE, shufflesections = FALSE, zip = TRUE, points = NULL,
    eval = list(partial = TRUE, negative = FALSE),
    converter = NULL, envir = NULL, base64 = TRUE, mode = "hex",
    include = NULL, \dots)

  make_itembody_qti12(rtiming = FALSE, shuffle = FALSE,
    rshuffle = shuffle, minnumber = NULL, maxnumber = NULL,
    defaultval = NULL, minvalue = NULL, maxvalue = NULL,
    cutvalue = NULL, enumerate = TRUE, digits = NULL,
    tolerance = is.null(digits), maxchars = 12,
    eval = list(partial = TRUE, negative = FALSE),
    fix_num = TRUE, flavor = "plain")

  make_itembody_qti21(shuffle = FALSE, defaultval = NULL,
    minvalue = NULL, maxvalue = NULL, enumerate = TRUE,
    digits = NULL, tolerance = is.null(digits), maxchars = 12,
    eval = list(partial = TRUE, negative = FALSE),
    solutionswitch = TRUE, casesensitive = TRUE)
}

\arguments{
  \item{file}{character. A specification of a (list of) exercise files.}
  \item{n}{integer. The number of copies to be compiled from \code{file}.}
  \item{nsamp}{integer. The number(s) of exercise files sampled from each
    list element of \code{file}. Sampling without replacement is used
    if possible. (Only if some element of \code{nsamp} is larger than
    the length of the corresponding element in \code{file}, sampling
    with replacement is used.)}
  \item{dir}{character. The default is the current working directory.}
  \item{name}{character. A name prefix for resulting exercises and ZIP file.}
  \item{quiet}{logical. Should output be suppressed when calling
    \code{\link[exams]{xweave}}?}
  \item{edir}{character specifying the path of the directory (along with its
    sub-directories) in which the files in \code{file} are stored
    (see also \code{\link{xexams}}).}
  \item{tdir}{character specifying a temporary directory, by default
    this is chosen via \code{\link[base]{tempfile}}. Note that this
    is cleaned up (i.e., existing files are deleted) and only certain
    temporary files are preserved.}
  \item{sdir}{character specifying a directory for storing supplements, by
    default this is chosen via \code{\link[base]{tempfile}}.}
  \item{verbose}{logical. Should information on progress of exam generation
    be reported?}
  \item{rds}{logical indicating whether the return list should also be
    saved as an RDS data file.}
  \item{resolution, width, height}{numeric. Options for rendering PNG (or SVG)
    graphics passed to \code{\link[exams]{xweave}}.}
  \item{svg}{logical. Should graphics be rendered in SVG or PNG (default)?}
  \item{encoding}{character, ignored. The encoding is always assumed to be UTF-8.}
  \item{num}{function or named list applied to numerical (i.e., type \code{num})
    questions. If \code{num} is a function, \code{num} will be used
    for generating the item body of the question, see function \code{make_itembody_qti12()}
    (or \code{make_itembody_qti21()}).
    If \code{num} is a named list, these arguments will be passed to function
    \code{make_itembody_qti12()} (or \code{make_itembody_qti21()} using \code{exams2qti21()}).}
  \item{mchoice, schoice, string, cloze}{function or named list applied to multiple choice,
    single choice, string, and cloze questions (i.e., type \code{mchoice}, \code{schoice},
    \code{string}, and \code{cloze}), respectively. See argument \code{num} for more details.}
  \item{template}{character. The IMS QTI 1.2 or 2.1 template that should be used. Currently,
    the package provides \code{"qti12.xml"} and \code{"qti21.xml"}.}
  \item{duration}{integer. Set the duration of the exam in minutes.}
  \item{stitle}{character. A title that should be used for the sections. May be a vector of
    length 1 to use the same title for each section, or a vector containing different section
    titles.}
  \item{ititle}{character. A title that should be used for the assessment items. May be a vector
    of length 1 to use the same title for each item, or a vector containing different item
    titles. Note that the maximum of different item titles is the number of sections/questions
    that are used for the exam.}
  \item{adescription}{character. Description (of length 1) for the overall assessment (i.e., exam).}
  \item{sdescription}{character. Vector of descriptions for each section, omitted if empty
    (or \code{NULL} or \code{FALSE}).}
  \item{maxattempts}{integer. The maximum attempts for one question. This may also be a vector
    so that the maximum number of attempts varies across questions. A value of \code{Inf} or
    \code{0} signals that the attempts per question are not limited.}
  \item{cutvalue}{numeric. The cutvalue at which the exam is passed.}
  \item{solutionswitch}{logical. Should the question/item solutionswitch be enabled?
    In OLAT this means that the correct solution is shown after an incorrect solution
    was entered by an examinee (i.e., this is typically only useful if \code{maxattempts = 1}).}
  \item{casesensitive}{logical. Should the evaluation of string exercises be case sensitive?}
  \item{navigation}{character. Mode of navigation, can either be \code{"nonlinear"} (default)
    or \code{"linear"}. The former means that test participants can switch back and forth
    between questions while the latter implies that the questions need to be answered sequentially.}
  \item{allowskipping}{logical. Can a question/section be skipped (default) or must it be answered?}
  \item{allowreview}{logical. Can questions be viewed again at the end of a test/exam or not (default)?}
  \item{allowcomment}{logical. Are comments allowed?}
  \item{shufflesections}{logical or character. Should the order of the sections be shuffled?
    If \code{TRUE} an extra outer section is included within which the sections are shuffled automatically.
    If a character string is specified, this implies \code{TRUE} and is then used as the title
    for the outer section.}
  \item{zip}{logical. Should the resulting XML file (plus supplements) be zipped?}
  \item{points}{integer. How many points should be assigned to each exercise? Note that this
    argument overules any exercise points that are provided within an \code{"\expoints{}"} tag
    in the \code{.Rnw} file. The vector of points supplied is expanded to the number of exercises in
    the exam.}
  \item{eval}{named list, specifies the settings for the evaluation policy, see function
    \code{\link{exams_eval}}.}
  \item{base64}{logical. Should supplementary files be embedded using Base 64 coding?
    Argument \code{base64} may also be a character vector of file suffixes that should be encoded, e.g.
    \code{base64 = c("png", "rda")} will only encode PNG images and binary \code{.rda} files.
    If set to \code{NULL} only image files will be encoded.}
  \item{mode}{character. See function \code{\link[tth]{tth}}.}
  \item{include}{character, paths of extra files that should be included within the final
    \code{.zip}-file.}
  \item{rtiming, shuffle, rshuffle, minnumber, maxnumber, defaultval, minvalue,
    maxvalue}{arguments used for IMS QTI 1.2 item construction, for details see the XML
    specification (see IMS Global Learning Consortium, Inc. 2012), especially Section 4.
    Genereting IMS QTI 2.1 items using \code{exams2qti21()} the arguments have similar meaning.}
  \item{enumerate}{logical. Insert potential solutions in enumerated list?}
  \item{digits}{integer. How many digits should be used for \code{num} exercises?}
  \item{tolerance}{logical. Should tolerance intervals be used for checking if the supplied
    \code{num} answer/number is correct? The default is to use tolerance intervals if \code{digits = NULL}.}
  \item{maxchars}{numeric. Lower bound for the number of characters in fill-in-blank
    fields. The actual number of characters is selected as the maximum number of
    characters of this value and the actual solution.}
  \item{fix_num}{logical. This is a special flag to enable/force the display of the
    correct solutions for numeric exercises/answers as well as to obtain results when archiving tests.
    Note that this is a workaround, which works e.g. within OLAT.}
  \item{converter}{character. Argument passed on to \code{make_exercise_transform_html}.
    The default for \code{converter} is set to \code{"ttm"} unless there are Rmd
    exercises in \code{file} where \code{"pandoc"} is used.}
  \item{envir}{passed to \code{\link[exams]{xweave}}.}
  \item{xmlcollapse}{logical or character. Should line breaks be collapsed in the XML
    code. If \code{TRUE} everything is collapsed with spaces (\code{" "}) but other collapse
    characters could be supplied.}
  \item{flavor}{character. Which QTI 1.2 \dQuote{flavor} should be used? Some learning
    management systems require that the QTI XML tags are used in a rather specific
    and idiosyncratic way. Typically, users should not set this argument directly but
    use the convenience interfaces \code{\link{exams2openolat}}, \code{\link{exams2canvas}}, 
    or \code{\link{exams2ilias}} instead (which use the \code{flavor} argument internally
    along with further customizations).}
  \item{\dots}{further arguments passed on to \code{make_exercise_transform_html}.}
}

\details{
  The Question & Test Interoperability (QTI) is an international XML standard for specifying
  e-learning tests (IMS Global Learning Consortium, Inc. 2012ab). The standard evolved over various
  versions with the first release culminating in the QTI 1.2 standard and the stable version
  of the second release at QTI 2.1. While both versions share many similarities, they also
  differ in many details. Hence, separate functions \code{exams2qti12} and \code{exams2qti21} are
  provided. As the QTI standard is quite flexible, different learning management systems employ
  the standard is slightly different ways. This is reflected by the \code{flavor} argument
  and dedicated interfaces \code{\link{exams2canvas}} and \code{\link{exams2ilias}} (both based
  on QTI 1.2) and \code{\link{exams2openolat}} (based on either QTI 2.1 or 1.2) are provided
  for the learning management systems Canvas, Ilias, and OLAT/OpenOlat, respectively.

  \code{exams2qti12} produces a \code{.zip} file that may be uploaded into different learning
  management systems (see above). This includes the final XML file of the exam/assessment as well
  as possible supplement folders that include images, data sets etc. used for the exam. It
  proceeds by (1) calling \code{\link[exams]{xweave}} on each exercise, (2) reading the
  resulting Markdown and/or LaTeX code, (3) transforming the Markdown/LaTeX code to HTML,
  and (4) embedding the HTML code in a XML file using the IMS QTI 1.2 standards for assessments and
  question items.

  For steps (1) and (2) the standard drivers in \code{xexams} are used. In step (3), a suitable
  transformation function is set up on the fly using \code{make_exercise_transform_html}, see also
  the details section in \code{\link{exams2html}}.

  For step (4), the function will cycle through all questions and exams to generate the final XML
  file in IMS QTI 1.2 standard. Therefore, each question will be included in the XML as one "section".
  The replicates of each question will be written as question items of the section.
  The default XML template generates exams/assessments that sample one replicate of a question/item
  for each section. Typically, the learning management systems sample the items from the different
  sections independently so that one participant might receive the first random replication from
  the first exercise but the third random replication from the second exercise, and so on.

  Templates other than the default \code{qti12.xml} provided in the \code{xml} folder of
  this package could in principle also be specified. However, adapting these is a bit technical.
  The assessment template must provide one section including one item. \code{exams2qti12} will then
  use the single item template to generate all items, as well as the assessment and section specifications set within the template.
  Note that all specifiers that have a leading \code{##} in the XML template will be replaced by suitable code in
  \code{exams2qti12} and should always be provided in the template. I.e., the user may add
  additional tags to the XML template or modify certain specifications, like the number of
  replicates/items that should be sampled for each section etc.

  By default, the individual question/item bodies are generated by function
  \code{make_itembody_qti12}, i.e. \code{make_itembody_qti12} checks the type of the question and
  will produce suitable XML code. Note that for each question type, either the arguments of
  \code{make_itembody_qti12} may be set within \code{num}, \code{mchoice}, \code{schoice},
  \code{string} and \code{cloze} in \code{exams2qti12}, by providing a named list of specifications
  that should be used, or for each questiontype, a function that produces the item body XML code may
  be provided to \code{num}, \code{mchoice}, \code{schoice}, \code{string} and \code{cloze}. E.g.,
  \code{mchoice = list(shuffle = TRUE)} will force only multiple choice questions to have a shuffled
  answerlist.

  Note that in older OLAT/OpenOlat versions with QTI 1.2, \code{num} exercises are not officially supported but in fact work
  correctly. The only drawback is that in certain settings the correct solution is not shown at the
  end of the assessment (although it is used for all internal computations). Therefore, two workarounds
  are implemented. Either \code{fix_num} can be set to \code{TRUE} (default), then a fix is added
  by double-checking the result, or \code{digits} can be set to a fixed value (e.g., \code{digits = 2}).
  In the latter case, the \code{num} exercise is represented by a \code{string}. Then the answer must
  be provided exactly to the decimal places specified (e.g., if the exact solution is 16.4562, then the
  correct answer in the test will be \code{"16.46"}, i.e., a character string of 5 characters).

  Generating exams/assessment in IMS QTI 2.1 format using \code{exams2qti21()} and \code{make_itembody_qti21()}
  is performed in a similar way as described above.
}

\references{
IMS Global Learning Consortium, Inc. (2012a).
\emph{IMS Question & Test Interoperability: ASI XML Binding Specification Final Specification Version 1.2}.
\url{https://www.imsglobal.org/question/qtiv1p2/imsqti_asi_bindv1p2.html}

IMS Global Learning Consortium, Inc. (2012b).
\emph{IMS Question & Test Interoperability (QTI) XSD Binding Version 2.1 Final}.
\url{https://www.imsglobal.org/question/qtiv2p1/imsqti_bindv2p1.html}

Zeileis A, Umlauf N, Leisch F (2014).
  Flexible Generation of E-Learning Exams in R: Moodle Quizzes, OLAT Assessments, and Beyond.
  \emph{Journal of Statistical Software}, \bold{58}(1), 1--36.
  \doi{10.18637/jss.v058.i01}.
}

\value{
  \code{exams2qti12} and \code{exams2qti21} return a list of exams as generated by \code{\link[exams]{xexams}}.

  \code{make_itembody_qti12} and \code{make_itembody_qti21} return a function that generates the XML code
  for the itembody tag in IMS QTI 1.2 and IMS QTI 2.1 format.
}

\seealso{
  \code{\link[exams]{xexams}},
  \code{\link[tth]{ttm}},
  \code{\link[tth]{tth}},
  \code{\link[exams]{tex2image}},
  \code{\link[exams]{make_exercise_transform_html}},
}

\examples{
## load package and enforce par(ask = FALSE)
library("exams")
options(device.ask.default = FALSE)

## define an exams (= list of exercises)
myexam <- list(
  "boxplots",
  c("tstat", "ttest", "confint"),
  c("regression", "anova"),
  c("scatterplot", "boxhist"),
  "relfreq"
)

## output directory
dir.create(mydir <- tempfile())

## generate .zip with QTI 1.2 exam in temporary directory
## using a few customization options
exams2qti12(myexam, n = 3, dir = mydir,
  maxattempts = 3,
  num = list(digits = 1),
  mchoice = list(shuffle = TRUE, enumerate = FALSE)
)
dir(mydir)
}

\keyword{utilities}
